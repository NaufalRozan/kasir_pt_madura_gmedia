import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:pos_gmedia_test/data/datasources/auth_local_datasource.dart';
import 'package:pos_gmedia_test/data/models/category_response_model.dart';
import 'package:http/http.dart' as http;

import '../../core/constant/variables.dart';
import '../models/add_category_response_model.dart';

class CategoryRemoteDataSource {
  Future<Either<String, CategoryResponseModel>> getCategory() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/v1/category');
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData?.data?.token}',
    };

    try {
      final response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        final categoryData = CategoryResponseModel.fromJson(response.body);
        return right(categoryData);
      } else {
        return left('Failed to fetch categories: ${response.body}');
      }
    } catch (e) {
      return left('Error: $e');
    }
  }

  Future<Either<String, AddCategoryResponseModel>> addCategory(
      String name) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/v1/category');
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData?.data?.token}',
    };

    final body = jsonEncode({
      'name': name,
    });

    try {
      print('Request Body: $body');
      final response = await http.post(url, headers: header, body: body);
      print('Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final categoryData = AddCategoryResponseModel.fromJson(response.body);
        return right(categoryData);
      } else {
        return left('Failed to add category: ${response.body}');
      }
    } catch (e) {
      return left('Error: $e');
    }
  }
}
