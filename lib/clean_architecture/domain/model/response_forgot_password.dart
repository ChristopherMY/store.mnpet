// To parse this JSON data, do
//
//     final responseForgotPassword = responseForgotPasswordFromMap(jsonString);

import 'dart:convert';

ResponseForgotPassword responseForgotPasswordFromMap(String str) => ResponseForgotPassword.fromMap(json.decode(str));

String responseForgotPasswordToMap(ResponseForgotPassword data) => json.encode(data.toMap());

class ResponseForgotPassword {
  ResponseForgotPassword({
    this.status,
    this.email,
    this.type,
    this.userId,
    this.message,
  });

  final String? status;
  final String? email;
  final String? type;
  final String? userId;
  final String? message;

  factory ResponseForgotPassword.fromMap(Map<String, dynamic> json) => ResponseForgotPassword(
    status: json["status"] == null ? null : json["status"],
    email: json["email"] == null ? null : json["email"],
    type: json["type"] == null ? null : json["type"],
    userId: json["user_id"] == null ? null : json["user_id"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toMap() => {
    "status": status == null ? null : status,
    "email": email == null ? null : email,
    "type": type == null ? null : type,
    "user_id": userId == null ? null : userId,
    "message": message == null ? null : message,
  };
}
