import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pos_gmedia_test/core/constant/colors.dart';
import '../../../data/models/cart_item/cart_item.dart';
import '../bloc/cart_item/cart_item_bloc.dart';
import 'package:badges/badges.dart' as badges;

import '../../../core/components/add_category_form.dart';
import '../../../core/components/add_product_form.dart';
import '../../auth/bloc/logout/logout_bloc.dart';
import '../../auth/pages/login_page.dart';
import '../bloc/delete_product/delete_product_bloc.dart';
import '../bloc/get_category/get_category_bloc.dart';
import '../bloc/get_product/get_product_bloc.dart';
import '../../../../data/datasources/product_remote_datasource.dart';
import '../bloc/add_category/add_category_bloc.dart';
import '../bloc/add_product/add_product_bloc.dart';
import '../../../../data/datasources/category_remote_datasource.dart';
import 'cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    context.read<GetCategoryBloc>().add(GetCategoryEvent.getCategory());
  }

  void _showAddCategoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: BlocProvider(
            create: (context) => AddCategoryBloc(CategoryRemoteDataSource()),
            child: AddCategoryForm(),
          ),
        );
      },
    );
  }

  void _showAddProductModal(BuildContext context, {String? categoryId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: BlocProvider(
            create: (context) => AddProductBloc(ProductRemoteDataSource()),
            child: AddProductForm(categoryId: categoryId!),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: SafeArea(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.add_shopping_cart_rounded),
                  title: const Text('Add Category'),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the drawer first
                    _showAddCategoryModal(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add_box_rounded),
                  title: const Text('Add Product'),
                  onTap: () {
                    if (selectedCategoryId != null) {
                      Navigator.of(context).pop(); // Close the drawer first
                      _showAddProductModal(context,
                          categoryId: selectedCategoryId);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select a category first'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Center(
                          child: BlocConsumer<LogoutBloc, LogoutState>(
                            listener: (context, state) {
                              state.maybeMap(
                                success: (_) {
                                  Navigator.of(context).pop(); // Tutup dialog
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                error: (value) {
                                  Navigator.of(context).pop(); // Tutup dialog
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(value.error),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                },
                                orElse: () {},
                              );
                            },
                            builder: (context, state) {
                              return state.maybeWhen(
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                                orElse: () => Container(),
                              );
                            },
                          ),
                        );
                      },
                    );

                    context.read<LogoutBloc>().add(LogoutEvent.logout());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('MASPOS'),
              Icon(Icons.search),
            ],
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<CartItemBloc, CartItemState>(
        builder: (context, state) {
          int cartItemCount = 0;
          if (state is CartLoaded) {
            cartItemCount = state.cartItems.length;
          }

          return FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
            child: badges.Badge(
              badgeContent: Text(
                '$cartItemCount',
                style: TextStyle(color: Colors.white),
              ),
              child: Icon(Icons.shopping_cart),
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: BlocBuilder<GetCategoryBloc, GetCategoryState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: Text('No categories loaded')),
              loading: () => const Center(child: CircularProgressIndicator()),
              success: (categoryResponseModel) {
                if (selectedCategoryId == null &&
                    categoryResponseModel.data!.isNotEmpty) {
                  selectedCategoryId = categoryResponseModel
                      .data!.first.id; // Select the first category by default
                }
                return ListView.builder(
                  itemCount: categoryResponseModel.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final category = categoryResponseModel.data![index];
                    return BlocProvider(
                      create: (context) =>
                          GetProductBloc(ProductRemoteDataSource())
                            ..add(GetProductEvent.getProductsByCategory(
                                category.id!)),
                      child: BlocBuilder<GetProductBloc, GetProductState>(
                        builder: (context, productState) {
                          return productState.when(
                            initial: () => Container(),
                            loading: () => const CircularProgressIndicator(),
                            success: (productResponseModel) {
                              return BlocListener<DeleteProductBloc,
                                  DeleteProductState>(
                                listener: (context, deleteState) {
                                  deleteState.whenOrNull(
                                    success: (message) {
                                      // Ambil ulang produk setelah penghapusan berhasil
                                      context.read<GetProductBloc>().add(
                                          GetProductEvent.getProductsByCategory(
                                              category.id!));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Product deleted successfully'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    },
                                    error: (error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(error),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        category.name ?? 'Category',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: productResponseModel
                                                  .data?.length ??
                                              0,
                                          itemBuilder: (context, productIndex) {
                                            final product = productResponseModel
                                                .data![productIndex];
                                            return Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              margin: const EdgeInsets.only(
                                                right: 16.0,
                                                bottom: 10.0,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.background,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    spreadRadius: 3,
                                                    blurRadius: 7,
                                                    offset: const Offset(1, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                      child: Image.network(
                                                        product.pictureUrl ??
                                                            '',
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              product.name !=
                                                                          null &&
                                                                      product.name!
                                                                              .length >
                                                                          10
                                                                  ? '${product.name?.substring(0, 10)}...'
                                                                  : product
                                                                          .name ??
                                                                      'Product',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          AlertDialog(
                                                                    title: Text(
                                                                        'Delete Product'),
                                                                    content: Text(
                                                                        'Are you sure you want to delete this product?'),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.of(context).pop(),
                                                                        child: Text(
                                                                            'Cancel'),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          context
                                                                              .read<DeleteProductBloc>()
                                                                              .add(
                                                                                DeleteProductEvent.deleteProduct(productId: product.id!),
                                                                              );
                                                                          Navigator.of(context)
                                                                              .pop(); // Tutup dialog
                                                                        },
                                                                        child: Text(
                                                                            'Delete'),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child: Text(
                                                                  'Delete',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Text(
                                                          '${formatCurrency.format(product.price ?? 0)}',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 28),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom:
                                                                        15.0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                final cartItem =
                                                                    CartItem(
                                                                  product:
                                                                      product,
                                                                  quantity: 1,
                                                                );
                                                                context
                                                                    .read<
                                                                        CartItemBloc>()
                                                                    .add(CartItemEvent
                                                                        .addToCart(
                                                                            cartItem));
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        'Added to cart'),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            1),
                                                                  ),
                                                                );
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  horizontal: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      9.1,
                                                                  vertical: 6,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppColors.primary,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child: Text(
                                                                  '+ Add to Cart',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: AppColors.background,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            error: (message) =>
                                Center(child: Text('Error: $message')),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              error: (message) => Center(child: Text('Error: $message')),
            );
          },
        ),
      ),
    );
  }
}
