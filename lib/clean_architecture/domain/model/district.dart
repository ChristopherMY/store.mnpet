// To parse this JSON data, do
//
//     final district = districtFromMap(jsonString);

import 'dart:convert';

District districtFromMap(String str) => District.fromMap(json.decode(str));

String districtToMap(District data) => json.encode(data.toMap());

class District {
  District({
    this.id,
    this.districtId,
    this.name,
    this.provinceId,
    this.departmentId,
    this.checked
  });

  final String? id;
  final String? districtId;
  final String? name;
  final String? provinceId;
  final String? departmentId;
  bool? checked;

  factory District.fromMap(Map<String, dynamic> json) => District(
    id: json["_id"] == null ? null : json["_id"],
    districtId: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    provinceId: json["province_id"] == null ? null : json["province_id"],
    departmentId: json["department_id"] == null ? null : json["department_id"],
    checked: json["checked"] == null ? false : json["checked"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id == null ? null : id,
    "id": districtId == null ? null : districtId,
    "name": name == null ? null : name,
    "province_id": provinceId == null ? null : provinceId,
    "department_id": departmentId == null ? null : departmentId,
    "checked": checked == null ? false : checked,
  };
}
