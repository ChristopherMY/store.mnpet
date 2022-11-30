// To parse this JSON data, do
//
//     final banners = bannersFromMap(jsonString);

import 'dart:convert';

import 'package:store_mundo_negocio/clean_architecture/domain/model/category.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';

List<Banners> bannersFromMap(String str) =>
    List<Banners>.from(json.decode(str).map((x) => Banners.fromMap(x)));

String bannersToMap(List<Banners> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Banners {
  Banners({
    this.id,
    this.isContainer,
    this.visibility,
    this.name,
    this.color,
    this.description,
    this.categories,
    this.banners,
  });

  final String? id;
  final bool? isContainer;
  final Visibility? visibility;
  final String? name;
  final String? color;
  final String? description;

  final List<MasterCategory>? categories;
  final List<Banner>? banners;

  Banners copyWith({
    String? id,
    bool? isContainer,
    Visibility? visibility,
    String? name,
    String? color,
    String? description,
    List<MasterCategory>? categories,
    List<Banner>? banners,
  }) =>
      Banners(
        id: id ?? this.id,
        isContainer: isContainer ?? this.isContainer,
        visibility: visibility ?? this.visibility,
        name: name ?? this.name,
        color: color ?? this.color,
        description: description ?? this.description,
        categories: categories ?? this.categories,
        banners: banners ?? this.banners,
      );

  factory Banners.fromMap(Map<String, dynamic> json) => Banners(
        id: json["_id"] == null ? null : json["_id"],
        isContainer: json["is_container"] == null ? null : json["is_container"],
        visibility: json["visibility"] == null
            ? null
            : Visibility.fromMap(json["visibility"]),
        name: json["name"] == null ? null : json["name"],
        color: json["color"] == null ? null : json["color"],
        description: json["description"] == null ? null : json["description"],
        categories: json["categories"] == null
            ? null
            : List<MasterCategory>.from(
                json["categories"].map((x) => MasterCategory.fromMap(x))),
        banners: json["banners"] == null
            ? null
            : List<Banner>.from(json["banners"].map((x) => Banner.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "is_container": isContainer == null ? null : isContainer,
        "visibility": visibility == null ? null : visibility!.toMap(),
        "name": name == null ? null : name,
        "color": color == null ? null : color,
        "description": description == null ? null : description,
        "categories": categories == null
            ? null
            : List<dynamic>.from(categories!.map((x) => x.toMap())),
        "banners": banners == null
            ? null
            : List<dynamic>.from(banners!.map((x) => x.toMap())),
      };
}

class Banner {
  Banner({
    this.image,
    this.categories,
    this.order,
  });

  final MainImage? image;
  final List<MasterCategory>? categories;
  final int? order;

  Banner copyWith({
    MainImage? image,
    List<MasterCategory>? categories,
    int? order,
  }) =>
      Banner(
        image: image ?? this.image,
        categories: categories ?? this.categories,
        order: order ?? this.order,
      );

  factory Banner.fromMap(Map<String, dynamic> json) => Banner(
        image: json["image"] == null ? null : MainImage.fromMap(json["image"]),
        categories: json["categories"] == null
            ? null
            : List<MasterCategory>.from(
                json["categories"].map((x) => MasterCategory.fromMap(x))),
        order: json["order"] == null ? null : json["order"],
      );

  Map<String, dynamic> toMap() => {
        "image": image == null ? null : image!.toMap(),
        "categories": categories == null
            ? null
            : List<dynamic>.from(categories!.map((x) => x.toMap())),
        "order": order == null ? null : order,
      };
}

class Visibility {
  Visibility({
    this.name,
    this.color,
    this.description,
  });

  final bool? name;
  final bool? color;
  final bool? description;

  Visibility copyWith({
    bool? name,
    bool? color,
    bool? description,
  }) =>
      Visibility(
        name: name ?? this.name,
        color: color ?? this.color,
        description: description ?? this.description,
      );

  factory Visibility.fromMap(Map<String, dynamic> json) => Visibility(
        name: json["name"] == null ? null : json["name"],
        color: json["color"] == null ? null : json["color"],
        description: json["description"] == null ? null : json["description"],
      );

  Map<String, dynamic> toMap() => {
        "name": name == null ? null : name,
        "color": color == null ? null : color,
        "description": description == null ? null : description,
      };
}
