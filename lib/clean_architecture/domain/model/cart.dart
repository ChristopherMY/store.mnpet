// To parse this JSON data, do
//
//     final cart = cartFromMap(jsonString);

import 'dart:convert';

import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';

Cart cartFromMap(String str) => Cart.fromMap(json.decode(str));

String cartToMap(Cart data) => json.encode(data.toMap());

class Cart {
  Cart({
    this.id,
    this.userId,
    this.products,
    this.subTotal,
    this.shipment,
    this.total,
  });

  final String? id;
  final String? userId;
  final List<Product>? products;
  final String? subTotal;
  final String? shipment;
  final String? total;

  factory Cart.fromMap(Map<String, dynamic> json) => Cart(
    id: json["_id"] == null ? null : json["_id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    products: json["products"] == null ? null : List<Product>.from(json["products"].map((x) => Product.fromMap(x))),
    subTotal: json["sub_total"] == null ? null : json["sub_total"],
    shipment: json["profile"] == null ? null : json["profile"],
    total: json["total"] == null ? null : json["total"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id == null ? null : id,
    "user_id": userId == null ? null : userId,
    "products": products == null ? null : List<dynamic>.from(products!.map((x) => x.toMap())),
    "sub_total": subTotal == null ? null : subTotal,
    "profile": shipment == null ? null : shipment,
    "total": total == null ? null : total,
  };
}