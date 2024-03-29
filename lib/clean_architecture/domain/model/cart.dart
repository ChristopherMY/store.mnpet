// To parse this JSON data, do
//
//     final cart = cartFromMap(jsonString);

import 'dart:convert';

import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';

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
    id: json["_id"] ?? "",
    userId: json["user_id"]?? "",
    products: json["products"] == null ? [] : List<Product>.from(json["products"].map((x) => Product.fromMap(x))),
    subTotal: json["sub_total"] ?? "",
    shipment: json["shipment"] ?? "",
    total: json["total"] ?? "",
  );

  Map<String, dynamic> toMap() => {
    "_id": id ?? "",
    "user_id": userId ?? "",
    "products": products == null ? null : List<dynamic>.from(products!.map((x) => x.toMap())),
    "sub_total": subTotal ?? "",
    "shipment": shipment ?? "",
    "total": total ?? "",
  };
}