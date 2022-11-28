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
    this.showDescription,
    this.name,
    this.color,
    this.description,
    this.category,
    this.images,
  });

  final String? id;
  final bool? showDescription;
  final String? name;
  final String? color;
  final String? description;
  final MasterCategory? category;
  final List<MainImage>? images;

  Banners copyWith({
    String? id,
    bool? showDescription,
    String? name,
    String? color,
    String? description,
    MasterCategory? category,
    List<MainImage>? images,
  }) =>
      Banners(
        id: id ?? this.id,
        showDescription: showDescription ?? this.showDescription,
        name: name ?? this.name,
        color: color ?? this.color,
        description: description ?? this.description,
        category: category ?? this.category,
        images: images ?? this.images,
      );

  factory Banners.fromMap(Map<String, dynamic> json) => Banners(
        id: json["_id"] == null ? null : json["_id"],
        showDescription:
            json["show_description"] == null ? null : json["show_description"],
        name: json["name"] == null ? null : json["name"],
        color: json["color"] == null ? null : json["color"],
        description: json["description"] == null ? null : json["description"],
        category: json["category"] == null
            ? null
            : MasterCategory.fromMap(json["category"]),
        images: json["images"] == null
            ? null
            : List<MainImage>.from(
                json["images"].map((x) => MainImage.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "show_description": showDescription == null ? null : showDescription,
        "name": name == null ? null : name,
        "color": color == null ? null : color,
        "description": description == null ? null : description,
        "category": category == null ? null : category?.toMap(),
        "images": images == null
            ? null
            : List<dynamic>.from(images!.map((x) => x.toMap())),
      };
}
