// To parse this JSON data, do
//
//     final responseAuth = responseAuthFromMap(jsonString);

import 'dart:convert';

ResponseAuth responseAuthFromMap(String str) => ResponseAuth.fromMap(json.decode(str));

String responseAuthToMap(ResponseAuth data) => json.encode(data.toMap());

class ResponseAuth {
  ResponseAuth({
    required this.authenticated,
    required this.type,
    required this.message,
  });

  final bool authenticated;
  final String type;
  final String message;

  factory ResponseAuth.fromMap(Map<String, dynamic> json) => ResponseAuth(
    authenticated: json["authenticated"] == null ? null : json["authenticated"],
    type: json["type"] == null ? null : json["type"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toMap() => {
    "authenticated": authenticated == null ? null : authenticated,
    "type": type == null ? null : type,
    "message": message == null ? null : message,
  };

}
