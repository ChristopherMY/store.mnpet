import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';

class AuthService implements AuthRepositoryInterface {
  final _url = Environment.API_DAO;

  // https.Response
  @override
  Future<dynamic> createUser({required Map<String, dynamic> user}) async {
    try {
      return await http.post(
        Uri.parse("$_url/api/v1/users/ecommerce/register_native"),
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
        Uri.parse("$_url/api/v1/users/ecommerce/login"),
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

  @override
  Future<dynamic> requestPasswordChange({
    required String value,
    required String valueType,
  }) async {
    try {
      Map<String, dynamic> bodyParams = {"value": value, "type": valueType};
      final encode = json.encode(bodyParams);

      return await http.post(
        Uri.parse("$_url/api/v1/users/ecommerce/change_password"),
        headers: headers,
        body: encode,
      );
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<dynamic> validateOtp({
    required String otp,
    required String userId,
  }) async {
    try {
      Map<String, dynamic> bodyParams = {
        "user_id": userId,
        "otp_to_validate": otp
      };

      final encode = json.encode(bodyParams);

      return await http.post(
        Uri.parse("$_url/api/v1/users/ecommerce/validate_otp"),
        headers: headers,
        body: encode,
      );
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future changePassword({
    required String userId,
    required String password,
    required String passwordConfirmation,
  }) async{
    try {
      Uri url = Uri.parse("$_url/api/v1/users/ecommerce/change_password");
      Map<String, dynamic> bodyParams = {
        "user_id": userId,
        "password": password,
        "password_confirmation": passwordConfirmation
      };

      final encode = json.encode(bodyParams);
      return await http.put(url, headers: headers, body: encode);
    } on Exception catch (e){
      return e.toString();
    }
  }
}
