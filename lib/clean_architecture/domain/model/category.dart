// To parse this JSON data, do
//
//     final masterCategory = masterCategoryFromMap(jsonString);

import 'dart:convert';

MasterCategory masterCategoryFromMap(String str) =>
    MasterCategory.fromMap(json.decode(str));

String masterCategoryToMap(MasterCategory data) => json.encode(data.toMap());

class MasterCategory {
  MasterCategory({
    this.id,
    this.name,
    this.description,
    this.relations,
    this.slug,
    this.hexa,
    this.shortName,
    this.image,
  });

  final String? id;
  final String? name;
  final String? description;
  final List<Relation>? relations;
  final String? slug;
  final String? hexa;
  final String? shortName;
  final ImageCategory? image;



  factory MasterCategory.fromMap(Map<String, dynamic> json) => MasterCategory(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        relations: json["relations"] == null
            ? null
            : List<Relation>.from(
                json["relations"].map((x) => Relation.fromMap(x))),
        slug: json["slug"] == null ? null : json["slug"],
        hexa: json["hexa"] == null ? null : json["hexa"],
        shortName: json["short_name"] == null ? null : json["short_name"],
        image: json["image"] == null
            ? ImageCategory.fromMap({
                "src": "https://via.placeholder.com/250x200",
                "dimensions": {
                  "width": 0,
                  "height": 0,
                },
                "aspectRatio": 1.25,
              })
            : ImageCategory.fromMap(json["image"]),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "relations": relations == null
            ? null
            : List<dynamic>.from(relations!.map((x) => x.toMap())),
        "slug": slug == null ? null : slug,
        "hexa": hexa == null ? null : hexa,
        "short_name": shortName == null ? null : shortName,
        "image": image == null ? null : image!.toMap(),
      };

  MasterCategory copyWith({
    String? id,
    String? name,
    String? description,
    List<Relation>? relations,
    String? slug,
    String? hexa,
    String? shortName,
    ImageCategory? image,
  }) {
    return MasterCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      relations: relations ?? this.relations,
      slug: slug ?? this.slug,
      hexa: hexa ?? this.hexa,
      shortName: shortName ?? this.shortName,
      image: image ?? this.image,
    );
  }
}

class Relation {
  Relation({
    this.name,
    this.relations,
    this.slug,
  });

  final String? name;
  final List<dynamic>? relations;
  final String? slug;

  factory Relation.fromMap(Map<String, dynamic> json) => Relation(
        name: json["name"] == null ? null : json["name"],
        relations: json["relations"] == null
            ? null
            : List<dynamic>.from(json["relations"].map((x)  => x)),
        slug: json["slug"] == null ? null : json["slug"],
      );

  Map<String, dynamic> toMap() => {
        "name": name == null ? null : name,
        "relations": relations == null
            ? null
            : List<dynamic>.from(relations!.map((x) => x)),
        "slug": slug == null ? null : slug,
      };
}

class ImageCategory {
  ImageCategory({
    this.id,
    this.src,
    this.dimensions,
    this.aspectRatio,
    this.type,
    this.format,
    this.key,
  });

  final String? id;
  final String? src;
  final Dimensions? dimensions;
  final double? aspectRatio;
  final String? type;
  final String? format;
  final String? key;

  factory ImageCategory.fromMap(Map<String, dynamic> json) => ImageCategory(
        id: json["_id"] == null ? null : json["_id"],
        src: json["src"] == null ? null : json["src"],
        dimensions: json["dimensions"] == null
            ? null
            : Dimensions.fromMap(json["dimensions"]),
        aspectRatio: json["aspect_ratio"] == null
            ? null
            : json["aspect_ratio"].toDouble(),
        type: json["type"] == null ? null : json["type"],
        format: json["format"] == null ? null : json["format"],
        key: json["key"] == null ? null : json["key"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "src": src == null ? null : src,
        "dimensions": dimensions == null ? null : dimensions!.toMap(),
        "aspectRatio": aspectRatio == null ? null : aspectRatio,
        "type": type == null ? null : type,
        "format": format == null ? null : format,
        "key": key == null ? null : key,
      };
}

class Dimensions {
  Dimensions({
    this.height,
    this.width,
  });

  final double? height;
  final double? width;

  factory Dimensions.fromMap(Map<String, dynamic> json) => Dimensions(
        height: json["height"] == null ? null : json["height"].toDouble(),
        width: json["width"] == null ? null : json["width"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "height": height == null ? null : height,
        "width": width == null ? null : width,
      };
}
