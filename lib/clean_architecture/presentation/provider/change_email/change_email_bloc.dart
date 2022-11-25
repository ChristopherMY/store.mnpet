
import 'package:flutter/material.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';

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
    final emailValue = confirmEmailController.text;
    if (emailValue == value) {
      removeError(error: kMatchEmailError);
    }

    if (value.isNotEmpty) {
      removeError(error: kEmailNullError);
    }

    if (emailValidatorRegExp.hasMatch(value)) {
      removeError(error: kInvalidEmailError);
    }
  }

  String? onValidationEmail(String? value) {
    final emailValue = confirmEmailController.text;
    if (emailValue != value!) {
      addError(error: kMatchEmailError);
      return "";
    }

    if (!emailValidatorRegExp.hasMatch(value)) {
      addError(error: kInvalidEmailError);
      return "";
    }

    if (value.isEmpty) {
      addError(error: kEmailNullError);
      return "";
    }

    return null;
  }

  void onChangeConfirmEmail(String value) {
    final emailValue = emailController.text;

    if (emailValue == value) {
      removeError(error: kMatchEmailError);
    }

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
    if (value.isNotEmpty) {
      removeError(error: kPassNullError);
    }
  }

  String? onValidationCurrentPassword(String? value) {
    if (value!.isEmpty) {
      addError(error: kPassNullError);
      return "";
    }

    return null;
  }

  void handleUpdateEmail({
    required Map<String, String> headers,
    required BuildContext context,
  }) async {

  }
}
