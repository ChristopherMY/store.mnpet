import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/change_password/change_password_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/custom_suffix_icon.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/default_button.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/form_error.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider<ChangePasswordBloc>(
      create: (context) => ChangePasswordBloc(
        userRepositoryInterface: context.read<UserRepositoryInterface>(),
      ),
      builder: (_, __) => const ChangePasswordScreen._(),
    );
  }

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  void handleSavePasswordAccount() async {
    final changePasswordBloc = context.read<ChangePasswordBloc>();

    if (changePasswordBloc.formKey.currentState!.validate()) {
      final changePasswordBloc = context.read<ChangePasswordBloc>();
      final mainBloc = context.read<MainBloc>();

      if (changePasswordBloc.formKey.currentState!.validate()) {
        changePasswordBloc.formKey.currentState!.save();
        context.loaderOverlay.show();

        final response = await changePasswordBloc.userRepositoryInterface.changeUserPassword(
          headers: mainBloc.headers,
          bindings: {
            "password": changePasswordBloc.newPasswordController.text,
            "password_confirmation": changePasswordBloc.confirmPasswordController.text,
            "current_password": changePasswordBloc.currentPasswordController.text,
          },
        );

        context.loaderOverlay.hide();

        if (response is Text) {
          if (kDebugMode) {
            print(response.toString());
          }

          return;
        }

        if (response is! http.Response) {
          return;
        }

        if (response.statusCode == 200 || response.statusCode == 400) {
          final decode = ResponseApi.fromMap(jsonDecode(response.body));

          if (decode.status == "error") {
            GlobalSnackBar.showWarningSnackBar(context, decode.message);
            return;
          }

          GlobalSnackBar.showInfoSnackBarIcon(context, decode.message);
          return;
        }

        GlobalSnackBar.showWarningSnackBar(
          context,
          "Ups tuvimos problemas, vuelva a intentarlo más tarde",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final changePasswordBloc = context.watch<ChangePasswordBloc>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackGroundColor,
        appBar: AppBar(
          backgroundColor: kBackGroundColor,
          leading: const BackButton(
            color: Colors.black,
          ),
          elevation: 0,
          title: const Text(
            "Cambiar contraseña",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: kBackGroundColor,
            statusBarIconBrightness: Brightness.dark,
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Form(
                  key: changePasswordBloc.formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: changePasswordBloc.newPasswordController,
                        obscureText: changePasswordBloc.obscureTextNewPassword,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: changePasswordBloc.onChangeNewPassword,
                        validator: changePasswordBloc.onValidationNewPassword,
                        textInputAction: TextInputAction.next,
                        style: Theme.of(context).textTheme.bodyText2,
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          hintText: "Ingresa tu contraseña",
                          labelStyle: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                          hintStyle: Theme.of(context).textTheme.bodyText2,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          errorStyle: const TextStyle(height: 0),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              changePasswordBloc.obscureTextNewPassword =
                                  !changePasswordBloc.obscureTextNewPassword;
                              changePasswordBloc.refreshBloc();
                            },
                            child: CustomSuffixIcon(
                              svgIcon: changePasswordBloc.obscureTextNewPassword
                                  ? "assets/icons/eye_off_thin.svg"
                                  : "assets/icons/eye_thin.svg",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(15.0)),
                      TextFormField(
                        controller:
                            changePasswordBloc.confirmPasswordController,
                        obscureText:
                            changePasswordBloc.obscureTextConfirmPassword,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: changePasswordBloc.onChangeConfirmPassword,
                        validator:
                            changePasswordBloc.onValidationConfirmPassword,
                        textInputAction: TextInputAction.next,
                        style: Theme.of(context).textTheme.bodyText2,
                        decoration: InputDecoration(
                          labelText: "Confirmar contraseña",
                          hintText: "Ingresa tu contraseña",
                          labelStyle: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                          hintStyle: Theme.of(context).textTheme.bodyText2,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          errorStyle: const TextStyle(height: 0),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              changePasswordBloc.obscureTextConfirmPassword =
                                  !changePasswordBloc
                                      .obscureTextConfirmPassword;
                              changePasswordBloc.refreshBloc();
                            },
                            child: CustomSuffixIcon(
                              svgIcon:
                                  changePasswordBloc.obscureTextConfirmPassword
                                      ? "assets/icons/eye_off_thin.svg"
                                      : "assets/icons/eye_thin.svg",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(15.0)),
                      TextFormField(
                        controller:
                            changePasswordBloc.currentPasswordController,
                        obscureText:
                            changePasswordBloc.obscureTextCurrentPassword,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: changePasswordBloc.onChangeCurrentPassword,
                        validator:
                            changePasswordBloc.onValidationCurrentPassword,
                        textInputAction: TextInputAction.done,
                        style: Theme.of(context).textTheme.bodyText2,
                        decoration: InputDecoration(
                          labelText: "Contraseña Actual",
                          hintText: "Ingresa tu contraseña",
                          labelStyle: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                          hintStyle: Theme.of(context).textTheme.bodyText2,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          errorStyle: const TextStyle(height: 0),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              changePasswordBloc.obscureTextCurrentPassword =
                                  !changePasswordBloc
                                      .obscureTextCurrentPassword;
                              changePasswordBloc.refreshBloc();
                            },
                            child: CustomSuffixIcon(
                              svgIcon:
                                  changePasswordBloc.obscureTextCurrentPassword
                                      ? "assets/icons/eye_off_thin.svg"
                                      : "assets/icons/eye_thin.svg",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(35.0)),
                ValueListenableBuilder(
                  valueListenable: changePasswordBloc.errors,
                  builder: (context, List<String> value, child) {
                    return Column(
                      children: [
                        FormError(errors: value),
                        SizedBox(height: getProportionateScreenHeight(35.0)),
                      ],
                    );
                  },
                ),
                DefaultButton(
                  text: "Guardar",
                  press: handleSavePasswordAccount,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
