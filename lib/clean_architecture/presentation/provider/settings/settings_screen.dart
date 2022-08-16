import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/settings/settings_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/default_button.dart';

import '../../widget/item_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingsBloc(),
      builder: (_, __) => const SettingsScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
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
                buildNameFormField(context: context),
                const SizedBox(height: 10.0),
                buildLastNameFormField(context: context),
                const SizedBox(height: 10.0),
                buildDNIFormField(context: context),
                const SizedBox(height: 10.0),
                buildEmailFormField(context: context),
                const SizedBox(height: 10.0),
                ItemButton(
                  title: "Cambiar contraseña",
                  press: () {},
                  icon: Icons.security,
                ),
                ItemButton(
                  title: "Cambiar correo",
                  press: () {},
                  icon: Icons.mail_outline_sharp,
                ),
                const SizedBox(height: 50),
                DefaultButton(text: "Guardar", press: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildNameFormField({required BuildContext context}) {
    final settingBloc = Provider.of<SettingsBloc>(context);

    return TextFormField(
      //controller: signInBloc.passwordController,
      keyboardType: TextInputType.text,
      // onChanged: signInBloc.onChangePassword,
      // validator: signInBloc.onValidationPassword,
      style: Theme.of(context).textTheme.bodyText2,
      decoration: InputDecoration(
        labelText: "Nombre",
        hintText: "Ingresa tu nombre",
        labelStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
        hintStyle: Theme.of(context).textTheme.bodyText2,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        errorStyle: const TextStyle(height: 0),
      ),
    ) ;
  }

  TextFormField buildLastNameFormField({required BuildContext context}) {
    final settingBloc = Provider.of<SettingsBloc>(context);

    return TextFormField(
      //controller: signInBloc.passwordController,
      keyboardType: TextInputType.text,
      // onChanged: signInBloc.onChangePassword,
      // validator: signInBloc.onValidationPassword,
      style: Theme.of(context).textTheme.bodyText2,
      decoration: InputDecoration(
        labelText: "Apellido (como aparece en tu DNI)",
        hintText: "Ingresa tu apellido",
        labelStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
        hintStyle: Theme.of(context).textTheme.bodyText2,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        errorStyle: const TextStyle(height: 0),
      ),
    );
  }

  TextFormField buildDNIFormField({required BuildContext context}) {
    final settingBloc = Provider.of<SettingsBloc>(context);

    return TextFormField(
      //controller: signInBloc.passwordController,
      keyboardType: TextInputType.number,
      // onChanged: signInBloc.onChangePassword,
      // validator: signInBloc.onValidationPassword,
      style: Theme.of(context).textTheme.bodyText2,
      decoration: InputDecoration(
        labelText: "DNI",
        hintText: "Ingresa tu número de documento",
        labelStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
        hintStyle: Theme.of(context).textTheme.bodyText2,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        errorStyle: const TextStyle(height: 0),
      ),
    );
  }

  TextFormField buildEmailFormField({required BuildContext context}) {
    final settingBloc = Provider.of<SettingsBloc>(context);

    return TextFormField(
      enabled: false,
      keyboardType: TextInputType.text,
      initialValue: "demo@demo.com",
      style: Theme.of(context).textTheme.bodyText2,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Ingresa tu correo electrónico",
        labelStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
        hintStyle: Theme.of(context).textTheme.bodyText2,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        errorStyle: const TextStyle(height: 0),
      ),
    );
  }
}
