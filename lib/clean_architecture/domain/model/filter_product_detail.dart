// To parse this JSON data, do
//
//     final filterProductDetail = filterProductDetailFromMap(jsonString);

import 'dart:convert';

import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';

FilterProductDetail filterProductDetailFromMap(String str) => FilterProductDetail.fromMap(json.decode(str));

String filterProductDetailToMap(FilterProductDetail data) => json.encode(data.toMap());

class FilterProductDetail {
  FilterProductDetail({
    this.brands,
    this.categories,
    this.productTypes,
    this.attributes,
    this.priceRange,
  });

  final List<Brand>? brands;
  final List<Brand>? categories;
  final List<Brand>? productTypes;
  final List<ProductAttribute>? attributes;
  final PriceRange? priceRange;

  FilterProductDetail copyWith({
    List<Brand>? brands,
    List<Brand>? categories,
    List<Brand>? productTypes,
    List<ProductAttribute>? attributes,
    PriceRange? priceRange,
  }) =>
      FilterProductDetail(
        brands: brands ?? this.brands,
        categories: categories ?? this.categories,
        productTypes: productTypes ?? this.productTypes,
        attributes: attributes ?? this.attributes,
        priceRange: priceRange ?? this.priceRange,
      );

  factory FilterProductDetail.fromMap(Map<String, dynamic> json) => FilterProductDetail(
    brands: json["brands"] == null ? null : List<Brand>.from(json["brands"].map((x) => Brand.fromMap(x))),
    categories: json["categories"] == null ? null : List<Brand>.from(json["categories"].map((x) => Brand.fromMap(x))),
    productTypes: json["product_types"] == null ? null : List<Brand>.from(json["product_types"].map((x) => Brand.fromMap(x))),
    attributes: json["attributes"] == null ? null : List<ProductAttribute>.from(json["attributes"].map((x) => ProductAttribute.fromMap(x))),
    priceRange: json["price_range"] == null ? null : PriceRange.fromMap(json["price_range"]),
  );

  Map<String, dynamic> toMap() => {
    "brands": brands == null ? null : List<dynamic>.from(brands!.map((x) => x.toMap())),
    "categories": categories == null ? null : List<dynamic>.from(categories!.map((x) => x.toMap())),
    "product_types": productTypes == null ? null : List<dynamic>.from(productTypes!.map((x) => x.toMap())),
    "attributes": attributes == null ? null : List<dynamic>.from(attributes!.map((x) => x.toMap())),
    "price_range": priceRange == null ? null : priceRange!.toMap(),
  };
}

class PriceRange {
  PriceRange({
    this.priceRangeDefault,
    this.normal,
    this.filtered,
  });

  final Default? priceRangeDefault;
  final Default? normal;
  final Default? filtered;

  PriceRange copyWith({
    Default? priceRangeDefault,
    Default? normal,
    Default? filtered,
  }) =>
      PriceRange(
        priceRangeDefault: priceRangeDefault ?? this.priceRangeDefault,
        normal: normal ?? this.normal,
        filtered: filtered ?? this.filtered,
      );

  factory PriceRange.fromMap(Map<String, dynamic> json) => PriceRange(
    priceRangeDefault: json["default"] == null ? null : Default.fromMap(json["default"]),
    normal: json["normal"] == null ? null : Default.fromMap(json["normal"]),
    filtered: json["filtered"] == null ? null : Default.fromMap(json["filtered"]),
  );

  Map<String, dynamic> toMap() => {
    "default": priceRangeDefault == null ? null : priceRangeDefault!.toMap(),
    "normal": normal == null ? null : normal!.toMap(),
    "filtered": filtered == null ? null : filtered!.toMap(),
  };
}

class Default {
  Default({
    this.max,
    this.min,
  });

  final double? max;
  final double? min;

  Default copyWith({
    double? max,
    double? min,
  }) =>
      Default(
        max: max ?? this.max,
        min: min ?? this.min,
      );

  factory Default.fromMap(Map<String, dynamic> json) => Default(
    max: json["max"] == null ? null : json["max"].toDouble(),
    min: json["min"] == null ? null : json["min"].toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "max": max == null ? null : max,
    "min": min == null ? null : min,
  };

}
