abstract class CartRepositoryInterface {
  // http.Response
  Future<dynamic> onSaveShoppingCart({
    required Map<String, dynamic> cart,
    required String districtId,
  });

  // Cart
  Future<dynamic> getShoppingCart({required String districtId});

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
}
