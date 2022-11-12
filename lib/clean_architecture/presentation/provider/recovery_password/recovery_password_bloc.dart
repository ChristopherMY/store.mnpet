import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_forgot_password.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:http/http.dart' as http;

class RecoveryPasswordBloc extends ChangeNotifier {
  final AuthRepositoryInterface authRepositoryInterface;

  RecoveryPasswordBloc({required this.authRepositoryInterface});

  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ValueNotifier<List<String>> errors = ValueNotifier([]);

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

  void onChangeConfirmPassword(String value) {
    if (value.length >= 8) {
      removeError(error: kShortPassError);
    } else if (value.isNotEmpty) {
      removeError(error: kPassNullError);
    }
  }

  String? onValidationConfirmPassword(String? value) {
    if (value!.isEmpty) {
      addError(error: kPassNullError);
      return "";
    } else if (value.length < 8) {
      addError(error: kShortPassError);
      return "";
    }

    return null;
  }

  Future<dynamic> changePassword({
    required String userId,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await authRepositoryInterface.changePassword(
      userId: userId,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    if(response is http.Response){
      if(response.statusCode == 200){
        final decode = json.decode(response.body);
        return ResponseForgotPassword.fromMap(decode);
      }
    } else if(response is String){
      if (kDebugMode) {
        print(response);
      }
    }

    return false;
  }
}
