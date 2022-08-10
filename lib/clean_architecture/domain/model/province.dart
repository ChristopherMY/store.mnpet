// To parse this JSON data, do
//
//     final province = provinceFromMap(jsonString);

import 'dart:convert';

Province provinceFromMap(String str) => Province.fromMap(json.decode(str));

String provinceToMap(Province data) => json.encode(data.toMap());

class Province {
  Province({
    this.id,
    this.provinceId,
    this.name,
    this.departmentId,
    this.checked
  });

  final String? id;
  final String? provinceId;
  final String? name;
  final String? departmentId;
  bool? checked;

  factory Province.fromMap(Map<String, dynamic> json) => Province(
    id: json["_id"] == null ? null : json["_id"],
    provinceId: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    departmentId: json["department_id"] == null ? null : json["department_id"],
    checked: json["checked"] == null ? false : json["checked"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id == null ? null : id,
    "id": provinceId == null ? null : provinceId,
    "name": name == null ? null : name,
    "department_id": departmentId == null ? null : departmentId,
    "checked": checked == null ? false : checked,
  };
}
