import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/http.dart';

import '../../helper/http_response.dart';

class UserService implements UserRepositoryInterface {
  final String _url = Environment.API_DAO;
  final Http _dio = Http(logsEnabled: false);

  // http.response
  @override
  Future<HttpResponse> changeMainAddress({
    required addressId,
    required Map<String, String> headers,
  }) async {
    return await _dio.request(
      "$_url/api/v1/users/ecommerce"
      "/addresses/main?address_id=$addressId",
      method: "PUT",
      headers: headers,
    );
  }

  // http.response
  @override
  Future<HttpResponse> createAddress({
    required Address address,
    required Map<String, String> headers,
  }) async {
    return await _dio.request(
      "$_url/api/v1/users/ecommerce/addresses",
      method: "POST",
      headers: headers,
      data: address.toMap(),
    );
  }

  // http.response
  @override
  Future<HttpResponse> deleteUserAddress({
    required String addressId,
    required Map<String, String> headers,
  }) async {
    return await _dio.request(
      "$_url/api/v1/users/ecommerce/addresses?address_id=$addressId",
      method: "DELETE",
      headers: headers,
    );
  }

  // Address
  @override
  Future<HttpResponse> getAddressMain() async {
    return await _dio.request(
      "$_url/api/v1/users/ecommerce/addresses/main",
      method: "GET",
      headers: headers,
    );
  }

  // User
  @override
  Future<HttpResponse> getInformationUser({
    required Map<String, String> headers,
  }) async {
    return await _dio.request(
      "$_url/api/v1/users/ecommerce",
      method: "GET",
      headers: headers,
    );
  }

  // Order
  @override
  Future<HttpResponse> getOrderDetailById({required int paymentId}) async {
    return await _dio.request(
      "$_url/api/v1/order/ecommerce/$paymentId",
      method: "GET",
      headers: headers,
    );
  }

  // List<Order>
  @override
  Future<HttpResponse> getOrdersById({
    required Map<String, String> headers,
  }) async {
    return await _dio.request(
      "$_url/api/v1/order/ecommerce/user",
      method: "GET",
      headers: headers,
    );
  }

  // http.response
  // @override
  // Future<HttpResponse> pushUserNotificationToken() async {
  // String token = await FirebaseMessaging.instance.getToken();
  //
  // try {
  //   final url = Uri.parse('$_url/api/v1/');
  //
  //   Map<String, dynamic> binding = {
  //     "userId": userId,
  //     "token": token,
  //   };
  //
  //   String bodyParams = json.encode(binding);
  //
  //   return await https.post(url, headers: headers, body: bodyParams);
  // } catch (e) {
  //   print("Error $e");
  //   return null;
  // }
  // }

  // http.response
  @override
  Future<HttpResponse> updateUserAddress({
    required Address address,
    required Map<String, String> headers,
  }) async {
    return await _dio.request(
      "$_url/api/v1/users/ecommerce/addresses?address_id=${address.id}",
      method: "PUT",
      headers: headers,
      data: address.toMap(),
    );
  }

  @override
  Future<HttpResponse> changeMainPhone({
    required String phoneId,
    required Map<String, String> headers,
  }) async {
    return await _dio.request(
      "$_url/api/v1/users/ecommerce/phones/main?phone_id=$phoneId",
      method: "PUT",
      headers: headers,
    );
  }

  @override
  Future<HttpResponse> createPhone({
    required Phone phone,
    required Map<String, String> headers,
  }) async {
    return await _dio.request(
      "$_url/api/v1/users/ecommerce/phones",
      method: "POST",
      headers: headers,
      data: phone.toMap(),
    );
  }

  @override
  Future<HttpResponse> deleteUserPhone({
    required String phoneId,
    required Map<String, String> headers,
  }) async {
    return await _dio.request(
      "$_url/api/v1/users/ecommerce/phones?phone_id=$phoneId",
      method: "DELETE",
      headers: headers,
    );
  }

  @override
  Future<HttpResponse> updateUserPhone({
    required Phone phone,
    required Map<String, String> headers,
  }) async {
    return await _dio.request(
      "$_url/api/v1/users/ecommerce/phones?phone_id=${phone.id}",
      method: "PUT",
      headers: headers,
      data: phone.toMap(),
    );
  }

  @override
  Future<HttpResponse> updateUserInformation({
    required Map<String, dynamic> binding,
    required Map<String, String> headers,
  }) async {
    return await _dio.request(
      "$_url/api/v1/users/ecommerce",
      method: "PUT",
      headers: headers,
      data: binding,
    );
  }

  @override
  Future<HttpResponse> changeUserMail({
    required Map<String, String> headers,
    required Map<String, dynamic> bindings,
  }) async {
    return await _dio.request(
      "$_url/api/v1/users/ecommerce/email/change",
      method: "PUT",
      headers: headers,
      data: bindings,
    );
  }

  @override
  Future<HttpResponse> changeUserPassword({
    required Map<String, String> headers,
    required Map<String, dynamic> bindings,
  }) async {
    return await _dio.request(
      "$_url/api/v1/users/ecommerce/password/change/auth",
      method: "PUT",
      headers: headers,
      data: bindings,
    );
  }
}
