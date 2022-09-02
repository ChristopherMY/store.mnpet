import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/cart_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';

class CartService implements CartRepositoryInterface {
  final _url = Environment.API_DAO;

  // http.response
  @override
  Future<dynamic> deleteProductCart({
    required String productId,
    required String variationId,
    required Map<String, String> headers,
  }) async {
    Map<String, dynamic> binding = {
      "product_id": productId,
      "variation_id": variationId,
    };

    final body = json.encode(binding);
    try {
      final res = await http.delete(
        Uri.parse("$_url/api/v1/shopping_cart/item"),
        headers: headers,
        body: body,
      );

      return res;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.toString();
    }
  }

  // Cart
  @override
  Future<dynamic> getShoppingCart({
    required String districtId,
    required Map<String, String> headers,
  }) async {
    try {
      return await http.get(
        Uri.parse("$_url/api/v1/shopping_cart?&district_id=$districtId"),
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
  Future<dynamic> saveShoppingCart({
    required Map<String, dynamic> cart,
    required Map<String, String> headers,
  }) async {
    try {
      return await http.put(
        Uri.parse("$_url/api/v1/shopping_cart"),
        headers: headers,
        body: json.encode(cart),
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  @override
  Future moveShoppingCart({
    required String cartId,
    required Map<String, String> headers,
  }) async {
    Map<String, dynamic> binding = {
      "temp_id": cartId,
    };

    final body = json.encode(binding);

    try {
      return await http.put(
        Uri.parse("$_url/api/v1/shopping_cart/move"),
        headers: headers,
        body: body,
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
  Future<dynamic> updateProductCart({
    required String productId,
    required String variationId,
    required int quantity,
    required Map<String, String> headers,
  }) async {
    Map<String, dynamic> binding = {
      "product_id": productId,
      "variation_id": variationId,
      "quantity": quantity,
    };

    final body = json.encode(binding);

    try {
      return await http.put(
        Uri.parse("$_url/api/v1/shopping_cart/set_quantity"),
        headers: headers,
        body: body,
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
  Future<dynamic> deleteProductCartTemp({
    required String cartId,
    required String productId,
    required String variationId,
  }) async {
    Map<String, dynamic> binding = {
      "cart_id": cartId,
      "product_id": productId,
      "variation_id": variationId,
    };

    final body = json.encode(binding);
    try {
      final res = await http.delete(
        Uri.parse("$_url/api/v1/temp_cart/item"),
        headers: headers,
        body: body,
      );

      return res;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return e.toString();
    }
  }

  // Cart
  @override
  Future<dynamic> getShoppingCartTemp({
    required String districtId,
    required Map<String, String> bodyParams,
  }) async {
    try {
      return await http.post(
          Uri.parse("$_url/api/v1/temp_cart?&district_id=$districtId"),
          headers: headers,
          body: jsonEncode(bodyParams));
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return e.toString();
    }
  }

  @override
  Future<dynamic> onSaveShoppingCartTemp({
    required Map<String, dynamic> cart,
  }) async {
    try {
      return await http.put(
        Uri.parse("$_url/api/v1/temp_cart"),
        headers: headers,
        body: json.encode(cart),
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return null;
    }
  }

  // http.response
  @override
  Future<dynamic> updateProductCartTemp({
    required String cartId,
    required String productId,
    required String variationId,
    required int quantity,
  }) async {
    Map<String, dynamic> binding = {
      "cart_id": cartId,
      "product_id": productId,
      "variation_id": variationId,
      "quantity": quantity,
    };

    final body = json.encode(binding);

    try {
      return await http.post(
        Uri.parse("$_url/api/v1/temp_cart/quantity"),
        headers: headers,
          body: body,
        );
      } on Exception catch (e) {
        if (kDebugMode) {
        print(e);
      }

      return e.toString();
    }
  }
}
