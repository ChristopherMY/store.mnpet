import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_forgot_password.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';

class ForgotPasswordBloc extends ChangeNotifier {
  AuthRepositoryInterface authRepositoryInterface;

  ForgotPasswordBloc({required this.authRepositoryInterface});

  TextEditingController emailPhoneController = TextEditingController();
  ValueNotifier<List<String>> errors = ValueNotifier([]);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String valueType = "";
  ResponseForgotPassword responseForgotPassword = ResponseForgotPassword();

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

  void onChangeEmailPhone(String value) {
    if (value.isNotEmpty) {
      removeError(error: kNumDocNullError);
    }

    valueType = emailValidatorRegExp.hasMatch(value) ? "email" : "document";

    if (value.isNotEmpty) {
      // && !errors.contains(kNumDocLengthNullError)
      removeError(error: kEmptyField);
    }

    // if (value.length == 8) {
    //     errors.remove(kNumDocLengthNullError);
    // }
  }

  String? onValidationEmailPhone(String? value) {
    if (value!.isEmpty) {
      addError(error: kEmptyField);
      return "";
    }

    // if (value.length < 8) {
    //   addError(error: kNumDocLengthNullError);
    // }

    return null;
  }

  Future<dynamic> validateNumberDoc({
    required String value,
    required String valueType,
  }) async {
    final response = await authRepositoryInterface.requestPasswordChange(
      value: value,
      valueType: valueType,
    );

    if (response is http.Response) {
      if (response.statusCode == 200) {
        final decode = json.decode(response.body);
        return ResponseForgotPassword.fromMap(decode);
      }
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }
    }

    return false;
  }


}
