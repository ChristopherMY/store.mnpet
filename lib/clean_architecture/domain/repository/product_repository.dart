import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import '../../helper/http_response.dart';
abstract class ProductRepositoryInterface {
  // void
  Future<HttpResponse> setProductAnalytic({required String productId});

  // Comment
  Future<HttpResponse> getProductFeedback({required String productId});

  // Product
  Future<HttpResponse> getProductSlug({required String slug});

  // String
  Future<HttpResponse> getShipmentPriceCost({
    required String slug,
    required String districtId,
    required int quantity,
  });

  // List<Product>
  Future<HttpResponse> getRelatedProductsPagination({
    required List<Brand> categories,
    required int initialRange,
    required int finalRange,
  });

  // dynamic
  Future<dynamic> launchPhoneDialer({required String contactNumber});

  // VimeoVideoConfig
  Future<HttpResponse> vimeoVideoConfigFromUrl({required String vimeoVideoId});

  Future<HttpResponse> getSearchProductDetails(
      {required Map<String, dynamic> bindings});

  Future<HttpResponse> getFiltersProductDetails(
      {required Map<String, dynamic> bindings});
}
