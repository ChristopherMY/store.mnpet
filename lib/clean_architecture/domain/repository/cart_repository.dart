import '../../helper/http_response.dart';

abstract class CartRepositoryInterface {
  // http.Response
  Future<HttpResponse> saveShoppingCart({
    required Map<String, dynamic> cart,
    required Map<String, String> headers,
  });

  // Cart
  Future<HttpResponse> getShoppingCart({
    required String districtId,
    required Map<String, String> headers,
  });

  // Cart
  Future<HttpResponse> moveShoppingCart({
    required String cartId,
    required Map<String, String> headers,
  });


  // http.response
  Future<HttpResponse> deleteProductCart({
    required String productId,
    required String variationId,
    required Map<String, String> headers,
  });

  // http.response
  Future<HttpResponse> updateProductCart({
    required String productId,
    required String variationId,
    required int quantity,
    required Map<String, String> headers,
  });

  // http.Response
  Future<HttpResponse> onSaveShoppingCartTemp({required Map<String, dynamic> cart});

  // Cart
  Future<HttpResponse> getShoppingCartTemp({
    required String districtId,
    required Map<String, String> headers,
  });

  // http.response
  Future<HttpResponse> deleteProductCartTemp({
    required String cartId,
    required String productId,
    required String variationId,
  });

  // http.response
  Future<HttpResponse> updateProductCartTemp({
    required String cartId,
    required String productId,
    required String variationId,
    required int quantity,
  });
}
