import 'package:dartz/dartz.dart';

import '../../core/constant/variables.dart';
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
}
