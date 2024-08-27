import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:pos_gmedia_test/data/datasources/auth_local_datasource.dart';

import '../../core/constant/variables.dart';
import '../models/auth_response_model.dart';

import 'package:http/http.dart' as http;

class AuthRemoteDatasource {
  Future<Either<String, AuthResponseModel>> login(
      String username, String password) async {
    final url = Uri.parse('${Variables.baseUrl}/api/v1/login');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return Right(AuthResponseModel.fromJson(response.body));
    } else {
      return const Left('Failed to login');
    }
  }

  Future<Either<String, String>> logout() async {
    try {
      print('Attempting to remove auth data');
      await AuthLocalDatasource().removeAuthData();
      print('Auth data removed successfully');
      return const Right('Logout success');
    } catch (e) {
      print('Failed to remove auth data: ${e.toString()}');
      return Left('Failed to logout: ${e.toString()}');
    }
  }
}
