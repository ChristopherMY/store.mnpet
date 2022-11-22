import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_forgot_password.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/forgot_password/forgot_password_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';

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

  void changePassword({required BuildContext context}) async {
    if (formKey.currentState!.validate()) {
      if (errors.value.isNotEmpty) return;

      formKey.currentState!.save();
      context.loaderOverlay.show();

      final forgotPasswordBloc = context.read<ForgotPasswordBloc>();

      final response = await authRepositoryInterface.changePassword(
        userId: forgotPasswordBloc.responseForgotPassword.userId!,
        password: passwordController.text,
        passwordConfirmation: passwordConfirmController.text,
      );

      context.loaderOverlay.hide();

      if (response != null) {
        final responseForgotPass = ResponseForgotPassword.fromMap(response.data);
        if (responseForgotPass.status == 'success') {
          GlobalSnackBar.showInfoSnackBarIcon(
            context,
            responseForgotPass.message!,
          );

          context.loaderOverlay.hide();
          int count = 0;
          Navigator.of(context).popUntil((route) => count++ >= 3);
          return;
        }

        GlobalSnackBar.showErrorSnackBarIcon(
          context,
          responseForgotPass.message!,
        );

        return;
      }

      GlobalSnackBar.showErrorSnackBarIcon(
        context,
        "Tuvimos problemas, vuelva a intentarlo más tarde.",
      );
    }
  }
}
