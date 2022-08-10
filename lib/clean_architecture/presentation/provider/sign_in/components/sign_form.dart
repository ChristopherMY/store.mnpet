import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/credentials_auth.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/response_auth.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/keyboard.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/sign_in/sign_in_bloc.dart';
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

      final response = await signInBloc.signIn();

      if (response is CredentialsAuth) {
        if (!mounted) return;
        KeyboardUtil.hideKeyboard(context);
        mainBloc.loadSession();
        mainBloc.loadUserInformation();
        mainBloc.refreshMainBloc();

        int count = 0;
        Navigator.of(context).popUntil((route) => count++ >= 2);
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

        final snackBar = SnackBar(
          content: Text(
            response.message,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: kPrimaryBackgroundColor,
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {},
          ),
        );

        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final signInBloc = context.watch<SignInBloc>();
    return IgnorePointer(
      ignoring: signInBloc.isLoad,
      child: Form(
        key: signInBloc.formKey,
        child: Column(
          children: [
            buildEmailFormField(context: context),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildPasswordFormField(context: context),
            SizedBox(height: getProportionateScreenHeight(30)),
            Row(
              children: [
                Spacer(),
                GestureDetector(
                  // onTap: () => Navigator.pushNamed(
                  //   context,
                  //   ForgotPasswordScreen.routeName,
                  // ),
                  child: const Text(
                    "Recuperar contraseña",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            ValueListenableBuilder(
              valueListenable: signInBloc.errors,
              builder: (context, List<String> value, child) {
                return FormError(errors: value);
              },
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            DefaultButton(
              text: "Continuar",
              press: validateSession,
            ),
          ],
        ),
      ),
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
      ),
    );
  }
}
