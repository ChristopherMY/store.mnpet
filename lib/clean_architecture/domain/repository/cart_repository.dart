abstract class CartRepositoryInterface {
  // http.Response
  Future<dynamic> saveShoppingCart({
    required Map<String, dynamic> cart,
    required Map<String, String> headers,
  });

  // Cart
  Future<dynamic> getShoppingCart({
    required String districtId,
    required Map<String, String> headers,
  });

  // Cart
  Future<dynamic> moveShoppingCart({
    required String cartId,
    required Map<String, String> headers,
  });


  // http.response
  Future<dynamic> deleteProductCart({
    required String productId,
    required String variationId,
    required Map<String, String> headers,
  });

  // http.response
  Future<dynamic> updateProductCart({
    required String productId,
    required String variationId,
    required int quantity,
    required Map<String, String> headers,
  });

  // http.Response
  Future<dynamic> onSaveShoppingCartTemp({required Map<String, dynamic> cart});

  // Cart
  Future<dynamic> getShoppingCartTemp({
    required String districtId,
    required Map<String, String> headers,
  });

  // http.response
  Future<dynamic> deleteProductCartTemp({
    required String cartId,
    required String productId,
    required String variationId,
  });

  // http.response
  Future<dynamic> updateProductCartTemp({
    required String cartId,
    required String productId,
    required String variationId,
    required int quantity,
  });
}
