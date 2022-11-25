// To parse this JSON data, do
//
//     final checkCartTemporal = checkCartTemporalFromMap(jsonString);

import 'dart:convert';

CheckCartTemporal checkCartTemporalFromMap(String str) => CheckCartTemporal.fromMap(json.decode(str));

String checkCartTemporalToMap(CheckCartTemporal data) => json.encode(data.toMap());

class CheckCartTemporal {
  CheckCartTemporal({
    required this.cartId,
    required this.expiresIn,
  });

  final String cartId;
  final int expiresIn;

  CheckCartTemporal copyWith({
     String? cartId,
    int? expiresIn,
  }) => CheckCartTemporal(
        cartId: cartId ?? this.cartId,
        expiresIn: expiresIn ?? this.expiresIn,
      );

  factory CheckCartTemporal.fromMap(Map<String, dynamic> json) => CheckCartTemporal(
    cartId: json["cart_id"] == null ? null : json["cart_id"],
    expiresIn: json["expiresIn"] == null ? null : json["expiresIn"],
  );

  Map<String, dynamic> toMap() => {
    "cart_id": cartId == null ? null : cartId,
    "expiresIn": expiresIn == null ? null : expiresIn,
  };
}
