import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../core/constant/variables.dart';
import '../models/add_product_response_model.dart';
import '../models/product_response_model.dart';
import 'auth_local_datasource.dart';
import 'package:http/http.dart' as http;

class ProductRemoteDataSource {
  Future<Either<String, ProductResponseModel>> getProductsByCategory(
      String categoryId) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final url = Uri.parse(
        '${Variables.baseUrl}/api/v1/product?category_id=$categoryId'); // Pastikan ini sesuai dengan API kamu
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData?.data?.token}',
    };

    try {
      final response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        final productData = ProductResponseModel.fromJson(response.body);
        return right(productData);
      } else {
        return left('Failed to fetch products: ${response.body}');
      }
    } catch (e) {
      return left('Error: $e');
    }
  }

  Future<Either<String, AddProductResponseModel>> addProduct({
    required String categoryId,
    required String name,
    required String price,
    required String picturePath,
  }) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/v1/product');
    final header = {
      'Authorization': 'Bearer ${authData?.data?.token}',
    };

    var request = http.MultipartRequest('POST', url)
      ..headers.addAll(header)
      ..fields['category_id'] = categoryId
      ..fields['name'] = name
      ..fields['price'] = price;

    // Menambahkan file gambar sebagai multipart
    final file = await http.MultipartFile.fromPath('picture', picturePath);
    request.files.add(file);

    try {
      final response = await request.send();
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final productData = AddProductResponseModel.fromJson(responseBody);
        return right(productData);
      } else {
        final responseBody = await response.stream.bytesToString();
        return left('Failed to add product: $responseBody');
      }
    } catch (e) {
      return left('Error: $e');
    }
  }

  Future<Either<String, String>> deleteProduct(String productId) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/v1/product/$productId');
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData?.data?.token}',
    };

    try {
      final response = await http.delete(url, headers: header);
      if (response.statusCode == 200) {
        return right('Product deleted successfully');
      } else {
        return left('Failed to delete product: ${response.body}');
      }
    } catch (e) {
      return left('Error: $e');
    }
  }
}
