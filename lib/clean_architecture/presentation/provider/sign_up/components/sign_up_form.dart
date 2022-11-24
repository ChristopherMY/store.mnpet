import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/credentials_auth.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/keyboard.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/sign_up/sing_up_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/custom_suffix_icon.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/default_button.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/form_error.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  Widget build(BuildContext context) {
    final signUpBloc = context.watch<SignUpBloc>();
    final mainBloc = context.watch<MainBloc>();

    return Form(
      key: signUpBloc.formKey,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: signUpBloc.nameController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onChanged: signUpBloc.onChangeName,
            validator: signUpBloc.onValidationName,
            style: Theme.of(context).textTheme.bodyText2,
            decoration: InputDecoration(
              labelText: "Nombre",
              hintText: "Ingresa tu nombre",
              labelStyle: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
              hintStyle: Theme.of(context).textTheme.bodyText2,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              errorStyle: const TextStyle(height: 0.0),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(25.0)),
          TextFormField(
            controller: signUpBloc.lastnameController,
            keyboardType: TextInputType.emailAddress,
            onChanged: signUpBloc.onChangeLastName,
            textInputAction: TextInputAction.next,
            validator: signUpBloc.onValidationLastName,
            style: Theme.of(context).textTheme.bodyText2,
            decoration: InputDecoration(
              labelText: "Apellidos",
              hintText: "Ingresa tus apellidos",
              labelStyle: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
              hintStyle: Theme.of(context).textTheme.bodyText2,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              errorStyle: const TextStyle(height: 0),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(25.0)),
          TextFormField(
            controller: signUpBloc.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: signUpBloc.onChangeEmail,
            validator: signUpBloc.onValidationEmail,
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
              errorStyle: const TextStyle(height: 0.0),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(25.0)),
          TextFormField(
            controller: signUpBloc.passwordController,
            obscureText: signUpBloc.obscureTextNewPassword,
            textInputAction: TextInputAction.next,
            onChanged: signUpBloc.onChangePassword,
            validator: signUpBloc.onValidationPassword,
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
                  signUpBloc.obscureTextNewPassword =
                      !signUpBloc.obscureTextNewPassword;
                  signUpBloc.refreshBloc();
                },
                child: CustomSuffixIcon(
                  svgIcon: signUpBloc.obscureTextNewPassword
                      ? "assets/icons/eye_off_thin.svg"
                      : "assets/icons/eye_thin.svg",
                ),
              ),
            ),
          ),
          // SizedBox(height: getProportionateScreenHeight(30)),
          // TextFormField(
          //   obscureText: true,
          //   // onSaved: (newValue) => confirmPassword = newValue,
          //   // onChanged: (value) {
          //   //   if (value.isNotEmpty) {
          //   //     removeError(error: kPassNullError);
          //   //   } else if (value.isNotEmpty && password == confirmPassword) {
          //   //     removeError(error: kMatchPassError);
          //   //   }
          //   //
          //   //   confirmPassword = value;
          //   // },
          //   // validator: (value) {
          //   //   if (value.isEmpty) {
          //   //     addError(error: kPassNullError);
          //   //     return "";
          //   //   } else if ((password != value)) {
          //   //     addError(error: kMatchPassError);
          //   //     return "";
          //   //   }
          //   //   return null;
          //   // },
          //   style: Theme.of(context).textTheme.bodyText2,
          //   decoration: InputDecoration(
          //     labelText: "Confirma tu contraseña",
          //     hintText: "Re-ingrese su contraseña",
          //     labelStyle: const TextStyle(
          //       fontSize: 18.0,
          //       fontWeight: FontWeight.w400,
          //     ),
          //     hintStyle: Theme.of(context).textTheme.bodyText2,
          //     floatingLabelBehavior: FloatingLabelBehavior.always,
          //     errorStyle: const TextStyle(height: 0),
          //   ),
          // ),
          SizedBox(height: getProportionateScreenHeight(25.0)),
          TextFormField(
            controller: signUpBloc.numDocController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onChanged: signUpBloc.onChangeNumberDoc,
            validator: signUpBloc.onValidationNumberDoc,
            style: Theme.of(context).textTheme.bodyText2,
            decoration: InputDecoration(
              labelText: "D.N.I",
              hintText: "Ingresa tu número de documento",
              labelStyle: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
              hintStyle: Theme.of(context).textTheme.bodyText2,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              errorStyle: const TextStyle(height: 0),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(25.0)),
          // TextFormField(
          //   keyboardType: TextInputType.number,
          //   // onSaved: (newValue) => phoneNumber = newValue,
          //   // onChanged: (value) {
          //   //   if (value.isNotEmpty) {
          //   //     removeError(error: kPhoneNumberNullError);
          //   //   }
          //   //
          //   //   phoneNumber = value;
          //   //   return null;
          //   // },
          //   // validator: (value) {
          //   //   if (value.isEmpty) {
          //   //     addError(error: kPhoneNumberNullError);
          //   //     return "";
          //   //   }
          //   //   return null;
          //   // },
          //   style: Theme.of(context).textTheme.bodyText2,
          //   decoration: InputDecoration(
          //     labelText: "Numero de teléfono",
          //     hintText: "Ingresa tu numero de teléfono",
          //     labelStyle: const TextStyle(
          //       fontSize: 18.0,
          //       fontWeight: FontWeight.w400,
          //     ),
          //     hintStyle: Theme.of(context).textTheme.bodyText2,
          //     floatingLabelBehavior: FloatingLabelBehavior.always,
          //     errorStyle: const TextStyle(height: 0),
          //   ),
          // ),
          // SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ValueListenableBuilder(
                valueListenable: signUpBloc.termsConditionsConfirmed,
                builder: (context, bool value, child) {
                  return Checkbox(
                    checkColor: Colors.white,
// tristate: false,
                    fillColor:
                        MaterialStateProperty.resolveWith(signUpBloc.getColor),
                    value: value,
                    onChanged: signUpBloc.onChangeTermsInfo,
                  );
                },
              ),
              Text(
                "Acepto los términos y condiciones",
                style: Theme.of(context).textTheme.bodyText2,
              )
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(25.0)),
          ValueListenableBuilder(
            valueListenable: signUpBloc.errors,
            builder: (context, List<String> value, child) {
              return FormError(errors: value);
            },
          ),
          SizedBox(height: getProportionateScreenHeight(25.0)),
          DefaultButton(
            text: "Continuar",
            press: () async {


            },
          ),
          const SizedBox(height: 20.0)
        ],
      ),
    );
  }
}
