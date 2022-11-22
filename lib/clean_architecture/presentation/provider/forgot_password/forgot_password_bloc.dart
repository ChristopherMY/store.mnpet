import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_forgot_password.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/keyboard.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/otp/opt_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/otp/otp_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';

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

  void revalidateNumberDoc({required BuildContext context}) async {
    KeyboardUtil.hideKeyboard(context);
    context.loaderOverlay.show();

    final otpBloc = context.read<OtpBloc>();

    final response = await authRepositoryInterface.requestPasswordChange(
      value: emailPhoneController.text,
      valueType: valueType,
    );

    context.loaderOverlay.hide();
    if (response != null) {
      responseForgotPassword = ResponseForgotPassword.fromMap(response.data);

      if (responseForgotPassword.status == "success") {
        GlobalSnackBar.showInfoSnackBarIcon(
          context,
          responseForgotPassword.message!,
        );

        otpBloc.responseError.value = false;
        otpBloc.counter.value = 60;
        otpBloc.startTimer();

        return;
      }
    }

    GlobalSnackBar.showErrorSnackBarIcon(
      context,
      responseForgotPassword.message!,
    );
    //
    // if (response is bool) {
    //   GlobalSnackBar.showErrorSnackBarIcon(
    //     context,
    //     "Tuvimos problemas, vuelva a intentarlo más tarde",
    //   );
    // }
  }

  void validateNumberDoc({
    required BuildContext context,
  }) async {
    if (formKey.currentState!.validate()) {
      if (errors.value.isEmpty) {
        formKey.currentState!.save();
        KeyboardUtil.hideKeyboard(context);

        context.loaderOverlay.show();

        final response = await authRepositoryInterface.requestPasswordChange(
          value: emailPhoneController.text,
          valueType: valueType,
        );

        context.loaderOverlay.hide();
        if (response != null) {
          responseForgotPassword =
              ResponseForgotPassword.fromMap(response.data);

          if (responseForgotPassword.status == 'success') {
            GlobalSnackBar.showInfoSnackBarIcon(
              context,
              responseForgotPassword.message!,
            );

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OptScreen.init(context),
              ),
            );

            return;
          }

          GlobalSnackBar.showErrorSnackBarIcon(
            context,
            responseForgotPassword.message!,
          );
        } else {
          String message = response.error!.message;
          print("message!!!!!!!!!");
          print(message);

          GlobalSnackBar.showWarningSnackBar(
            context,
            "Ups tenemos un problema, vuelva a intentarlo más tarde.",
          );
        }
      }
    }
  }
}
