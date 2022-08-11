import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/credentials_auth.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/response_auth.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/keyboard.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/sign_in/sign_in_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/global_snackbar.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/custom_suffix_icon.dart';
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
          final responseUserInformation =
              await mainBloc.loadUserInformationPromise();

          if (responseUserInformation) {
            if (!mounted) return;
            mainBloc.refreshMainBloc();
            signInBloc.isLoading.value = false;
            int count = 0;
            Navigator.of(context).popUntil((route) => count++ >= 2);
          }

          return;
        }
      } else if (response is bool && response == false) {
        if (!mounted) return;
        final snackBar = SnackBar(
          content: const Text(
            "Tenemos un problema, por favor inténtelo más tarde.",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: kPrimaryBackgroundColor,
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {},
          ),
        );

        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (response is ResponseAuth) {
        if (!mounted) return;

        GlobalSnackBar.showWarningSnackBar(context, response.message);

        // final snackBar = SnackBar(
        //   padding: const EdgeInsets.only(
        //       top: 5.0, right: 5.0, bottom: 5.0, left: 10.0),
        //   content: Row(
        //     children: [
        //       const Icon(Icons.warning_amber_rounded),
        //       const SizedBox(width: 10.0),
        //       Expanded(
        //         child: Text(
        //           response.message,
        //           textAlign: TextAlign.justify,
        //           style: const TextStyle(color: Colors.black),
        //         ),
        //       ),
        //     ],
        //   ),
        //   backgroundColor: kPrimaryBackgroundColor,
        //   action: SnackBarAction(
        //     label: 'OK',
        //     onPressed: () {},
        //   ),
        // );
        //
        // ScaffoldMessenger.of(context).removeCurrentSnackBar();
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                      // onTap: () => Navigator.pushNamed(
                      //   context,
                      //   ForgotPasswordScreen.routeName,
                      // ),
                      child: Text(
                        "Recuperar contraseña",
                        style: TextStyle(decoration: TextDecoration.underline, fontSize: getProportionateScreenWidth(14)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(25)),
                ValueListenableBuilder(
                  valueListenable: signInBloc.errors,
                  builder: (context, List<String> value, child) {
                    return FormError(errors: value);
                  },
                ),
                SizedBox(height: getProportionateScreenHeight(25)),
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
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      decoration: const InputDecoration(
        labelText: "Contraseña",
        hintText: "Ingresa tu contraseña",
        labelStyle: TextStyle(fontSize: 19),
        hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Lock.svg"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        errorStyle: TextStyle(height: 0),
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
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      decoration: const InputDecoration(
        labelText: "Correo",
        hintText: "Ingresa tu correo",
        labelStyle: TextStyle(fontSize: 19),
        hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        errorStyle: TextStyle(height: 0),
      ),
    );
  }
}
