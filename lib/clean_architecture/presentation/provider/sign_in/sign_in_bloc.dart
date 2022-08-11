import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/domain/model/response_auth.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/credentials_auth.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/hive_repository.dart';

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

  ValueNotifier<bool> isLoading = ValueNotifier(false);
  bool loginState = false;

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
      removeError(error: kPassNullError);
    } else if (value.isNotEmpty) {
      removeError(error: kShortPassError);
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

    if (responseAuth is http.Response) {
      final response = json.decode(responseAuth.body);

      if (responseAuth.statusCode == 200) {
        final credentials = CredentialsAuth.fromMap(response);

        await hiveRepositoryInterface.save(
          containerName: "authentication",
          key: "credentials",
          value: credentials.toMap(),
        );
        return credentials;
      } else {
        return ResponseAuth.fromMap(response);
      }
    } else if (responseAuth is String) {
      if (kDebugMode) {
        print(responseAuth);
      }
    }

    return false;
    //   if (responseAuth.statusCode == 200) {
    //     KeyboardUtil.hideKeyboard(context);
    //
    //     final responseApi = User.fromMap(decodeResponse);
    //     _hiveStorage.save(
    //       "credentials",
    //       "user",
    //       responseApi.toMap(),
    //     );
    //
    //     Timer(
    //       Duration(milliseconds: 500),
    //       () {
    //         // _sharedPref
    //         _hiveStorage.save(
    //           "mail",
    //           "mail_confirmed",
    //           responseApi.emailConfirmed,
    //         );
    //
    //         if (widget.position != null)
    //           Navigator.pushNamedAndRemoveUntil(
    //             context,
    //             Home.routeName,
    //             (route) => false,
    //             arguments: widget.position,
    //           );
    //         else {
    //           Navigator.pop(context);
    //           Navigator.pop(widget.context);
    //         }
    //       },
    //     );
    //   } else if (responseAuth.statusCode == 400 ||
    //       responseAuth.statusCode == 404) {
    //     ResponseAuthLogin responseAuthLogin =
    //         ResponseAuthLogin.fromMap(decodeResponse);
    //
    //     FocusScope.of(context).requestFocus(FocusNode());
    //
    //     final snackBar = SnackBar(
    //       content: Text(
    //         responseAuthLogin.message,
    //         style: TextStyle(color: Colors.black),
    //       ),
    //       backgroundColor: kPrimaryBackgroundColor,
    //       action: SnackBarAction(
    //         label: 'Ok',
    //         onPressed: () {},
    //       ),
    //     );
    //     ScaffoldMessenger.of(context).removeCurrentSnackBar();
    //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //
    //     // customToast.showToastIcon(
    //     //   context: context,
    //     //   type: "error",
    //     //   message: responseAuthLogin.message,
    //     // );
    //   }
  }
}
