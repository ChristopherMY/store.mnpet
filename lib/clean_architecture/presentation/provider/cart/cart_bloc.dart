import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/cart_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/hive_repository.dart';

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

  static int _initialRange = 1;
  static int _finalRange = 20;
  static const _pageSize = 19;

  final PagingController<int, Product> pagingController =
      PagingController(firstPageKey: 0);

  void initPage() {
    pagingController.addPageRequestListener(
      (pageKey) {
        fetchPage(
          pageKey: pageKey,
          categories: [
            Brand(
              id: "635ade4510d23296ee080ee1",
              slug: "piso",
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    pagingController.removePageRequestListener(
      (pageKey) {
        fetchPage(
          pageKey: pageKey,
          categories: [
            Brand(
              id: "635ade4510d23296ee080ee1",
              slug: "piso",
            )
          ],
        );
      },
    );

    pagingController.dispose();

    super.dispose();
  }

  Future<void> fetchPage({
    required List<Brand> categories,
    required int pageKey,
  }) async {
    final responseApi = await productRepositoryInterface.getRelatedProductsPagination(
      categories: categories,
      finalRange: _finalRange,
      initialRange: _initialRange,
    );

    if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      pagingController.error = response;
    }

    if (response is http.Response) {
      if (response.statusCode == 200) {
        final products = jsonDecode(response.body) as List;
        if (products.isNotEmpty) {
          List<Product> newItems =
              products.map((e) => Product.fromMap(e)).toList().cast();

          _initialRange += 20;
          _finalRange += 20;

          final isLastPage = newItems.length < _pageSize;
          if (isLastPage) {
            pagingController.appendLastPage(newItems);
          } else {
            final nextPageKey = pageKey + newItems.length;
            pagingController.appendPage(newItems, nextPageKey);
          }
        }
      }
    }
  }
}
