import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/response_forgot_password.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/forgot_password/forgot_password_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/recovery_password/recovery_password_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/global_snackbar.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/default_button.dart';

import '../../../helper/size_config.dart';
import '../../widget/form_error.dart';

class RecoveryPasswordScreen extends StatelessWidget {
  const RecoveryPasswordScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider<ForgotPasswordBloc>.value(
      value: Provider.of<ForgotPasswordBloc>(context, listen: false),
      child: ChangeNotifierProvider(
        create: (context) => RecoveryPasswordBloc(
          authRepositoryInterface: context.read<AuthRepositoryInterface>(),
        ),
        child: const RecoveryPasswordScreen._(),
      ),
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
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(15),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: SizeConfig.screenHeight! * 0.01),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Restablecer contraseña",
                        style: headingStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.01),
                    const Text(
                      "Recuerde registrar una contraseña segura. Podrá restablecerla cuantas veces sea necesario",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.05),
                    Text(
                      "* Complete los datos",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.01),
                    const RecoveryPasswordForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RecoveryPasswordForm extends StatelessWidget {
  const RecoveryPasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recoveryPasswordBloc = context.read<RecoveryPasswordBloc>();
    final forgotPasswordBloc = context.read<ForgotPasswordBloc>();
    return Form(
      key: recoveryPasswordBloc.formKey,
      child: Column(
        children: [
          TextFormField(
            obscureText: true,
            controller: recoveryPasswordBloc.passwordController,
            onChanged: recoveryPasswordBloc.onChangePassword,
            validator: recoveryPasswordBloc.onValidationPassword,
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
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          TextFormField(
            obscureText: true,
            controller: recoveryPasswordBloc.passwordConfirmController,
            onChanged: recoveryPasswordBloc.onChangeConfirmPassword,
            validator: recoveryPasswordBloc.onValidationConfirmPassword,
            style: Theme.of(context).textTheme.bodyText2,
            decoration: InputDecoration(
              labelText: "Confirma tu contraseña",
              hintText: "Vuelva a escribir la contraseña",
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
          ValueListenableBuilder(
            valueListenable: recoveryPasswordBloc.errors,
            builder: (context, List<String> value, child) {
              return FormError(errors: value);
            },
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          DefaultButton(
            text: "Restablecer",
            press: () async {
              if (recoveryPasswordBloc.formKey.currentState!.validate()) {
                context.loaderOverlay.show();
                recoveryPasswordBloc.formKey.currentState!.save();

                final response = await recoveryPasswordBloc.changePassword(
                  userId: forgotPasswordBloc.responseForgotPassword.userId!,
                  password: recoveryPasswordBloc.passwordController.text,
                  passwordConfirmation: recoveryPasswordBloc.passwordConfirmController.text,
                );

                if (response is ResponseForgotPassword) {
                  if (response.status == 'success') {
                    GlobalSnackBar.showInfoSnackBarIcon(
                      context,
                      response.message!,
                    );

                    context.loaderOverlay.hide();
                    int count = 0;
                    Navigator.of(context).popUntil((route) => count++ >= 3);
                    return;
                  }

                  GlobalSnackBar.showErrorSnackBarIcon(
                    context,
                    response.message!,
                  );

                  context.loaderOverlay.hide();
                  return;
                }

                GlobalSnackBar.showErrorSnackBarIcon(
                  context,
                  "Tuvimos problemas, vuelva a intentarlo más tarde.",
                );

                context.loaderOverlay.hide();
              }
            },
          ),
        ],
      ),
    );
  }
}
