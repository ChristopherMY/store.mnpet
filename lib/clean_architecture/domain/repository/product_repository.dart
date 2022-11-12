import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';

abstract class ProductRepositoryInterface {
  // void
  Future<dynamic> setProductAnalytic({required String productId});

  // Comment
  Future<dynamic> getProductFeedback({required String productId});

  // Product
  Future<dynamic> getProductSlug({required String slug});

  // String
  Future<dynamic> getShipmentPriceCost({
    required String slug,
    required String districtId,
    required int quantity,
  });

  // List<Product>
  Future<dynamic> getRelatedProductsPagination({
    required List<Brand> categories,
    required int initialRange,
    required int finalRange,
  });

  // dynamic
  Future<dynamic> launchPhoneDialer({required String contactNumber});

  // VimeoVideoConfig
  Future<dynamic> vimeoVideoConfigFromUrl({required String vimeoVideoId});

  Future<dynamic> getSearchProductDetails(
      {required Map<String, dynamic> bindings});

  Future<dynamic> getFiltersProductDetails(
      {required Map<String, dynamic> bindings});
}
