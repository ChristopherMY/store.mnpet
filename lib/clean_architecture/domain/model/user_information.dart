// To parse this JSON data, do
//
//     final userInformation = userInformationFromMap(jsonString);

import 'dart:convert';

import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';

UserInformation userInformationFromMap(String str) =>
    UserInformation.fromMap(json.decode(str));

String userInformationToMap(UserInformation data) => json.encode(data.toMap());

Address addressFromMap(String str) => Address.fromMap(json.decode(str));

String addressToMap(Address data) => json.encode(data.toMap());

Phone phoneFromMap(String str) => Phone.fromMap(json.decode(str));

String phoneToMap(Phone data) => json.encode(data.toMap());

class UserInformation {
  UserInformation({
    this.id,
    this.name,
    this.lastname,
    this.document,
    this.email,
    this.password,
    this.permissions,
    this.businessRules,
    this.referral,
    this.image,
    this.updatedAt,
    this.createdAt,
    this.phones,
    this.addresses,
  });

  final String? id;
  final String? name;
  final String? lastname;
  final Document? document;
  final Email? email;
  final String? password;
  final Permissions? permissions;
  final BusinessRules? businessRules;
  final Referral? referral;
  final MainImage? image;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final List<Phone>? phones;
  final List<Address>? addresses;

