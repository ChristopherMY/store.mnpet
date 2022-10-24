import 'package:flutter/cupertino.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';

class SettingsBloc extends ChangeNotifier {
  final UserRepositoryInterface userRepositoryInterface;

  SettingsBloc({required this.userRepositoryInterface});

  late TextEditingController nameController;

  late TextEditingController lastnameController;

  late TextEditingController documentNumberController;

  ValueNotifier<List<String>> errors = ValueNotifier([]);

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
}
