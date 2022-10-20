import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/domain/model/credentials_auth.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';

class SignUpBloc extends ChangeNotifier {
  final AuthRepositoryInterface authRepositoryInterface;
  final HiveRepositoryInterface hiveRepositoryInterface;

  SignUpBloc({
    required this.authRepositoryInterface,
    required this.hiveRepositoryInterface,
  });

  ValueNotifier<List<String>> errors = ValueNotifier([]);

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController numDocController = TextEditingController();

  // TextEditingController phoneNumberController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ValueNotifier<bool> termsConditionsConfirmed = ValueNotifier(false);

  /*
    String name;
  String lastname;
  String email;
  String password;
  String confirmPassword;
  String numDoc;
  String phoneNumber;
  bool terms = false;
   */
  bool loginState = false;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };

    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }

    return kPrimaryColor;
  }

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

  void onChangeName(String value) {
    if (value.isNotEmpty) {
      removeError(error: kNamelNullError);
    }
  }

  String? onValidationName(String? value) {
    if (value!.isEmpty) {
      addError(error: kNamelNullError);
      return "";
    }

    return null;
  }

  void onChangeLastName(String value) {
    if (value.isNotEmpty) {
      removeError(error: kLastNameNullError);
    }
  }

  String? onValidationLastName(String? value) {
    if (value!.isEmpty) {
      addError(error: kLastNameNullError);
      return "";
    }

    return null;
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
    }

    if (emailValidatorRegExp.hasMatch(value)) {
      removeError(error: kInvalidEmailError);
    }
  }

  String? onValidationEmail(String? value) {
    if (value!.isEmpty) {
      addError(error: kEmailNullError);
      return "";
    }

    if (!emailValidatorRegExp.hasMatch(value)) {
      addError(error: kInvalidEmailError);
      return "";
    }

    return null;
  }

  void onChangeNumberDoc(String value) {
    if (value.isNotEmpty) {
      removeError(error: kNumDocNullError);
    }
  }

  String? onValidationNumberDoc(String? value) {
    if (value!.isEmpty) {
      addError(error: kNumDocNullError);
      return "";
    }

    return null;
  }

  bool? onChangeTermsInfo(bool? value) {
    if (value!) {
      removeError(error: kTermsNullError);
    } else {
      addError(error: kTermsNullError);
    }

    termsConditionsConfirmed.value = value;
    return value;
  }

  Future<dynamic> registerUser({required Map<String, dynamic> user}) async {
    final response = await authRepositoryInterface.createUser(user: user);

    if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      return false;
    }

    if (response is! http.Response) {
      return false;
    }

    final decode = json.decode(response.body);

    if (response.statusCode == 200) {
      final credentials = CredentialsAuth.fromMap(decode);

      print("credentials.toMap()");
      print(credentials.toMap());

      await hiveRepositoryInterface.save(
        containerName: "authentication",
        key: "credentials",
        value: credentials.toMap(),
      );

      return credentials;
    } else if (response.statusCode == 402) {
      return ResponseApi.fromMap(decode);
    } else if (response.statusCode == 404) {
      return ResponseApi.fromMap(decode);
    }

    return false;
  }
}
