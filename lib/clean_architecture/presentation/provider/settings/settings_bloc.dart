import 'package:flutter/cupertino.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';

class SettingsBloc extends ChangeNotifier {
  final UserRepositoryInterface userRepositoryInterface;

  SettingsBloc({required this.userRepositoryInterface});

  late TextEditingController nameController;
  late TextEditingController lastnameController;
  late TextEditingController documentNumberController;

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();

  ValueNotifier<List<String>> errors = ValueNotifier([]);

  bool obscureTextCurrentPassword = true;
  bool obscureTextNewPassword = true;
  bool obscureTextConfirmPassword = true;

  final formKey = GlobalKey<FormState>();
  final formPasswordKey = GlobalKey<FormState>();

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

  void onChangeNewPassword(String value) {
    if (value.length >= 8) {
      removeError(error: kShortPassError);
    } else if (value.isNotEmpty) {
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

    if (newPassword.isNotEmpty) {
      removeError(error: kPassNullError);
      return;
    }

    if (value.isNotEmpty) {
      removeError(error: kPassNullError);
      return;
    }

    if (newPassword == value) {
      removeError(error: kMatchPassError);
      return;
    }
  }

  String? onValidationConfirmPassword(String? value) {
    final newPassword = newPasswordController.text;
    if (newPassword.isNotEmpty) {
      addError(error: kPassNullError);
      return "";
    }

    if (value!.isNotEmpty) {
      addError(error: kPassNullError);
      return "";
    }

    if (newPassword == value) {
      addError(error: kMatchPassError);
      return "";
    }

    return null;
  }

  void onChangeCurrentPassword(String value) {
    if (value.length >= 8) {
      removeError(error: kShortPassError);
    } else if (value.isNotEmpty) {
      removeError(error: kPassNullError);
    }
  }

  String? onValidationCurrentPassword(String? value) {
    if (value!.isEmpty) {
      addError(error: kPassNullError);
      return "";
    } else if (value.length < 8) {
      addError(error: kShortPassError);
      return "";
    }

    return null;
  }

  void refreshSettingsBloc() {
    notifyListeners();
  }
}
