import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_gmedia_test/core/constant/colors.dart';

import '../../auth/bloc/logout/logout_bloc.dart';
import '../../auth/pages/login_page.dart';
import '../bloc/get_category/get_category_bloc.dart';
import '../bloc/get_product/get_product_bloc.dart';
import '../../../../data/datasources/product_remote_datasource.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Memicu pengambilan data kategori saat halaman diinisialisasi
    context.read<GetCategoryBloc>().add(GetCategoryEvent.getCategory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
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
                                      builder: (context) => const LoginPage()),
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: BlocBuilder<GetCategoryBloc, GetCategoryState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: Text('No categories loaded')),
              loading: () => const Center(child: CircularProgressIndicator()),
              success: (categoryResponseModel) {
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
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        itemCount:
                                            productResponseModel.data?.length ??
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
                                            ), // Add bottom margin
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
                                                  offset: const Offset(1,
                                                      2), // changes position of shadow
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
                                                            topLeft: Radius
                                                                .circular(10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10)),
                                                    child: Image.network(
                                                      product.pictureUrl ?? '',
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
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
                                                            product.name ??
                                                                'Product',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {},
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          4),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .error,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child: Text(
                                                                'Delete',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: AppColors
                                                                        .background,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        'Rp. ${product.price?.toStringAsFixed(0) ?? '0'}',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                          height: 28),
                                                      Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 15.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {},
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      9.1,
                                                                  vertical: 6),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .primary,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child: Text(
                                                                '+ Add to Cart',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: AppColors
                                                                        .background,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
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
