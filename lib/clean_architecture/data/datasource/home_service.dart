import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/category.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/home_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';

class HomeService implements HomeRepositoryInterface {
  final _url = Environment.API_DAO;
  final Dio _dio = Dio();
  final Logger _logger = Logger();

  @override
  Future<List<MasterCategory>> getCategoriesHome() async {
    try {
      final response = await _dio.get(
        "$_url/api/v1/categories",
        options: Options(
          headers: headers,
        ),
      );

      return (response.data as List)
          .map((x) => MasterCategory.fromMap(x))
          .toList();
    } on Exception catch (error, stacktrace) {
      _logger.e(error);
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  @override
  Future<List<Product>> getPaginationProduct({
    required int initialRange,
    required int finalRange,
  }) async {
    try {
      final response = await _dio.get(
        "$_url/api/v1/products/loadmore-scroll?skip=$initialRange&limit=$finalRange",
        options: Options(
          headers: headers,
        ),
      );

      return (response.data as List).map((x) => Product.fromMap(x)).toList();
    } on Exception catch (error, stacktrace) {
      _logger.e(error);
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }
}
