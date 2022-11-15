import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/credentials_auth.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_auth.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/keyboard.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/forgot_password/forgot_password_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/sign_in/sign_in_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/custom_suffix_icon.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/default_button.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/form_error.dart';

class SignForm extends StatefulWidget {
  const SignForm({Key? key}) : super(key: key);

  @override
  State<SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  void validateSession() async {
    final signInBloc = context.read<SignInBloc>();
    final mainBloc = context.read<MainBloc>();

    if (signInBloc.formKey.currentState!.validate()) {
      context.loaderOverlay.show();

      signInBloc.formKey.currentState!.save();
      KeyboardUtil.hideKeyboard(context);

      final response = await signInBloc.signIn();
      if (!mounted) return;

      if (response is bool && response == false) {
        context.loaderOverlay.hide();
        GlobalSnackBar.showWarningSnackBar(
          context,
          "Lo sentimos, por favor inténtelo más tarde",
        );

        return;
      }

      if (response is ResponseAuth) {
        context.loaderOverlay.hide();
        GlobalSnackBar.showWarningSnackBar(context, response.message);
        return;
      }

      if (response is! CredentialsAuth) {
        context.loaderOverlay.hide();
        GlobalSnackBar.showWarningSnackBar(
          context,
          "Lo sentimos, por favor inténtelo más tarde",
        );
        return;
      }

      final responseSession = await mainBloc.loadSessionPromise();

      if (responseSession) {
        final responseUserInformation = await mainBloc.getUserInformation();
        if (!mounted) return;

        if (responseUserInformation is! UserInformation) {
          context.loaderOverlay.hide();

          GlobalSnackBar.showErrorSnackBarIcon(
            context,
            "Tuvimos problemas, vuelva a intentarlo",
          );

          return;
        }

        /// Procedemos a cambiar
        await mainBloc.changeShoppingCart();
        await mainBloc.handleGetShoppingCart();

        mainBloc.informationUser = responseUserInformation;
        mainBloc.sessionAccount.value = Session.active;
        mainBloc.account.value = Account.active;

        mainBloc.refreshMainBloc();
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

  @override
  Widget build(BuildContext context) {
    final signInBloc = context.watch<SignInBloc>();
    return Form(
      key: signInBloc.formKey,
      child: Column(
        children: [
          TextFormField(
            controller: signInBloc.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: signInBloc.onChangeEmail,
            validator: signInBloc.onValidationEmail,
            style: Theme.of(context).textTheme.bodyText2,
            decoration: InputDecoration(
              labelText: "Correo",
              hintText: "Ingresa tu correo",
              labelStyle: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
              hintStyle: Theme.of(context).textTheme.bodyText2,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              errorStyle: const TextStyle(height: 0),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          TextFormField(
            controller: signInBloc.passwordController,
            obscureText: signInBloc.obscureTextNewPassword,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onChanged: signInBloc.onChangePassword,
            validator: signInBloc.onValidationPassword,
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
                  signInBloc.obscureTextNewPassword =
                      !signInBloc.obscureTextNewPassword;
                  signInBloc.refreshBloc();
                },
                child: CustomSuffixIcon(
                  svgIcon: signInBloc.obscureTextNewPassword
                      ? "assets/icons/eye_off_thin.svg"
                      : "assets/icons/eye_thin.svg",
                ),
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(25)),
          Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen.init(context),
                    ),
                  );
                },
                child: Text(
                  "Recuperar contraseña",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(25.0)),
          ValueListenableBuilder(
            valueListenable: signInBloc.errors,
            builder: (context, List<String> value, child) {
              return FormError(errors: value);
            },
          ),
          SizedBox(height: getProportionateScreenHeight(25.0)),
          DefaultButton(
            text: "Continuar",
            press: validateSession,
          ),
        ],
      ),
    );
  }
}
