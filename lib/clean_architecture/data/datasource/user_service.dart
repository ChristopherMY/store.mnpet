import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/order.dart'
    as order;
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';

class UserService implements UserRepositoryInterface {
  final _url = Environment.API_DAO;

  // http.response
  @override
  Future<dynamic> changeMainAddress({
    required addressId,
    required Map<String, String> headers,
  }) async {
    try {
      return await http.put(
        Uri.parse(
          "$_url/api/v1/ecommerce_users/addresses/main?address_id=$addressId",
        ),
        headers: headers,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return e.toString();
    }
  }

  // http.response
  @override
  Future<dynamic> createAddress({
    required Address address,
    required Map<String, String> headers,
  }) async {
    try {
      String bodyParams = addressToMap(address);

      return await http.post(
        Uri.parse("$_url/api/v1/ecommerce_users/addresses"),
        headers: headers,
        body: bodyParams,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  // http.response
  @override
  Future<dynamic> deleteUserAddress({
    required String addressId,
    required Map<String, String> headers,
  }) async {
    try {
      return await http.delete(
        Uri.parse(
          "$_url/api/v1/ecommerce_users/addresses?address_id=$addressId",
        ),
        headers: headers,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  // Address
  @override
  Future<dynamic> getAddressMain() async {
    final res = await http.get(
        Uri.parse("$_url/api/v1/ecommerce_users/addresses/main"),
        headers: headers);
    try {
      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        return Address.fromMap(data);
      }
      return null;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return e.toString();
    }
  }

  // User
  @override
  Future<dynamic> getInformationUser(
      {required Map<String, String> headers}) async {
    try {
      return await http.get(
        Uri.parse("$_url/api/v1/ecommerce_users/user"),
        headers: headers,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return e.toString();
    }
  }

  // Order
  @override
  Future<dynamic> getOrderDetailById({required int paymentId}) async {
    try {
      final res = await http.get(
        Uri.parse("$_url/api/v1/order/ecommerce/$paymentId"),
        headers: headers,
      );

      if (res.statusCode == 200)
        return order.Order.fromMap(jsonDecode(res.body));

      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  // List<Order>
  @override
  Future<dynamic> getOrdersById() async {
    try {
      final res = await http.get(
        Uri.parse("$_url/api/v1/order/ecommerce/user"),
        headers: headers,
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data
            .map((element) => order.Order.fromMap(element))
            .toList()
            .cast();
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return e.toString();
    }
  }

  // http.response
  @override
  Future<dynamic> pushUserNotificationToken() async {
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
  }

  // http.response
  @override
  Future<dynamic> updateUserAddress({
    required Address address,
    required Map<String, String> headers,
  }) async {
    try {
      String bodyParams = addressToMap(address);

      final response = await http.put(
        Uri.parse(
          "$_url/api/v1/ecommerce_users/addresses?address_id=${address.id}",
        ),
        headers: headers,
        body: bodyParams,
      );
      return response;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return e.toString();
    }
  }

  @override
  Future<dynamic> changeMainPhone({
    required String phoneId,
    required Map<String, String> headers,
  }) async {
    try {
      return await http.put(
        Uri.parse(
          "$_url/api/v1/ecommerce_users/phones/main?phone_id=$phoneId",
        ),
        headers: headers,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return e.toString();
    }
  }

  @override
  Future<dynamic> createPhone({
    required Phone phone,
    required Map<String, String> headers,
  }) async {
    try {
      String bodyParams = phoneToMap(phone);

      return await http.post(
        Uri.parse("$_url/api/v1/ecommerce_users/phones"),
        headers: headers,
        body: bodyParams,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return e.toString();
    }
  }

  @override
  Future<dynamic> deleteUserPhone(
      {required String phoneId, required Map<String, String> headers}) async {
    try {
      return await http.delete(
        Uri.parse(
          "$_url/api/v1/ecommerce_users/phones?phone_id=$phoneId",
        ),
        headers: headers,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  @override
  Future updateUserPhone({
    required Phone phone,
    required Map<String, String> headers,
  }) async {
    try {
      String bodyParams = phoneToMap(phone);

      return await http.put(
        Uri.parse(
          "$_url/api/v1/ecommerce_users/phones?phone_id=${phone.id}",
        ),
        headers: headers,
        body: bodyParams,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return e.toString();
    }
  }

}
