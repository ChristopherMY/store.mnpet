// To parse this JSON data, do
//
//     final bindingSearch = bindingSearchFromMap(jsonString);

import 'dart:convert';

BindingSearch bindingSearchFromMap(String str) =>
    BindingSearch.fromMap(json.decode(str));

String bindingSearchToMap(BindingSearch data) => json.encode(data.toMap());

class BindingSearch {
  BindingSearch({
    this.search,
    this.page,
    this.order,
    this.limit,
    this.brands,
    this.categories,
    this.productTypes,
    this.attributes,
    this.attributesTerm,
    this.keywords,
    this.min,
    this.max,
    this.firstSearch,
  });

  String? search;
  int? page;
  String? order;
  int? limit;
  List<String>? brands;
  List<String>? categories;
  List<String>? productTypes;
  List<String>? attributes;
  List<String>? attributesTerm;
  List<String>? keywords;
  double? min;
  double? max;
  bool? firstSearch;

  BindingSearch copyWith({
    String? search,
    int? page,
    String? order,
    int? limit,
    List<String>? brands,
    List<String>? categories,
    List<String>? productTypes,
    List<String>? attributes,
    List<String>? attributesTerm,
    List<String>? keywords,
    double? min,
    double? max,
    bool? firstSearch,
  }) =>
      BindingSearch(
        search: search ?? this.search,
        page: page ?? this.page,
        order: order ?? this.order,
        limit: limit ?? this.limit,
        brands: brands ?? this.brands,
        categories: categories ?? this.categories,
        productTypes: productTypes ?? this.productTypes,
        attributes: attributes ?? this.attributes,
        attributesTerm: attributesTerm ?? this.attributesTerm,
        keywords: keywords ?? keywords,
        min: min ?? this.min,
        max: max ?? this.max,
        firstSearch: firstSearch ?? this.firstSearch,
      );

  Map<String, dynamic> toMap() {
    return {
      'search': search ?? "",
      'page': page ?? 0,
      'order': order ?? "asc",
      'limit': limit ?? 16,
      'brands': brands ?? <String>[],
      'categories': categories ?? <String>[],
      'product_types': productTypes ?? <String>[],
      'attributes': attributes ?? <String>[],
      'attributes_term': attributesTerm ?? <String>[],
      'keywords': keywords ?? <String>[],
      'min': min ?? 0.0,
      'max': max ?? 500.0,
    };
  }

  factory BindingSearch.fromMap(Map<String, dynamic> map) {
    return BindingSearch(
      search: map['search'] as String,
      page: map['page'] as int,
      order: map['order'] as String,
      limit: map['limit'] as int,
      brands: map['brands'] as List<String>,
      categories: map['categories'] as List<String>,
      productTypes: map['product_types'] as List<String>,
      attributes: map['attributes'] as List<String>,
      attributesTerm: map['attributes_term'] as List<String>,
      keywords: map['keywords'] as List<String>,
      min: map['min'] as double,
      max: map['max'] as double,
    );
  }
}
