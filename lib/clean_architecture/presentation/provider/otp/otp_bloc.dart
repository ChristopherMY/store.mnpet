import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_forgot_password.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/recovery_password/recovery_password_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';

class OtpBloc extends ChangeNotifier {
  AuthRepositoryInterface authRepositoryInterface;

  OtpBloc({required this.authRepositoryInterface});

  ValueNotifier<bool> responseError = ValueNotifier(false);

  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  ValueNotifier<int> counter = ValueNotifier(60);
  late Timer timer;

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    timer.cancel();
    responseError.value = false;
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (counter.value == 0) {
          timer.cancel();
          return;
        }

        counter.value = counter.value - 1;
      },
    );
  }

  void validateOtp({
    required String pin,
    required String userId,
    required BuildContext context,
  }) async {
    context.loaderOverlay.show();

    final response = await authRepositoryInterface.validateOtp(
      otp: pin,
      userId: userId,
    );

    context.loaderOverlay.hide();

    if (response != null) {
      final responseForgotPassword =
          ResponseForgotPassword.fromMap(response.data);

      if (responseForgotPassword.status == 'success') {
        GlobalSnackBar.showInfoSnackBarIcon(
          context,
          responseForgotPassword.message!,
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) {
            return RecoveryPasswordScreen.init(context);
          }),
        );

        return;
      }

      GlobalSnackBar.showErrorSnackBarIcon(
        context,
        responseForgotPassword.message!,
      );

      context.loaderOverlay.hide();
      controller.clear();
      responseError.value = true;
    } else {
      String message = response.error!.message;

      print("message");
      print(message);

      // if (response.error!.statusCode == -1) {
      //   message = "Bad network";
      // }
      //
      // if (response.error!.statusCode == -403) {
      //   message = "Invalid";
      // }
      //
      // if (response.error!.statusCode == -404) {
      //   message = "Not found";
      // }

      GlobalSnackBar.showWarningSnackBar(
        context,
        "Tuvimos problemas, vuelva a intentarlo más tarde.",
      );
    }
  }
}
