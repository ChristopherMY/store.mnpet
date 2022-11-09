import 'package:store_mundo_pet/clean_architecture/domain/model/category.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';

abstract class HomeRepositoryInterface {
  HomeRepositoryInterface();

  Future<List<Product>> getPaginationProduct({
    required int initialRange,
    required int finalRange,
  });

  Future<List<MasterCategory>> getCategoriesHome();


}