import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/settings/components/change_email_screen.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/settings/components/change_password_screen.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/settings/settings_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/global_snackbar.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/default_button.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/form_error.dart';

import '../../widget/item_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider<SettingsBloc>(
      create: (context) => SettingsBloc(
          userRepositoryInterface: context.read<UserRepositoryInterface>()),
      builder: (_, __) => const SettingsScreen._(),
    );
  }

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void handleSaveConfigurationAccount() async {
    final settingsBloc = context.read<SettingsBloc>();

    if (settingsBloc.formKey.currentState!.validate()) {
      final mainBloc = context.read<MainBloc>();
      context.loaderOverlay.show();

      Map<String, dynamic> binding = {
        "name": settingsBloc.nameController.text,
        "lastname": settingsBloc.lastnameController.text,
        "document": <String, String>{
          "value": settingsBloc.documentNumberController.text,
          "type": "DNI"
        },
      };

      final headers = mainBloc.headers;

      final response = await settingsBloc.userRepositoryInterface
          .updateUserInformation(binding: binding, headers: headers);

      if (!mounted) return;

      if (response is String) {
        if (kDebugMode) {
          print(response);
        }

        context.loaderOverlay.hide();
        GlobalSnackBar.showWarningSnackBar(
          context,
          "Lo sentimos, vuelva a intentarlo otra vez",
        );
        return;
      }

      if (response is! http.Response) {
        context.loaderOverlay.hide();
        GlobalSnackBar.showWarningSnackBar(
          context,
          "Lo sentimos, vuelva a intentarlo otra vez",
        );
        return;
      }

      if (response.statusCode != 200) {
        GlobalSnackBar.showWarningSnackBar(
          context,
          "Lo sentimos, vuelva a intentarlo otra vez",
        );
        context.loaderOverlay.hide();
        return;
      }

      final responseDecode = json.decode(response.body);
      final informationUser = UserInformation.fromMap(responseDecode);

      mainBloc.informationUser = informationUser;
      mainBloc.refreshMainBloc();
      context.loaderOverlay.hide();
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    final settingsBloc = context.read<SettingsBloc>();
    final mainBloc = context.read<MainBloc>();

    UserInformation userInformation = mainBloc.informationUser;

    settingsBloc.nameController =
        TextEditingController(text: userInformation.name);
    settingsBloc.lastnameController =
        TextEditingController(text: userInformation.lastname);
    settingsBloc.documentNumberController =
        TextEditingController(text: userInformation.document!.value!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.watch<SettingsBloc>();
    final mainBloc = context.read<MainBloc>();

    UserInformation userInformation = mainBloc.informationUser;

    return SafeArea(
      child: LoaderOverlay(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            bottomOpacity: 0.0,
            elevation: 0.0,
            title: const Text(
              "Configuración de mi cuenta",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: settingsBloc.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "Información personal",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    TextFormField(
                      controller: settingsBloc.nameController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onChanged: settingsBloc.onChangeName,
                      validator: settingsBloc.onValidationName,
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
                        errorStyle: const TextStyle(height: 0),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: settingsBloc.lastnameController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onChanged: settingsBloc.onChangeLastName,
                      validator: settingsBloc.onValidationLastName,
                      style: Theme.of(context).textTheme.bodyText2,
                      decoration: InputDecoration(
                        labelText: "Apellido (como aparece en tu DNI)",
                        hintText: "Ingresa tu apellido",
                        labelStyle: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w400),
                        hintStyle: Theme.of(context).textTheme.bodyText2,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        errorStyle: const TextStyle(height: 0),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: settingsBloc.documentNumberController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onChanged: settingsBloc.onChangeNumberDoc,
                      validator: settingsBloc.onValidationNumberDoc,
                      style: Theme.of(context).textTheme.bodyText2,
                      decoration: InputDecoration(
                        labelText: "DNI",
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
                    const SizedBox(height: 10.0),
                    TextFormField(
                      enabled: false,
                      keyboardType: TextInputType.text,
                      initialValue: userInformation.email!.address!,
                      style: Theme.of(context).textTheme.bodyText2,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Ingresa tu correo electrónico",
                        labelStyle: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: Theme.of(context).textTheme.bodyText2,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        errorStyle: const TextStyle(height: 0),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    ValueListenableBuilder(
                      valueListenable: settingsBloc.errors,
                      builder: (context, List<String> value, child) {
                        return FormError(errors: value);
                      },
                    ),
                    const SizedBox(height: 10.0),
                    ItemButton(
                      title: "Cambiar contraseña",
                      press: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChangePasswordScreen.init(context),
                          ),
                        );
                      },
                      icon: Icons.security,
                    ),
                    ItemButton(
                      title: "Cambiar correo",
                      press: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChangeEmailScreen.init(context),
                          ),
                        );
                      },
                      icon: Icons.mail_outline_sharp,
                    ),
                    const SizedBox(height: 50),
                    DefaultButton(
                      text: "Guardar",
                      press: handleSaveConfigurationAccount,
                    ),
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
