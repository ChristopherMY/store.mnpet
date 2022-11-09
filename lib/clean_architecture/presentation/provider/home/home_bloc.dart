import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/category.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/home_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/usecase/page.dart';

class HomeBloc extends ChangeNotifier {
  final HomeRepositoryInterface homeRepositoryInterface;

  HomeBloc({required this.homeRepositoryInterface});

  ValueNotifier<List<MasterCategory>> categoriesList =
      ValueNotifier(<MasterCategory>[]);

  static int _initialRange = 0;
  static int _finalRange = 20;
  static const _pageSize = 19;
  bool reloadPagination = false;

  List<Product> products = <Product>[];
  LoadStatus components = LoadStatus.loading;

  final PagingController<int, Product> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  Future<void> fetchPage(int pageKey) async {
    if (reloadPagination) {
      _initialRange = 0;
      _finalRange = 20;
      reloadPagination = !reloadPagination;
    }

    final response = await homeRepositoryInterface.getPaginationProduct(
      initialRange: _initialRange,
      finalRange: _finalRange,
    );

    if (response.isEmpty) {
      pagingController.error =
          "Nos encontramos en mantenimiento, intentelo más tarde";
      return;
    }

    if (response.isNotEmpty) {
      _initialRange += 20;
      _finalRange += 20;

      // List<Product> newItems =
      //     values.map((product) => Product.fromMap(product)).toList().cast();

      final isLastPage = response.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(response);
      } else {
        final nextPageKey = pageKey + response.length;
        pagingController.appendPage(response, nextPageKey);
      }
    }

    components = LoadStatus.normal;
  }

  Future<void> handleInitComponents() async {
    final collection =
        await Future.wait([homeRepositoryInterface.getCategoriesHome()]);

    collection.forEachIndexed(
      (index, response) {
        switch (index) {
          case 0:
            {
              if (response.isNotEmpty) {
                categoriesList.value = response;
              }
            }
            break;
          default:
        }
      },
    );
  }

  void refresh() {
    notifyListeners();
  }
}
