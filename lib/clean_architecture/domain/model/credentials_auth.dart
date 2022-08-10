// To parse this JSON data, do
//
//     final responseCredentialsAuth = responseCredentialsAuthFromMap(jsonString);

import 'dart:convert';

CredentialsAuth credentialsAuthFromMap(String str) => CredentialsAuth.fromMap(json.decode(str));

String credentialsAuthToMap(CredentialsAuth data) => json.encode(data.toMap());

class CredentialsAuth {
  CredentialsAuth({
    required this.email,
    required this.emailConfirmed,
    required this.token,
  });

  final String email;
  final bool emailConfirmed;
  final String token;

  factory CredentialsAuth.fromMap(Map<String, dynamic> json) => CredentialsAuth(
    email: json["email"] == null ? "" : json["email"],
    emailConfirmed: json["email_confirmed"] == null ? "" : json["email_confirmed"],
    token: json["token"] == null ? "" : json["token"],
  );

  Map<String, dynamic> toMap() => {
    "email": email == null ? null : email,
    "email_confirmed": emailConfirmed == null ? null : emailConfirmed,
    "token": token == null ? null : token,
  };
}
