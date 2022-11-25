import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/cart_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';

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

  void initPage(BuildContext context) {
    final mainBloc = context.read<MainBloc>();

    mainBloc.handleShoppingCart(context);

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
    _initialRange = 1;
    _finalRange = 20;

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
    final responseApi =
        await productRepositoryInterface.getRelatedProductsPagination(
      categories: categories,
      finalRange: _finalRange,
      initialRange: _initialRange,
    );

    if (responseApi.data == null) {
      pagingController.error = kNoLoadMoreItems;
      return;
    }

    final products = responseApi.data as List;

    if (products.isNotEmpty) {
      List<Product> newItems = products.map((e) => Product.fromMap(e)).toList();

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
