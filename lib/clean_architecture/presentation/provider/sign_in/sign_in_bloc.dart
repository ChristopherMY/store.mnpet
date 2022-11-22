import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/credentials_auth.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_auth.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/keyboard.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';

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

  bool loginState = false;
  bool obscureTextNewPassword = true;

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
    }

    if (value.isNotEmpty) {
      removeError(error: kPassNullError);
    }
  }

  String? onValidationPassword(String? value) {
    if (value!.isEmpty) {
      addError(error: kPassNullError);
      return "";
    }

    if (value.length < 8) {
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

  void signIn(BuildContext context) async {
    final mainBloc = context.read<MainBloc>();

    if (formKey.currentState!.validate()) {
      KeyboardUtil.hideKeyboard(context);

      if (errors.value.isNotEmpty) return;

      formKey.currentState!.save();
      context.loaderOverlay.show();

      final responseAuth = await authRepositoryInterface.loginVerification(
        email: emailController.text,
        password: passwordController.text,
      );

      if (responseAuth.data == null) {
        context.loaderOverlay.hide();
        final statusCode = responseAuth.error!.statusCode;

        if (statusCode >= 400) {
          if (statusCode == 400 && statusCode == 404) {
            final responseAuthError = ResponseAuth.fromMap(responseAuth.error!.data);
            GlobalSnackBar.showWarningSnackBar(
              context,
              responseAuthError.message,
            );

            return;
          }
        }

        GlobalSnackBar.showWarningSnackBar(
          context,
          "Lo sentimos, por favor inténtelo más tarde",
        );

        return;
      }

      final credentials = CredentialsAuth.fromMap(responseAuth.data);

      await hiveRepositoryInterface.save(
        containerName: "authentication",
        key: "credentials",
        value: credentials.toMap(),
      );

      final hasSession = await mainBloc.loadSessionPromise();

      if (hasSession) {
        final responseUserInformation = await mainBloc.getUserInformation();

        if (responseUserInformation is! UserInformation) {
          GlobalSnackBar.showErrorSnackBarIcon(
            context,
            "Tuvimos problemas, vuelva a intentarlo",
          );

          return;
        }

        await mainBloc.changeShoppingCart();
        await mainBloc.handleGetShoppingCart();

        mainBloc.informationUser = responseUserInformation;
        mainBloc.sessionAccount.value = Session.active;
        mainBloc.account.value = Account.active;
        mainBloc.refreshMainBloc();

        context.loaderOverlay.hide();

        int count = 0;
        Navigator.of(context).popUntil((route) => count++ >= 2);
        return;
      }

      context.loaderOverlay.hide();
      GlobalSnackBar.showWarningSnackBar(
        context,
        "Tenemos un problema, por favor inténtelo más tarde.",
      );

    }
  }

  void refreshBloc() {
    notifyListeners();
  }
}
