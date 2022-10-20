import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/sign_in/components/sign_form.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/sign_in/sign_in_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/no_account_text.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignInBloc(
        authRepositoryInterface: context.read<AuthRepositoryInterface>(),
        hiveRepositoryInterface: context.read<HiveRepositoryInterface>(),
      ),
      builder: (_, __) => const SignInScreen._(),
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
                  SizedBox(height: SizeConfig.screenHeight! * 0.03),
                  const SignForm(),
                  SizedBox(height: getProportionateScreenHeight(20.0)),
                  const NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
