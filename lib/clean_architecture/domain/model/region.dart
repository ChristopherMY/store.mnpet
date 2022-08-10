// To parse this JSON data, do
//
//     final region = regionFromMap(jsonString);

import 'dart:convert';

Region regionFromMap(String str) => Region.fromMap(json.decode(str));

String regionToMap(Region data) => json.encode(data.toMap());

class Region {
  Region({
    this.id,
    this.regionId,
    this.name,
    this.checked,
  });

  final String? id;
  final String? regionId;
  final String? name;
  bool? checked;

  factory Region.fromMap(Map<String, dynamic> json) => Region(
        id: json["_id"] == null ? null : json["_id"],
        regionId: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        checked: json["checked"] == null ? false : json["checked"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "id": regionId == null ? null : regionId,
        "name": name == null ? null : name,
        "checked": checked == null ? false : checked,
      };
}