  factory UserInformation.fromMap(Map<String, dynamic> json) => UserInformation(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        document: json["document"] == null
            ? null
            : Document.fromMap(json["document"]),
        email: json["email"] == null ? null : Email.fromMap(json["email"]),
        password: json["password"] == null ? null : json["password"],
        permissions: json["permissions"] == null
            ? null
            : Permissions.fromMap(json["permissions"]),
        businessRules: json["business_rules"] == null
            ? null
            : BusinessRules.fromMap(json["business_rules"]),
        referral: json["referral"] == null
            ? null
            : Referral.fromMap(json["referral"]),
        image: json["image"] == null ? null : MainImage.fromMap(json["image"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        phones: json["phones"] == null
            ? null
            : List<Phone>.from(json["phones"].map((x) => Phone.fromMap(x))),
        addresses: json["addresses"] == null
            ? null
            : List<Address>.from(
                json["addresses"].map((x) => Address.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "lastname": lastname == null ? null : lastname,
        "document": document == null ? null : document!.toMap(),
        "email": email == null ? null : email!.toMap(),
        "password": password == null ? null : password,
        "permissions": permissions == null ? null : permissions!.toMap(),
        "business_rules": businessRules == null ? null : businessRules!.toMap(),
        "referral": referral == null ? null : referral!.toMap(),
        "image": image == null ? null : image!.toMap(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "phones": phones == null
            ? []
            : List<dynamic>.from(phones!.map((x) => x.toMap())),
        "addresses": addresses == null
            ? []
            : List<dynamic>.from(addresses!.map((x) => x.toMap())),
      };
}

class Address {
  Address({
    this.id,
    this.addressDefault,
    this.direction,
    this.addressName,
    this.referenceName,
    this.addressType,
    this.lotNumber,
    this.dptoInt,
    this.urbanName,
    this.ubigeo,
    this.updatedAt,
    this.createdAt,
  });

  final String? id;
  bool? addressDefault;
  String? direction;
  String? addressName;
  String? referenceName;
  String? addressType;
  int? lotNumber;
  int? dptoInt;
  String? urbanName;
  final Ubigeo? ubigeo;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  factory Address.fromMap(Map<String, dynamic> json) => Address(
        id: json["_id"] == null ? null : json["_id"],
        addressDefault: json["default"] == null ? null : json["default"],
        direction: json["direction"] == null ? null : json["direction"],
        addressName: json["address_name"] == null ? null : json["address_name"],
        referenceName:
            json["reference_name"] == null ? null : json["reference_name"],
        addressType: json["address_type"] == null ? null : json["address_type"],
        lotNumber: json["lot_number"] == null ? null : json["lot_number"],
        dptoInt: json["dpto_int"] == null ? null : json["dpto_int"],
        urbanName: json["urban_name"] == null ? null : json["urban_name"],
        ubigeo: json["ubigeo"] == null ? null : Ubigeo.fromMap(json["ubigeo"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "default": addressDefault == null ? null : addressDefault,
        "direction": direction == null ? null : direction,
        "address_name": addressName == null ? null : addressName,
        "reference_name": referenceName == null ? null : referenceName,
        "address_type": addressType == null ? null : addressType,
        "lot_number": lotNumber == null ? null : lotNumber,
        "dpto_int": dptoInt == null ? null : dptoInt,
        "urban_name": urbanName == null ? null : urbanName,
        "ubigeo": ubigeo == null ? null : ubigeo!.toMap(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
      };
}

class Ubigeo {
  Ubigeo({
    this.departmentId,
    this.provinceId,
    this.districtId,
    this.department,
    this.province,
    this.district,
  });

  String? departmentId;
  String? provinceId;
  String? districtId;
  String? department;
  String? province;
  String? district;

  factory Ubigeo.fromMap(Map<String, dynamic> json) => Ubigeo(
        departmentId:
            json["department_id"] == null ? null : json["department_id"],
        provinceId: json["province_id"] == null ? null : json["province_id"],
        districtId: json["district_id"] == null ? null : json["district_id"],
        department: json["department"] == null ? null : json["department"],
        province: json["province"] == null ? null : json["province"],
        district: json["district"] == null ? null : json["district"],
      );

  Map<String, dynamic> toMap() => {
        "department_id": departmentId == null ? null : departmentId,
        "province_id": provinceId == null ? null : provinceId,
        "district_id": districtId == null ? null : districtId,
        "department": department == null ? null : department,
        "province": province == null ? null : province,
        "district": district == null ? null : district,
      };
}

class BusinessRules {
  BusinessRules({
    this.termsConditionsConfirmed,
    this.hasFirstPurchase,
  });

  final bool? termsConditionsConfirmed;
  final bool? hasFirstPurchase;

  factory BusinessRules.fromMap(Map<String, dynamic> json) => BusinessRules(
        termsConditionsConfirmed: json["terms_conditions_confirmed"] == null
            ? null
            : json["terms_conditions_confirmed"],
        hasFirstPurchase: json["has_first_purchase"] == null
            ? null
            : json["has_first_purchase"],
      );

  Map<String, dynamic> toMap() => {
        "terms_conditions_confirmed":
            termsConditionsConfirmed == null ? null : termsConditionsConfirmed,
        "has_first_purchase":
            hasFirstPurchase == null ? null : hasFirstPurchase,
      };
}

class Document {
  Document({
    this.value,
    this.type,
  });

  final String? value;
  final String? type;

  factory Document.fromMap(Map<String, dynamic> json) => Document(
        value: json["value"] == null ? null : json["value"],
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toMap() => {
        "value": value == null ? null : value,
        "type": type == null ? null : type,
      };
}

class Email {
  Email({
    this.address,
    this.confirmed,
  });

  final String? address;
  final bool? confirmed;

  factory Email.fromMap(Map<String, dynamic> json) => Email(
        address: json["address"] == null ? null : json["address"],
        confirmed: json["confirmed"] == null ? null : json["confirmed"],
      );

  Map<String, dynamic> toMap() => {
        "address": address == null ? null : address,
        "confirmed": confirmed == null ? null : confirmed,
      };
}

class Dimension {
  Dimension({
    this.width,
    this.height,
  });

  final int? width;
  final int? height;

  factory Dimension.fromMap(Map<String, dynamic> json) => Dimension(
        width: json["width"] == null ? null : json["width"],
        height: json["height"] == null ? null : json["height"],
      );

  Map<String, dynamic> toMap() => {
        "width": width == null ? null : width,
        "height": height == null ? null : height,
      };
}

class Permissions {
  Permissions({
    this.notifications,
    this.email,
  });

  final bool? notifications;
  final bool? email;

  factory Permissions.fromMap(Map<String, dynamic> json) => Permissions(
        notifications:
            json["notifications"] == null ? null : json["notifications"],
        email: json["email"] == null ? null : json["email"],
      );

  Map<String, dynamic> toMap() => {
        "notifications": notifications == null ? null : notifications,
        "email": email == null ? null : email,
      };
}

class Phone {
  Phone({
    this.id,
    this.value,
    this.type,
    this.areaCode,
    this.phoneDefault,
    this.updatedAt,
    this.createdAt,
  });

  final String? id;
  String? value;
  final String? type;
  final String? areaCode;
  bool? phoneDefault;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  factory Phone.fromMap(Map<String, dynamic> json) => Phone(
        id: json["_id"] == null ? null : json["_id"],
        value: json["value"] == null ? null : json["value"],
        type: json["type"] == null ? null : json["type"],
        areaCode: json["area_code"] == null ? null : json["area_code"],
        phoneDefault: json["default"] == null ? null : json["default"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "value": value == null ? null : value,
        "type": type == null ? null : type,
        "area_code": areaCode == null ? null : areaCode,
        "default": phoneDefault == null ? null : phoneDefault,
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
      };
}

class Referral {
  Referral({
    this.allowed,
    this.code,
    this.showReferralCode,
    this.allowUseOfCommission,
  });

  final bool? allowed;
  final String? code;
  final bool? showReferralCode;
  final bool? allowUseOfCommission;

  factory Referral.fromMap(Map<String, dynamic> json) => Referral(
        allowed: json["allowed"] == null ? null : json["allowed"],
        code: json["code"] == null ? null : json["code"],
        showReferralCode: json["show_referral_code"] == null
            ? null
            : json["show_referral_code"],
        allowUseOfCommission: json["allow_use_of_commission"] == null
            ? null
            : json["allow_use_of_commission"],
      );

  Map<String, dynamic> toMap() => {
        "allowed": allowed == null ? null : allowed,
        "code": code == null ? null : code,
        "show_referral_code":
            showReferralCode == null ? null : showReferralCode,
        "allow_use_of_commission":
            allowUseOfCommission == null ? null : allowUseOfCommission,
      };
}
