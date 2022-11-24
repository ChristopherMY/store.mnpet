import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/change_email/change_email_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/default_button.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/form_error.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider<ChangeEmailBloc>(
      create: (context) => ChangeEmailBloc(
        userRepositoryInterface: context.read<UserRepositoryInterface>(),
      ),
      builder: (_, __) => const ChangeEmailScreen._(),
    );
  }

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  void handleSaveEmailAccount() async {
    final changeEmailBloc = context.read<ChangeEmailBloc>();
    final mainBloc = context.read<MainBloc>();

    if (changeEmailBloc.formKey.currentState!.validate()) {
      changeEmailBloc.formKey.currentState!.save();
      context.loaderOverlay.show();

      final responseApi =
          await changeEmailBloc.userRepositoryInterface.changeUserMail(
        headers: mainBloc.headers,
        bindings: {
          "email": changeEmailBloc.emailController.text,
          "confirmEmail": changeEmailBloc.confirmEmailController.text,
          "password": changeEmailBloc.currentPasswordController.text,
        },
      );

      if (responseApi.data == null) {
        context.loaderOverlay.hide();
        final statusCode = responseApi.error!.statusCode;
        if (statusCode == 400) {
          final response = ResponseApi.fromMap(responseApi.error!.data);
          GlobalSnackBar.showWarningSnackBar(context, response.message);
          return;
        }

        GlobalSnackBar.showWarningSnackBar(
          context,
          "Ups tuvimos problemas, vuelva a intentarlo más tarde",
        );

        return;
      }

      mainBloc.handleLoadUserInformation(context);

      final response = ResponseApi.fromMap(responseApi.data);
      GlobalSnackBar.showInfoSnackBarIcon(context, response.message);

      Navigator.of(context).pop();
      context.loaderOverlay.hide();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final changeEmailBloc = context.watch<ChangeEmailBloc>();

    return LoaderOverlay(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kBackGroundColor,
          appBar: AppBar(
            backgroundColor: kBackGroundColor,
            leading: const BackButton(
              color: Colors.black,
            ),
            elevation: 0,
            title: const Text(
              "Cambiar Email",
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Actualizacion de correo",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Form(
                    key: changeEmailBloc.formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: changeEmailBloc.emailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: changeEmailBloc.onChangeEmail,
                          validator: changeEmailBloc.onValidationEmail,
                          textInputAction: TextInputAction.next,
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
                        SizedBox(height: getProportionateScreenHeight(15.0)),
                        TextFormField(
                          controller: changeEmailBloc.confirmEmailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: changeEmailBloc.onChangeConfirmEmail,
                          validator: changeEmailBloc.onValidationConfirmEmail,
                          textInputAction: TextInputAction.next,
                          style: Theme.of(context).textTheme.bodyText2,
                          decoration: InputDecoration(
                            labelText: "Confirmar Correo",
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
                        SizedBox(height: getProportionateScreenHeight(15.0)),
                        TextFormField(
                          controller: changeEmailBloc.currentPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: changeEmailBloc.onChangeCurrentPassword,
                          validator:
                              changeEmailBloc.onValidationCurrentPassword,
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(35.0)),
                  ValueListenableBuilder(
                    valueListenable: changeEmailBloc.errors,
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
                    press: handleSaveEmailAccount,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
