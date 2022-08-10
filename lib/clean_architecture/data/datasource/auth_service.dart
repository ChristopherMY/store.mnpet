import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/vimeo_video_config.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';

class AuthService implements AuthRepositoryInterface {
  final _url = Environment.API_DAO;

  // https.Response
  @override
  Future<dynamic> createUser({required User user}) async {
    try {
      return await http.post(
        Uri.parse("$_url/api/v1/ecommerce_users/register_native"),
        headers: headers,
        body: json.encode(user),
      );
    } on Exception catch (e) {
      return e.toString();
    }
  }

  // https.Response
  @override
  Future<dynamic> loginVerification({
    required String email,
    required String password,
  }) async {
    try {
      return await http.post(
        Uri.parse("$_url/api/v1/ecommerce_users/login"),
        headers: headers,
        body: json.encode({
          "email": email,
          "password": password,
        }),
      );
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
