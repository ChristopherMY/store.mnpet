import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/local_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/http.dart';

import '../../helper/http_response.dart';

class LocalService implements LocalRepositoryInterface {
  final String _url = Environment.API_DAO;
  final Http _dio = Http(logsEnabled: false);

  @override
  Future<void> clearAllData() {
    // TODO: implement clearAllData
    throw UnimplementedError();
  }

  @override
  Future<String?> getToken() {
    // TODO: implement getToken
    throw UnimplementedError();
  }

  @override
  Future<String?> saveToken(String token) {
    // TODO: implement saveToken
    throw UnimplementedError();
  }

  // List<District>
  @override
  Future<HttpResponse> getDistricts({required String provinceId}) async {
    return await _dio.request(
      "$_url/api/v1/districts/details/$provinceId",
      method: "GET",
      headers: headers,
    );
  }

  // List<Province>
  @override
  Future<HttpResponse> getProvinces({required String departmentId}) async {
    return await _dio.request(
      "$_url/api/v1/provinces/details/$departmentId",
      method: "GET",
      headers: headers,
    );
  }

  // List<Region>
  @override
  Future<HttpResponse> getRegions() async {
    return await _dio.request(
      "$_url/api/v1/regions/departments",
      method: "GET",
      headers: headers,
    );
  }

  @override
  Future<HttpResponse> getKeywords() async {
    return await _dio.request(
      "$_url/api/v1/search/keywords",
      method: "GET",
      headers: headers,
    );
  }

  @override
  Future<HttpResponse> verifyExistsCartTemporal({
    required String cartId,
  }) async {
    return await _dio.request(
      "$_url/api/v1/cart/temporal/check",
      method: "POST",
      data: {
        "cart_id": cartId,
      },
    );
  }
}
