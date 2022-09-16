// To parse this JSON data, do
//
//     final keyword = keywordFromMap(jsonString);

import 'dart:convert';

Keyword keywordFromMap(String str) => Keyword.fromMap(json.decode(str));

String keywordToMap(Keyword data) => json.encode(data.toMap());

class Keyword {
  Keyword({
    this.id,
    this.name,
    this.slug,
  });

  final String? id;
  final String? name;
  final String? slug;

  factory Keyword.fromMap(Map<String, dynamic> json) => Keyword(
    id: json["_id"] == null ? null : json["_id"],
    name: json["name"] == null ? null : json["name"],
    slug: json["slug"] == null ? null : json["slug"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id == null ? null : id,
    "name": name == null ? null : name,
    "slug": slug == null ? null : slug,
  };
}
