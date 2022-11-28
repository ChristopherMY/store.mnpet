import 'package:logger/logger.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/home_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/http.dart';

import '../../helper/http_response.dart';

class HomeService implements HomeRepositoryInterface {
  final String _url = Environment.API_DAO;
  final Http _dio = Http(logsEnabled: false);
  final Logger _logger = Logger();

  @override
  Future<HttpResponse> getCategoriesHome() async {
    return await _dio.request(
      "$_url/api/v1/categories",
      method: "GET",
    );
  }

  @override
  Future<HttpResponse> getBannersHome() async {
    return await _dio.request(
      "$_url/api/v1/banners/app/",
      method: "GET",
    );
  }

  @override
  Future<HttpResponse> getPaginationProduct({
    required int initialRange,
    required int finalRange,
  }) async {
    return await _dio.request(
      "$_url/api/v1/products/loadmore-scroll?skip=$initialRange&limit=$finalRange",
      method: "GET",
    );
  }
}
