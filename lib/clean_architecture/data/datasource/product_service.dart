import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/comment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/product_repository.dart';
import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductService implements ProductRepositoryInterface {
  final _url = Environment.API_DAO;

  // void
  @override
  Future<dynamic> setProductAnalytic({required String productId}) async {
    try {
      Uri url = Uri.parse("$_url/api/v1/analytics");
      Map<String, dynamic> bodyParams = {"id": productId};

      final encode = json.encode(bodyParams);
      final res = await http.post(url, headers: headers, body: encode);

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }

      return null;
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }

      return null;
    }
  }

  // Comment
  @override
  Future<dynamic> getProductFeedback({required String productId}) async {
    try {
      final res = await http.get(
        Uri.parse("$_url/api/v1/comments/$productId"),
        headers: headers,
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return Comment.fromMap(data);
      }
      return null;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  // Product
  @override
  Future<dynamic> getProductSlug({required String slug}) async {
    try {
      return await http.get(
        Uri.parse("$_url/api/v1/products/detail/$slug"),
        headers: headers,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  // String
  @override
  Future<dynamic> getShipmentPriceCost({
    required String slug,
    required String districtId,
    required int quantity,
  }) async {
    try {
      Map<String, dynamic> body = {
        "slug": slug,
        "district_id": districtId,
        "quantity": quantity,
      };

      final encodeBody = json.encode(body);

      return await http.post(
        Uri.parse("$_url/api/v1/shipment/calculate_product"),
        headers: headers,
        body: encodeBody,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return e.toString();
    }
  }

  // List<Product>
  @override
  Future<dynamic> getRelatedProductsPagination({
    required List<Brand> categories,
    required int initialRange,
    required int finalRange,
  }) async {
    try {
      Map<String, dynamic> binding = {
        "categories": categories.map((e) => e.id).toList().cast()
      };

      return await http.post(
        Uri.parse(
          "$_url/api/v1/products/related_by_category?skip=$initialRange&limit=$finalRange",
        ),
        headers: headers,
        body: json.encode(binding),
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }
      return e.toString();
    }
  }

  // dynamic
  @override
  Future<dynamic> launchPhoneDialer({required String contactNumber}) async {
    final Uri phoneUri = Uri(scheme: "tel", path: contactNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      }
    } on Exception catch (error) {
      throw ("Cannot dial");
    }
  }
}
