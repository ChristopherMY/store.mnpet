import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/domain/model/cart.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information_local.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/cart_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/loadany.dart';

import '../../../domain/repository/product_repository.dart';

class CartBloc extends ChangeNotifier {
  HiveRepositoryInterface hiveRepositoryInterface;
  CartRepositoryInterface cartRepositoryInterface;
  ProductRepositoryInterface productRepositoryInterface;

  CartBloc({
    required this.hiveRepositoryInterface,
    required this.cartRepositoryInterface,
    required this.productRepositoryInterface,
  });

  int initialRange = 1;
  int finalRange = 20;

  bool isCartLoaded = true;
  bool isSessionEnable = true;
  LoadStatus loginState = LoadStatus.normal;
  ValueNotifier<LoadStatus> cart = ValueNotifier(LoadStatus.loading);
  ValueNotifier<int> cartLength = ValueNotifier(0);
  List<Product> productsList = <Product>[];
  ValueNotifier<LoadStatus> loadStatus = ValueNotifier(LoadStatus.loading);

  Future<UserInformationLocal> loadShipmentResidence() async {
    return UserInformationLocal.fromMap(
      await hiveRepositoryInterface.read(
            containerName: "shipment",
            key: "residence",
          ) ??
          {
            "department": "Lima",
            "province": "Lima",
            "district": "Miraflores",
            "districtId": "61856a14587c82ef50c1b44b",
            "ubigeo": "Lima - Lima - Miraflores",
          },
    );
  }

  Future<dynamic> fetchGetShoppingCart({
    required String districtId,
    required Map<String, String> headers,
  }) async {
    final response = await cartRepositoryInterface.getShoppingCart(
      districtId: districtId,
      headers: headers,
    );

    if (response is http.Response) {
      if (response.statusCode == 200) {
        final decodeResponse = jsonDecode(response.body);

        return Cart.fromMap(decodeResponse);
      }
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }
    }

    return false;
  }

  void initRelatedProductsPagination({required List<Brand> categories}) async {
    loadStatus.value = LoadStatus.loading;

    final response =
        await productRepositoryInterface.getRelatedProductsPagination(
      categories: categories,
      finalRange: finalRange,
      initialRange: initialRange,
    );

    if (response is http.Response) {
      if (response.statusCode == 200) {
        final products = jsonDecode(response.body) as List;
        print("Contador: ${products.length}");
        if (products.isNotEmpty) {

          productsList.addAll(
            products.map((e) => Product.fromMap(e)).toList().cast(),
          );

          initialRange += 20;
          finalRange += 20;

          loadStatus.value = LoadStatus.normal;
          return;
        }

        loadStatus.value = LoadStatus.completed;
        return;
      }

      loadStatus.value = LoadStatus.error;
      return;
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }
    }

    loadStatus.value = LoadStatus.error;
  }
}
