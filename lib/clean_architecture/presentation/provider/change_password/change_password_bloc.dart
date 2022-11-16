import 'package:flutter/material.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';

class ChangePasswordBloc extends ChangeNotifier {
  final UserRepositoryInterface userRepositoryInterface;

  ChangePasswordBloc({required this.userRepositoryInterface});


  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();

  ValueNotifier<List<String>> errors = ValueNotifier([]);

  bool obscureTextCurrentPassword = true;
  bool obscureTextNewPassword = true;
  bool obscureTextConfirmPassword = true;

  final formKey = GlobalKey<FormState>();

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

  void onChangeNewPassword(String value) {
    if (value.length >= 8) {
      removeError(error: kShortPassError);
    }

    if (value.isNotEmpty) {
      removeError(error: kPassNullError);
    }
  }

  String? onValidationNewPassword(String? value) {
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
    final newPassword = newPasswordController.text;

    if (newPassword == value) {
      removeError(error: kMatchPassError);
      return;
    }

    if (newPassword.isNotEmpty) {
      removeError(error: kPassNullError);
      return;
    }

    if (value.isNotEmpty) {
      removeError(error: kPassNullError);
      return;
    }

  }

  String? onValidationConfirmPassword(String? value) {
    final newPassword = newPasswordController.text;

    if (newPassword.isEmpty) {
      addError(error: kPassNullError);
      return "";
    }

    if (value!.isEmpty) {
      addError(error: kPassNullError);
      return "";
    }

    if (newPassword != value) {
      addError(error: kMatchPassError);
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

  void refreshBloc() {
    notifyListeners();
  }
}
