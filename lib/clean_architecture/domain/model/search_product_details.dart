// To parse this JSON data, do
//
//     final searchProductDetails = searchProductDetailsFromMap(jsonString);

import 'dart:convert';

import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';

SearchProductDetails searchProductDetailsFromMap(String str) => SearchProductDetails.fromMap(json.decode(str));

String searchProductDetailsToMap(SearchProductDetails data) => json.encode(data.toMap());

class SearchProductDetails {
  SearchProductDetails({
    this.docs,
    this.totalDocs,
    this.limit,
    this.page,
    this.totalPages,
    this.pagingCounter,
    this.hasPrevPage,
    this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  final List<Product>? docs;
  final int? totalDocs;
  final int? limit;
  final int? page;
  final int? totalPages;
  final int? pagingCounter;
  final bool? hasPrevPage;
  final bool? hasNextPage;
  final dynamic prevPage;
  final int? nextPage;

  factory SearchProductDetails.fromMap(Map<String, dynamic> json) => SearchProductDetails(
    docs: json["docs"] == null ? null : List<Product>.from(json["docs"].map((x) => Product.fromMap(x))),
    totalDocs: json["totalDocs"] == null ? null : json["totalDocs"],
    limit: json["limit"] == null ? null : json["limit"],
    page: json["page"] == null ? null : json["page"],
    totalPages: json["totalPages"] == null ? null : json["totalPages"],
    pagingCounter: json["pagingCounter"] == null ? null : json["pagingCounter"],
    hasPrevPage: json["hasPrevPage"] == null ? null : json["hasPrevPage"],
    hasNextPage: json["hasNextPage"] == null ? null : json["hasNextPage"],
    prevPage: json["prevPage"],
    nextPage: json["nextPage"] == null ? null : json["nextPage"],
  );

  Map<String, dynamic> toMap() => {
    "docs": docs == null ? null : List<dynamic>.from(docs!.map((x) => x.toMap())),
    "totalDocs": totalDocs == null ? null : totalDocs,
    "limit": limit == null ? null : limit,
    "page": page == null ? null : page,
    "totalPages": totalPages == null ? null : totalPages,
    "pagingCounter": pagingCounter == null ? null : pagingCounter,
    "hasPrevPage": hasPrevPage == null ? null : hasPrevPage,
    "hasNextPage": hasNextPage == null ? null : hasNextPage,
    "prevPage": prevPage,
    "nextPage": nextPage == null ? null : nextPage,
  };
}