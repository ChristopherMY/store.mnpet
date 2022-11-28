import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/banners.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/category.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/home_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';

class HomeBloc extends ChangeNotifier {
  final HomeRepositoryInterface homeRepositoryInterface;
  final HiveRepositoryInterface hiveRepositoryInterface;

  HomeBloc({
    required this.homeRepositoryInterface,
    required this.hiveRepositoryInterface,
  });

  ValueNotifier<List<MasterCategory>> categoriesList =
      ValueNotifier(<MasterCategory>[]);
  ValueNotifier<List<Banners>> bannersList = ValueNotifier(<Banners>[]);

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

    if (response.data == null) {
      pagingController.error = kNoLoadMoreItems;
      return;
    }

    final data =
        (response.data as List).map((x) => Product.fromMap(x)).toList();

    if (data.isNotEmpty) {
      _initialRange += 20;
      _finalRange += 20;

      final isLastPage = data.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(data);
      } else {
        final nextPageKey = pageKey + data.length;
        pagingController.appendPage(data, nextPageKey);
      }
    }

    components = LoadStatus.normal;
  }

  Future<void> handleInitComponents() async {
    final collection = await Future.wait([
      homeRepositoryInterface.getCategoriesHome(),
      homeRepositoryInterface.getBannersHome(),
    ]);

    collection.forEachIndexed(
      (index, response) {
        switch (index) {
          case 0:
            {
              if (response.data == null) return;

              categoriesList.value = (response.data as List)
                  .map((x) => MasterCategory.fromMap(x))
                  .toList();
            }
            break;
          case 1:
            {
              if (response.data == null) return;

              bannersList.value = (response.data as List)
                  .map((x) => Banners.fromMap(x))
                  .toList();
            }
            break;
          default:
        }
      },
    );
  }

  // void verifyExistsCartTemporal(BuildContext context) {
  //   hiveRepositoryInterface.read(
  //     containerName: containerName,
  //     key: key,
  //   );
  // }

  void refresh() {
    notifyListeners();
  }
}
