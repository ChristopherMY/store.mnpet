import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/category.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/home_repository.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/loadany.dart';

class HomeBloc extends ChangeNotifier {
  final HomeRepositoryInterface homeRepositoryInterface;

  HomeBloc({required this.homeRepositoryInterface});

  ValueNotifier<List<MasterCategory>> categoriesList =
      ValueNotifier(<MasterCategory>[]);

  static int _initialRange = 1;
  static int _finalRange = 20;
  static bool isFetching = false;
  static const _pageSize = 19;
  bool reloadPagination = false;

  List<Product> products = <Product>[];
  LoadStatus components = LoadStatus.loading;

  final PagingController<int, Product> pagingController =
      PagingController(firstPageKey: 0);

  Future<void> fetchPage(int pageKey) async {
    if (reloadPagination) {
      _initialRange = 1;
      _finalRange = 20;
      reloadPagination = !reloadPagination;
    }

    final response = await homeRepositoryInterface.getPaginationProduct(
      initialRange: _initialRange,
      finalRange: _finalRange,
    );

    if (response is String) {
      if (kDebugMode) {
        print(response);
      }
      pagingController.error = response;
    }

    if (response is http.Response) {
      if (response.statusCode == 200) {
        final values = jsonDecode(response.body) as List;
        if (values.isNotEmpty) {
          _initialRange += 20;
          _finalRange += 20;

          List<Product> newItems =
              values.map((product) => Product.fromMap(product)).toList().cast();

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

    components = LoadStatus.normal;
  }

  void handleInitComponents() async {
    final collection =
        await Future.wait([homeRepositoryInterface.getCategoriesHome()]);

    collection.forEachIndexed(
      (index, response) {
        switch (index) {
          case 0:
            {
              if (response is String) {
                if (kDebugMode) {
                  print(response);
                }
              }

              if (response is http.Response) {
                if (response.statusCode == 200) {
                  final categories = jsonDecode(response.body) as List;
                  if (categories.isNotEmpty) {
                    categoriesList.value = categories
                        .map((category) => MasterCategory.fromMap(category))
                        .toList()
                        .cast();
                  }
                }
              }
            }
            break;
          default:
        }
      },
    );
  }

  void refresh() {}
}
