import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_gmedia_test/core/constant/colors.dart';

import '../../presentation/home/bloc/add_product/add_product_bloc.dart';
import '../../presentation/home/bloc/get_category/get_category_bloc.dart';

class AddProductForm extends StatefulWidget {
  final String categoryId;

  AddProductForm({required this.categoryId});

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  XFile? _selectedImage;
  String? _selectedCategoryId;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddProductBloc, AddProductState>(
      listener: (context, state) {
        state.maybeWhen(
          success: (data) {
            // Panggil ulang GetProductEvent.getProductsByCategory() untuk memuat ulang produk setelah sukses
            context.read<GetCategoryBloc>().add(GetCategoryEvent.getCategory());

            // Tutup modal bottom sheet
            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Product "${data.data?.name}" added successfully!'),
              backgroundColor: Colors.green,
            ));
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to add product: $message'),
              backgroundColor: AppColors.error,
            ));
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dropdown to select category
              BlocBuilder<GetCategoryBloc, GetCategoryState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const SizedBox.shrink(),
                    loading: () => const CircularProgressIndicator(),
                    success: (categoryResponseModel) {
                      return DropdownButtonFormField<String>(
                        value: _selectedCategoryId ?? widget.categoryId,
                        decoration: InputDecoration(
                            labelText: 'Select Category',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                        items: categoryResponseModel.data!
                            .map<DropdownMenuItem<String>>((category) {
                          return DropdownMenuItem<String>(
                            value: category.id,
                            child: Text(category.name ?? ''),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value!;
                          });
                        },
                      );
                    },
                    error: (message) =>
                        Text('Error loading categories: $message'),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Product Name
              TextField(
                controller: _productNameController,
                decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 16),
              // Product Price
              TextField(
                controller: _productPriceController,
                decoration: InputDecoration(
                    labelText: 'Product Price',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 16),
              // Upload Image
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.background,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedImage == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload, color: Colors.grey),
                            SizedBox(width: 8),
                            Text('Upload Product Image'),
                          ],
                        )
                      : Image.file(
                          File(_selectedImage!.path),
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 16),
              // Submit Button
              state.maybeWhen(
                loading: () => CircularProgressIndicator(),
                orElse: () => GestureDetector(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Add Product',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    final productName = _productNameController.text.trim();
                    final productPrice = _productPriceController.text.trim();
                    if (productName.isNotEmpty &&
                        productPrice.isNotEmpty &&
                        _selectedImage != null &&
                        _selectedCategoryId != null) {
                      context.read<AddProductBloc>().add(
                            AddProductEvent.addProduct(
                              categoryId: _selectedCategoryId!,
                              name: productName,
                              price: productPrice,
                              picturePath: _selectedImage!.path, // Ini penting
                            ),
                          );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Please fill in all fields and upload an image'),
                        backgroundColor: AppColors.error,
                      ));
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
