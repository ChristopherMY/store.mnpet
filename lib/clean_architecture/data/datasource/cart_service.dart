
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/cart_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/http.dart';

import '../../helper/http_response.dart';

class CartService implements CartRepositoryInterface {
  final String _url = Environment.API_DAO;
  final Http _dio = Http(logsEnabled: false);

  // http.response
  @override
  Future<HttpResponse> deleteProductCart({
    required String productId,
    required String variationId,
    required Map<String, String> headers,
  }) async {
    Map<String, dynamic> binding = {
      "product_id": productId,
      "variation_id": variationId,
    };

    return await _dio.request(
      "$_url/api/v1/cart/item",
      method: "DELETE",
      headers: headers,
      data: binding,
    );

  }

  // Cart
  @override
  Future<HttpResponse> getShoppingCart({
    required String districtId,
    required Map<String, String> headers,
  }) async {
    return await _dio.request(
      "$_url/api/v1/cart?&district_id=$districtId",
      method: "GET",
      headers: headers,
    );
  }

  @override
  Future<HttpResponse> saveShoppingCart({
    required Map<String, dynamic> cart,
    required Map<String, String> headers,
  }) async {
    return await _dio.request(
      "$_url/api/v1/cart",
      method: "PUT",
      headers: headers,
      data: cart,
    );
  }

  @override
  Future<HttpResponse> moveShoppingCart({
    required String cartId,
    required Map<String, String> headers,
  }) async {
    Map<String, dynamic> binding = {
      "temp_id": cartId,
    };

    return await _dio.request(
      "$_url/api/v1/cart/move",
      method: "PUT",
      headers: headers,
      data: binding,
    );
  }

  // http.response
  @override
  Future<HttpResponse> updateProductCart({
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

    return await _dio.request(
      "$_url/api/v1/cart/quantity",
      method: 'PUT',
      headers: headers,
      data: binding,
    );
  }

  // http.response
  @override
  Future<HttpResponse> deleteProductCartTemp({
    required String cartId,
    required String productId,
    required String variationId,
  }) async {
    Map<String, dynamic> binding = {
      "cart_id": cartId,
      "product_id": productId,
      "variation_id": variationId,
    };

    return await _dio.request(
      "$_url/api/v1/cart/temporal/item",
      method: "DELETE",
      headers: headers,
      data: binding,
    );
  }

  // Cart
  @override
  Future<HttpResponse> getShoppingCartTemp({
    required String districtId,
    required Map<String, String> headers,
  }) async {
    return await _dio.request(
      "$_url/api/v1/cart/temporal?district_id=$districtId",
      method: "GET",
      headers: headers,
    );
  }

  @override
  Future<HttpResponse> onSaveShoppingCartTemp({
    required Map<String, dynamic> cart,
  }) async {
    return await _dio.request(
      "$_url/api/v1/cart/temporal",
      method: "PUT",
      headers: headers,
      data: cart,
    );
  }

  // http.response
  @override
  Future<HttpResponse> updateProductCartTemp({
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

    return await _dio.request(
      "$_url/api/v1/cart/temporal/quantity",
      method: "POST",
      headers: headers,
      data: binding,
    );
  }
}
