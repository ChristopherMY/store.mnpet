// To parse this JSON data, do
//
//     final order = orderFromMap(jsonString);

import 'dart:convert';

Payment paymentFromMap(String str) => Payment.fromMap(json.decode(str));

String paymentToMap(Payment data) => json.encode(data.toMap());

class Payment {
  Payment({
    this.token,
    this.issuerId,
    this.paymentMethodId,
    this.transactionAmount,
    this.installments,
    this.userId,
    this.addressId,
    this.subTotal,
    this.shippingCost,
    this.identification,
    this.companyName,
    this.additionalInfoMessage,
  });

  final String? token;
  final String? issuerId;
  final String? paymentMethodId;
  final double? transactionAmount;
  final int? installments;
  final String? userId;
  final String? addressId;
  final double? subTotal;
  final double? shippingCost;
  final Identification? identification;
  final String? companyName; // Optional
  final String? additionalInfoMessage; // Optional

  factory Payment.fromMap(Map<String, dynamic> json) => Payment(
    token: json["token"] == null ? null : json["token"],
    issuerId: json["issuerId"] == null ? null : json["issuerId"],
    paymentMethodId: json["paymentMethodId"] == null ? null : json["paymentMethodId"],
    transactionAmount: json["transactionAmount"] == null ? null : json["transactionAmount"].toDouble(),
    installments: json["installments"] == null ? null : json["installments"],
    userId: json["user_id"] == null ? null : json["user_id"],
    addressId: json["address_id"] == null ? null : json["address_id"],
    subTotal: json["sub_total"] == null ? null : json["sub_total"].toDouble(),
    shippingCost: json["shipping_cost"] == null ? null : json["shipping_cost"].toDouble(),
    identification: json["identification"] == null ? null : Identification.fromMap(json["identification"]),
    companyName: json["company_name"] == null ? null : json["company_name"],
    additionalInfoMessage: json["additional_info_message"] == null ? null : json["additional_info_message"],
  );

  Map<String, dynamic> toMap() => {
    "token": token == null ? null : token,
    "issuerId": issuerId == null ? null : issuerId,
    "paymentMethodId": paymentMethodId == null ? null : paymentMethodId,
    "transactionAmount": transactionAmount == null ? null : transactionAmount,
    "installments": installments == null ? null : installments,
    "user_id": userId == null ? null : userId,
    "address_id": addressId == null ? null : addressId,
    "sub_total": subTotal == null ? null : subTotal,
    "shipping_cost": shippingCost == null ? null : shippingCost,
    "identification": identification == null ? null : identification!.toMap(),
    "company_name": companyName == null ? null : companyName,
    "additional_info_message": additionalInfoMessage == null ? null : additionalInfoMessage,
  };
}

class Identification {
  Identification({
    this.type,
    this.number,
  });

  final String? type;
  final String? number;

  factory Identification.fromMap(Map<String, dynamic> json) => Identification(
    type: json["type"] == null ? null : json["type"],
    number: json["number"] == null ? null : json["number"],
  );

  Map<String, dynamic> toMap() => {
    "type": type == null ? null : type,
    "number": number == null ? null : number,
  };
}