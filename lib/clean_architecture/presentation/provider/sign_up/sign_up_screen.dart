import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/sign_up/components/sign_up_form.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/sign_up/sing_up_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpBloc(
        authRepositoryInterface: context.read<AuthRepositoryInterface>(),
        hiveRepositoryInterface: context.read<HiveRepositoryInterface>(),
      ),
      builder: (_, __) => const SignUpScreen._(),
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
                children: [
                  SizedBox(height: SizeConfig.screenHeight! * 0.01),
                  Text("Registrar cuenta", style: headingStyle),
                  Text(
                    "Complete sus datos",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.04),
                  const SignUpForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
