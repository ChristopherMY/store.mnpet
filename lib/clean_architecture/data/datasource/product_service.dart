import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/http.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/repository/product_repository.dart';
import '../../helper/http_response.dart';

class ProductService implements ProductRepositoryInterface {
  final _url = Environment.API_DAO;
  final Http _dio = Http(logsEnabled: false);

  // void
  @override
  Future<HttpResponse> setProductAnalytic({required String productId}) async {
    String url = "$_url/api/v1/analytics";
    Map<String, dynamic> bodyParams = {"id": productId};

    return await _dio.request(
      url,
      method: "POST",
      headers: headers,
      data: bodyParams,
    );
  }

  // Comment
  @override
  Future<HttpResponse> getProductFeedback({required String productId}) async {
    return await _dio.request(
      "$_url/api/v1/comments/$productId",
      method: "GET",
      headers: headers,
    );

    //   if (res.statusCode == 200) {
    //     final data = json.decode(res.body);
    //     return Comment.fromMap(data);
    //   }
    //   return null;
    // } on Exception catch (e) {
    //   if (kDebugMode) {
    //     print(e);
    //   }
    //   return null;
    // }
  }

  // Product
  @override
  Future<HttpResponse> getProductSlug({required String slug}) async {
    return await _dio.request(
      "$_url/api/v1/products/detail/$slug",
      method: "GET",
      headers: headers,
    );
  }

  // String
  @override
  Future<HttpResponse> getShipmentPriceCost({
    required String slug,
    required String districtId,
    required int quantity,
  }) async {
    Map<String, dynamic> body = {
      "slug": slug,
      "district_id": districtId,
      "quantity": quantity,
    };

    return await _dio.request(
      "$_url/api/v1/shipment/calculate-product",
      method: "POST",
      headers: headers,
      data: body,
    );
  }

  // List<Product>
  @override
  Future<HttpResponse> getRelatedProductsPagination({
    required List<Brand> categories,
    required int initialRange,
    required int finalRange,
  }) async {
    Map<String, dynamic> binding = {
      "categories": categories.map((e) => e.id).toList().cast()
    };

    return await _dio.request(
      "$_url/api/v1/products/related-by-category?skip=$initialRange&limit=$finalRange",
      method: "POST",
      headers: headers,
      data: binding,
    );
  }

  // dynamic
  @override
  Future<dynamic> launchPhoneDialer({
    required String contactNumber,
  }) async {
    final Uri phoneUri = Uri(scheme: "tel", path: contactNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      }
    } on Exception catch (error) {
      throw ("Cannot dial");
    }
  }

  // VimeoVideoConfig
  @override
  Future<HttpResponse> vimeoVideoConfigFromUrl({
    required String vimeoVideoId,
  }) async {
    return await _dio.request(
      'https://player.vimeo.com/video/$vimeoVideoId/config',
    );
  }

  @override
  Future<HttpResponse> getFiltersProductDetails({
    required Map<String, dynamic> bindings,
  }) async {
    return await _dio.request(
      "$_url/api/v1/search/filters",
      method: "POST",
      headers: headers,
      data: bindings,
    );
  }

  @override
  Future<HttpResponse> getSearchProductDetails({
    required Map<String, dynamic> bindings,
  }) async {
    return await _dio.request(
      "$_url/api/v1/search/",
      method: "POST",
      headers: headers,
      data: bindings,
    );
  }
}
