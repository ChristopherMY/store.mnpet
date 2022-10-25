import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/settings/settings_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/custom_suffix_icon.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/default_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider<SettingsBloc>.value(
      value: context.read<SettingsBloc>(),
      builder: (_, __) => const ChangePasswordScreen._(),
    );
  }

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  void handleSavePasswordAccount() async {
    final settingsBloc = context.read<SettingsBloc>();

    if (settingsBloc.formPasswordKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.watch<SettingsBloc>();

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
                  key: settingsBloc.formPasswordKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: settingsBloc.newPasswordController,
                        obscureText: settingsBloc.obscureTextNewPassword,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: settingsBloc.onChangeNewPassword,
                        validator: settingsBloc.onValidationNewPassword,
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
                              settingsBloc.obscureTextNewPassword = !settingsBloc.obscureTextNewPassword;
                              settingsBloc.refreshSettingsBloc();
                            },
                            child: CustomSuffixIcon(
                              svgIcon: settingsBloc.obscureTextNewPassword
                                  ? "assets/icons/eye_off_thin.svg"
                                  : "assets/icons/eye_thin.svg",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(15.0)),
                      TextFormField(
                        controller: settingsBloc.confirmPasswordController,
                        obscureText: settingsBloc.obscureTextConfirmPassword,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: settingsBloc.onChangeConfirmPassword,
                        validator: settingsBloc.onValidationConfirmPassword,
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
                              settingsBloc.obscureTextConfirmPassword =
                                  !settingsBloc.obscureTextConfirmPassword;
                              settingsBloc.refreshSettingsBloc();
                            },
                            child: CustomSuffixIcon(
                              svgIcon: settingsBloc.obscureTextConfirmPassword
                                  ? "assets/icons/eye_off_thin.svg"
                                  : "assets/icons/eye_thin.svg",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(15.0)),
                      TextFormField(
                        controller: settingsBloc.currentPasswordController,
                        obscureText: settingsBloc.obscureTextCurrentPassword,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: settingsBloc.onChangeCurrentPassword,
                        validator: settingsBloc.onValidationCurrentPassword,
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
                              settingsBloc.obscureTextCurrentPassword =
                                  !settingsBloc.obscureTextCurrentPassword;
                              settingsBloc.refreshSettingsBloc();
                            },
                            child: CustomSuffixIcon(
                              svgIcon: settingsBloc.obscureTextCurrentPassword
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
