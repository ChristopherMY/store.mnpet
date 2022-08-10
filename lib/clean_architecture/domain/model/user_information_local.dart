// To parse this JSON data, do
//
//     final userInformationLocal = userInformationLocalFromMap(jsonString);

import 'dart:convert';

UserInformationLocal userInformationLocalFromMap(String str) => UserInformationLocal.fromMap(json.decode(str));

String userInformationLocalToMap(UserInformationLocal data) => json.encode(data.toMap());

class UserInformationLocal {
  UserInformationLocal({
    this.department,
    this.province,
    this.district,
    this.districtId,
    this.ubigeo,
  });

  final String? department;
  final String? province;
  final String? district;
  final String? districtId;
  final String? ubigeo;

  factory UserInformationLocal.fromMap(Map<String, dynamic> json) => UserInformationLocal(
    department: json["department"] == null ? null : json["department"],
    province: json["province"] == null ? null : json["province"],
    district: json["district"] == null ? null : json["district"],
    districtId: json["districtId"] == null ? null : json["districtId"],
    ubigeo: json["ubigeo"] == null ? null : json["ubigeo"],
  );

  Map<String, dynamic> toMap() => {
    "department": department == null ? null : department,
    "province": province == null ? null : province,
    "district": district == null ? null : district,
    "districtId": districtId == null ? null : districtId,
    "ubigeo": ubigeo == null ? null : ubigeo,
  };
}
