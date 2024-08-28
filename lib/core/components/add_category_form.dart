import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_gmedia_test/core/constant/colors.dart';

import '../../presentation/home/bloc/add_category/add_category_bloc.dart';
import '../../presentation/home/bloc/get_category/get_category_bloc.dart';

class AddCategoryForm extends StatelessWidget {
  final _categoryNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddCategoryBloc, AddCategoryState>(
      listener: (context, state) {
        state.maybeWhen(
          success: (data) {
            // Panggil ulang GetCategoryEvent.getCategory() untuk memuat ulang kategori setelah sukses
            context.read<GetCategoryBloc>().add(GetCategoryEvent.getCategory());

            // Tutup modal bottom sheet
            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Category "${data.data?.name}" added successfully!'),
              backgroundColor: Colors.green,
            ));
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to add category: $message'),
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
              TextField(
                controller: _categoryNameController,
                decoration: InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(height: 16),
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
                        'Add Category',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    final categoryName = _categoryNameController.text.trim();
                    if (categoryName.isNotEmpty) {
                      context.read<AddCategoryBloc>().add(
                            AddCategoryEvent.addCategory(categoryName),
                          );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please fill in the category name'),
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
