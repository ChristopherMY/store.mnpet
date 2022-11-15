import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_forgot_password.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/keyboard.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/forgot_password/forgot_password_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/otp/opt_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/default_button.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/form_error.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/no_account_text.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ForgotPasswordBloc(
        authRepositoryInterface: context.read<AuthRepositoryInterface>(),
      ),
      builder: (_, __) => const ForgotPasswordScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: kBackGroundColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          bottomOpacity: 0.0,
          elevation: 0.0,
          backgroundColor: kBackGroundColor,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: kBackGroundColor,
            statusBarIconBrightness: Brightness.dark,
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: CircleAvatar(
                backgroundColor: Colors.black12,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 20.0,
                ),
              ),
            ),
          ),
          leadingWidth: 50.0,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(15.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.screenHeight! * 0.01),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Recuperar contraseña",
                      style: headingStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.05),
                  Text(
                    "* Complete los datos",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.01),
                  const ForgotPassForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatelessWidget {
  const ForgotPassForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forgotPasswordBloc = context.watch<ForgotPasswordBloc>();

    return Form(
      key: forgotPasswordBloc.formKey,
      child: Column(
        children: [
          TextFormField(
            controller: forgotPasswordBloc.emailPhoneController,
            keyboardType: TextInputType.text,
            onChanged: forgotPasswordBloc.onChangeEmailPhone,
            validator: forgotPasswordBloc.onValidationEmailPhone,
            style: Theme.of(context).textTheme.bodyText2,
            decoration: InputDecoration(
              labelText: "Correo electrónico o número de documento",
              hintText: "Ingresen correo o número de documento",
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
          ValueListenableBuilder(
            valueListenable: forgotPasswordBloc.errors,
            builder: (context, List<String> value, child) {
              return FormError(errors: value);
            },
          ),
          //SizedBox(height: getProportionateScreenHeight(25.0)),
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (forgotPasswordBloc.formKey.currentState!.validate()) {
                forgotPasswordBloc.formKey.currentState!.save();
                if (forgotPasswordBloc.errors.value.isEmpty) {
                  KeyboardUtil.hideKeyboard(context);
                  context.loaderOverlay.show();

                  final response = await forgotPasswordBloc.validateNumberDoc(
                    value: forgotPasswordBloc.emailPhoneController.text,
                    valueType: forgotPasswordBloc.valueType,
                  );

                  if (response is ResponseForgotPassword) {
                    forgotPasswordBloc.responseForgotPassword = response;
                    if (response.status == 'success') {
                      GlobalSnackBar.showInfoSnackBarIcon(
                        context,
                        response.message!,
                      );

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => OptScreen.init(context),
                        ),
                      );
                    } else {
                      GlobalSnackBar.showErrorSnackBarIcon(
                        context,
                        response.message!,
                      );
                    }
                  } else if (response is bool) {
                    GlobalSnackBar.showErrorSnackBarIcon(
                      context,
                      "Tuvimos problemas, vuelva a intentarlo más tarde",
                    );
                  }

                  context.loaderOverlay.hide();
                }
                // validationNumberDoc(
                //   context: context,
                //   value: valueField,
                //   valueType: valueType,
                // );

              }
            },
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          const NoAccountText(),
        ],
      ),
    );
  }
}
