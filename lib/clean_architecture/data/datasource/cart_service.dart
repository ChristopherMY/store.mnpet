import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/cart.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/cart_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:http/http.dart' as http;

class CartService implements CartRepositoryInterface {
  final _url = Environment.API_DAO;

  // http.response
  @override
  Future<dynamic> deleteProductCart({
    required String cartId,
    required String variationId,
    required String districtId,
  }) async {
    Map<String, dynamic> binding = {
      "product_id": cartId,
      "variation_id": variationId,
      "district_id": districtId,
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
  Future<dynamic> getShoppingCart({required String districtId}) async {
    try {
      final res = await http.get(
        Uri.parse("$_url/api/v1/shopping_cart?&district_id=$districtId"),
        headers: headers,
      );
      if (res.statusCode == 200) {
        return Cart.fromMap(json.decode(res.body));
      }
      return null;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return e.toString();
    }
  }

  @override
  Future<dynamic> onSaveShoppingCart({
    required Map<String, dynamic> cart,
    required String districtId,
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

  // http.response
  @override
  Future<dynamic> updateProductCart({
    required String districtId,
    required String productId,
    required String variationId,
    required int quantity,
  }) async {
    Map<String, dynamic> binding = {
      "district_id": districtId,
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
}
