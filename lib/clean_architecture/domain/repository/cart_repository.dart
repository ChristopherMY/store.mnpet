abstract class CartRepositoryInterface {
  // http.Response
  Future<dynamic> onSaveShoppingCart({
    required Map<String, dynamic> cart,
    required String districtId,
  });

  // Cart
  Future<dynamic> getShoppingCart({
    required String districtId,
    required Map<String, String> headers,
  });

  // http.response
  Future<dynamic> deleteProductCart({
    required String cartId,
    required String variationId,
    required String districtId,
  });

  // http.response
  Future<dynamic> updateProductCart({
    required String districtId,
    required String productId,
    required String variationId,
    required int quantity,
  });

  // http.Response
  Future<dynamic> onSaveShoppingCartTemp({
    required Map<String, dynamic> cart,
    required String districtId,
  });

  // Cart
  Future<dynamic> getShoppingCartTemp({
    required String districtId,
    required Map<String, String> headers,
  });

  // http.response
  Future<dynamic> deleteProductCartTemp({
    required String cartId,
    required String variationId,
    required String districtId,
  });

  // http.response
  Future<dynamic> updateProductCartTemp({
    required String districtId,
    required String productId,
    required String variationId,
    required int quantity,
  });
}
