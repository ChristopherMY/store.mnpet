import 'package:logger/logger.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/http.dart';

import '../../helper/http_response.dart';

class AuthService implements AuthRepositoryInterface {
  final String _url = Environment.API_DAO;
  final Http _dio = Http(logsEnabled: true);

  // https.Response
  @override
  Future<HttpResponse> createUser({
    required Map<String, dynamic> data,
  }) async {
    return await _dio.request(
      "$_url/api/v1/users/ecommerce/register-native",
      method: "POST",
      data: data,
    );
  }

  // HttpResponse
  @override
  Future<HttpResponse> loginVerification({
    required String email,
    required String password,
  }) async {
    return await _dio.request(
      "$_url/api/v1/users/ecommerce/login",
      method: "POST",
      headers: headers,
      data: {
        "email": email,
        "password": password,
      },
    );
  }

  @override
  Future<HttpResponse> requestPasswordChange({
    required String value,
    required String valueType,
  }) async {
    Map<String, dynamic> bodyParams = {"value": value, "type": valueType};

    return await _dio.request(
      "$_url/api/v1/users/ecommerce/password/change",
      method: "POST",
      headers: headers,
      data: bodyParams,
    );
  }

  @override
  Future<HttpResponse> validateOtp({
    required String otp,
    required String userId,
  }) async {
    Map<String, dynamic> bodyParams = {
      "user_id": userId,
      "otp_to_validate": otp
    };

    return await _dio.request(
      "$_url/api/v1/users/ecommerce/password/otp",
      headers: headers,
      method: "POST",
      data: bodyParams,
    );
  }

  @override
  Future<HttpResponse> changePassword({
    required String userId,
    required String password,
    required String passwordConfirmation,
  }) async {
    Map<String, dynamic> bodyParams = {
      "user_id": userId,
      "password": password,
      "password_confirmation": passwordConfirmation
    };

    return await _dio.request(
      "$_url/api/v1/users/ecommerce/password/change",
      method: "PUT",
      headers: headers,
      data: bodyParams,
    );
  }
}
