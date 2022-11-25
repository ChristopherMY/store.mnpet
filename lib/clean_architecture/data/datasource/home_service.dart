import 'package:logger/logger.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/category.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/home_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/http.dart';

class HomeService implements HomeRepositoryInterface {
  final String _url = Environment.API_DAO;
  final Http _dio = Http(logsEnabled: true);
  final Logger _logger = Logger();

  @override
  Future<List<MasterCategory>> getCategoriesHome() async {
    try {
      final response = await _dio.request(
        "$_url/api/v1/categories",
        method: "GET",
      );

      if (response.data != null) {
        return (response.data as List)
            .map((x) => MasterCategory.fromMap(x))
            .toList();
      }

      return <MasterCategory>[];
    } on Exception catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  @override
  Future<List<Product>> getPaginationProduct({
    required int initialRange,
    required int finalRange,
  }) async {
    try {
      final response = await _dio.request(
        "$_url/api/v1/products/loadmore-scroll?skip=$initialRange&limit=$finalRange",
        method: "GET",
      );

      if (response != null) {
        return (response.data as List).map((x) => Product.fromMap(x)).toList();
      }

      return <Product>[];
    } on Exception catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }


}
