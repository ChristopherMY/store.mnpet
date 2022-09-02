import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/credentials_auth.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/response_auth.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_pet/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_pet/clean_architecture/helper/keyboard.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/forgot_password/forgot_password_screen.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/sign_in/sign_in_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/global_snackbar.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/default_button.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/form_error.dart';

class SignForm extends StatefulWidget {
  const SignForm({Key? key}) : super(key: key);

  @override
  State<SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  void validateSession() async {
    final signInBloc = Provider.of<SignInBloc>(context, listen: false);
    final mainBloc = Provider.of<MainBloc>(context, listen: false);

    if (signInBloc.formKey.currentState!.validate()) {
      signInBloc.formKey.currentState!.save();
      signInBloc.isLoading.value = true;
      KeyboardUtil.hideKeyboard(context);

      final response = await signInBloc.signIn();

      if (response is CredentialsAuth) {
        final responseSession = await mainBloc.loadSessionPromise();
        if (responseSession) {
          final responseUserInformation = await mainBloc.getUserInformation();

          if (responseUserInformation is UserInformation) {
            mainBloc.informationUser = responseUserInformation;
            if (!mounted) return;
            signInBloc.isLoading.value = false;

            final response = await mainBloc.changeShoppingCart();
            if (response is ResponseApi) {
              if (response.status == "success") {
                mainBloc.handleDeleteShoppingCartTemp();
              }
            }

            mainBloc.sessionAccount.value = Session.active;
            mainBloc.refreshMainBloc();
            int count = 0;

            Navigator.of(context).popUntil((route) => count++ >= 2);
            return;
          }

          GlobalSnackBar.showWarningSnackBar(
            context,
            "Tenemos un problema, por favor inténtelo más tarde.",
          );
        }
      } else if (response is bool && response == false) {
        GlobalSnackBar.showWarningSnackBar(
          context,
          "Tenemos un problema, por favor inténtelo más tarde.",
        );
      } else if (response is ResponseAuth) {
        GlobalSnackBar.showWarningSnackBar(context, response.message);
      }
    }

    signInBloc.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final signInBloc = context.watch<SignInBloc>();
    return ValueListenableBuilder(
      valueListenable: signInBloc.isLoading,
      builder: (context, bool value, child) {
        return IgnorePointer(
          ignoring: value,
          child: Form(
            key: signInBloc.formKey,
            child: Column(
              children: [
                buildEmailFormField(context: context),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildPasswordFormField(context: context),
                SizedBox(height: getProportionateScreenHeight(25)),
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ForgotPasswordScreen.init(context),
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
          ),
        );
      },
    );
  }

  TextFormField buildPasswordFormField({required BuildContext context}) {
    final signInBloc = Provider.of<SignInBloc>(context);

    return TextFormField(
      controller: signInBloc.passwordController,
      obscureText: true,
      keyboardType: TextInputType.text,
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
      ),
    );
  }

  TextFormField buildEmailFormField({required BuildContext context}) {
    final signInBloc = Provider.of<SignInBloc>(context);
    return TextFormField(
      controller: signInBloc.emailController,
      keyboardType: TextInputType.emailAddress,
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
    );
  }
}
