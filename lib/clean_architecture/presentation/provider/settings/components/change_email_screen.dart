import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/settings/settings_bloc.dart';

class ChangeEmailScreen extends StatelessWidget {
  const ChangeEmailScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider<SettingsBloc>.value(
      value: context.read<SettingsBloc>(),
      builder: (_, __) => const ChangeEmailScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

}
