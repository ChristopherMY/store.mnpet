import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/domain/model/category.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/home_repository.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/loadany.dart';

class HomeBloc extends ChangeNotifier {
  final HomeRepositoryInterface homeRepositoryInterface;

  HomeBloc({required this.homeRepositoryInterface});


  List<MasterCategory> categoriesList = <MasterCategory>[];

  int initialRange = 1;
  int finalRange = 20;
  bool isFetching = false;
  bool reloadPagination = false;

  ValueNotifier<List<Product>> products = ValueNotifier([]);
  ValueNotifier<LoadStatus> loadStatus = ValueNotifier(LoadStatus.loading);

  Future<List<Product>> paginationProducts() async {
    loadStatus.value = LoadStatus.loading;
    print("Esta entrando");
    if (reloadPagination) {
      initialRange = 1;
      finalRange = 20;
    }

    final response = await homeRepositoryInterface.getPaginationProduct(
      initialRange: initialRange,
      finalRange: finalRange,
    );

    if (response is http.Response) {
      if (response.statusCode == 200) {
        final values = jsonDecode(response.body) as List;
        if (values.isNotEmpty) {
          if (reloadPagination) {
            products.value.clear();
            reloadPagination = false;
          }

          initialRange += 20;
          finalRange += 20;

          loadStatus.value = LoadStatus.normal;
          print("Esta entrando");
          return values
              .map((product) => Product.fromMap(product))
              .toList()
              .cast();
        } else {
          loadStatus.value = LoadStatus.completed;
          return [];
        }
      } else {
        loadStatus.value = LoadStatus.error;
        return [];
      }
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }
      loadStatus.value = LoadStatus.error;
      return [];
    } else {
      loadStatus.value = LoadStatus.error;
      return [];
    }
  }

  void initPaginationProducts() async {
    loadStatus.value = LoadStatus.loading;

    final response = await homeRepositoryInterface.getPaginationProduct(
      initialRange: initialRange,
      finalRange: finalRange,
    );

    if (response is http.Response) {
      if (response.statusCode == 200) {
        final values = jsonDecode(response.body) as List;
        if (values.isNotEmpty) {
          initialRange += 20;
          finalRange += 20;

          products.value.clear();
          loadStatus.value = LoadStatus.normal;
          products.value =
              values.map((product) => Product.fromMap(product)).toList().cast();
        } else {
          loadStatus.value = LoadStatus.completed;
          products.value = [];
        }
      } else {
        loadStatus.value = LoadStatus.error;
        products.value = [];
      }
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }
      loadStatus.value = LoadStatus.error;
      products.value = [];
    }
  }

  void loadCategories() async {
    final response = await homeRepositoryInterface.getCategoriesHome();

    if (response is http.Response) {
      if (response.statusCode == 200) {
        final categories = jsonDecode(response.body) as List;
        if (categories.isNotEmpty) {
          categoriesList = categories
              .map((category) => MasterCategory.fromMap(category))
              .toList()
              .cast();
        }
      }
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }
    }
  }

  void refreshAccount() {}
}
