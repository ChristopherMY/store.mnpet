// To parse this JSON data, do
//
//     final responseApi = responseApiFromMap(jsonString);

import 'dart:convert';

ResponseApi responseApiFromMap(String str) => ResponseApi.fromMap(json.decode(str));

String responseApiToMap(ResponseApi data) => json.encode(data.toMap());

class ResponseApi {
  ResponseApi({
    required this.status,
    required this.message,
  });

  final String status;
  final String message;

  factory ResponseApi.fromMap(Map<String, dynamic> json) => ResponseApi(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toMap() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}
