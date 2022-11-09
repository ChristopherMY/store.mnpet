import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';

class ChangeEmailBloc extends ChangeNotifier {
  final UserRepositoryInterface userRepositoryInterface;

  ChangeEmailBloc({required this.userRepositoryInterface});

  TextEditingController emailController = TextEditingController();
  TextEditingController confirmEmailController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();

  ValueNotifier<List<String>> errors = ValueNotifier([]);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    }

    if (!emailValidatorRegExp.hasMatch(value)) {
      addError(error: kInvalidEmailError);
      return "";
    }

    return null;
  }

  void onChangeConfirmEmail(String value) {
    if (value.isNotEmpty) {
      removeError(error: kEmailNullError);
    }

    if (emailValidatorRegExp.hasMatch(value)) {
      removeError(error: kInvalidEmailError);
    }
  }

  String? onValidationConfirmEmail(String? value) {
    final emailValue = emailController.text;

    if (emailValue != value!) {
      addError(error: kMatchEmailError);
      return "";
    }

    if (value.isEmpty) {
      addError(error: kEmailNullError);
      return "";
    }

    if (!emailValidatorRegExp.hasMatch(value)) {
      addError(error: kInvalidEmailError);
      return "";
    }

    return null;
  }

  void onChangeCurrentPassword(String value) {
    if (value.length >= 8) {
      removeError(error: kShortPassError);
    }
  }

  String? onValidationCurrentPassword(String? value) {
    if (value!.isEmpty) {
      addError(error: kPassNullError);
      return "";
    }

    return null;
  }
}
