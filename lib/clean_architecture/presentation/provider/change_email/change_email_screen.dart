import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/change_email/change_email_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/default_button.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/form_error.dart';

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
  void handleSavePasswordAccount() async {
    final changePasswordBloc = context.read<ChangeEmailBloc>();

    if (changePasswordBloc.formKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    final changeEmailBloc = context.watch<ChangeEmailBloc>();

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
                        validator: changeEmailBloc.onValidationCurrentPassword,
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
