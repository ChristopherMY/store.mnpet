import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_mundo_negocio/clean_architecture/domain/model/credentials_auth.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_auth.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/hive_repository.dart';

import '../../../helper/constants.dart';

class SignInBloc extends ChangeNotifier {
  final AuthRepositoryInterface authRepositoryInterface;
  final HiveRepositoryInterface hiveRepositoryInterface;

  SignInBloc({
    required this.authRepositoryInterface,
    required this.hiveRepositoryInterface,
  });

  ValueNotifier<List<String>> errors = ValueNotifier([]);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool loginState = false;
  bool obscureTextNewPassword = true;

  void addError({required String error}) {
    List<String> values = List.from(errors.value);
    if (!values.contains(error)) {
      values.add(error);
      errors.value = values;
    }
  }

  void removeError({required String error}) {
    List<String> values = List.from(errors.value);
    if (values.contains(error)) {
      values.remove(error);
      errors.value = values;
    }
  }

  void onChangePassword(String value) {
    if (value.length >= 8) {
      removeError(error: kShortPassError);
    } else if (value.isNotEmpty) {
      removeError(error: kPassNullError);
    }
  }

  String? onValidationPassword(String? value) {
    if (value!.isEmpty) {
      addError(error: kPassNullError);
      return "";
    } else if (value.length < 8) {
      addError(error: kShortPassError);
      return "";
    }

    return null;
  }

  void onChangeEmail(String value) {
    if (value.isNotEmpty) {
      removeError(error: kEmailNullError);
    } else if (emailValidatorRegExp.hasMatch(value)) {
      removeError(error: kInvalidEmailError);
    }
  }

  String? onValidationEmail(String? value) {
    if (value!.isEmpty) {
      addError(error: kEmailNullError);
      return "";
    } else if (!emailValidatorRegExp.hasMatch(value)) {
      addError(error: kInvalidEmailError);
      return "";
    }

    return null;
  }

  Future<dynamic> signIn() async {
    final responseAuth = await authRepositoryInterface.loginVerification(
      email: emailController.text,
      password: passwordController.text,
    );

    if (responseAuth is String) {
      if (kDebugMode) {
        print(responseAuth);
      }

      return false;
    }

    if (responseAuth is! http.Response) {
      return false;
    }

    if (responseAuth.statusCode != 200) {
      final response = json.decode(responseAuth.body);
      return ResponseAuth.fromMap(response);
    }

    final response = json.decode(responseAuth.body);
    final credentials = CredentialsAuth.fromMap(response);

    await hiveRepositoryInterface.save(
      containerName: "authentication",
      key: "credentials",
      value: credentials.toMap(),
    );

    return credentials;
  }

  void refreshBloc(){
    notifyListeners();
  }
}
