import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_forgot_password.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/keyboard.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/forgot_password/forgot_password_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/otp/otp_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/recovery_password/recovery_password_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';

import '../../../helper/constants.dart';
import '../../../helper/size_config.dart';

class OptScreen extends StatelessWidget {
  const OptScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider<ForgotPasswordBloc>.value(
      value: Provider.of<ForgotPasswordBloc>(context, listen: false),
      builder: (context, __) => ChangeNotifierProvider(
        create: (context) => OtpBloc(
          authRepositoryInterface: context.read<AuthRepositoryInterface>(),
        ),
        child: const OptScreen._(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final otpBloc = context.watch<OtpBloc>();
    final forgotPasswordBloc = context.read<ForgotPasswordBloc>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      otpBloc.startTimer();
    });

    final defaultPinTheme = PinTheme(
      width: SizeConfig.screenWidth! * 0.18,
      height: 64,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(232, 235, 241, 0.37),
        borderRadius: BorderRadius.circular(24),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
            offset: Offset(0, 3),
            blurRadius: 24,
          ),
        ],
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
            offset: Offset(0, 3),
            blurRadius: 16,
          )
        ],
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

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
        body: SizedBox(
          width: SizeConfig.screenWidth,
          child: SafeArea(
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
                        "Verificación de cuenta",
                        style: headingStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.03),
                    const Text("Hemos enviado el código de verificación a: "),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            "${forgotPasswordBloc.responseForgotPassword.email}. ",
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            forgotPasswordBloc.emailPhoneController.clear();
                            forgotPasswordBloc.responseForgotPassword = ResponseForgotPassword();

                            otpBloc.timer.cancel();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "¿No es tu correo?",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: kPrimaryColor),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.05),
                    Text(
                      "* Complete los datos",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.02),
                    Pinput(
                      length: 6,
                      controller: otpBloc.controller,
                      focusNode: otpBloc.focusNode,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      defaultPinTheme: defaultPinTheme,
                      separator: const SizedBox(width: 16.0),
                      focusedPinTheme: focusedPinTheme,
                      showCursor: true,
                      cursor: cursor,
                      errorText:
                          "Código incorrecto, compruebe su código de verificación",
                      errorTextStyle: Theme.of(context).textTheme.bodyText1,
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      onCompleted: (pin) async {
                        context.loaderOverlay.show();
                        final response = await otpBloc.validateOtp(
                          pin: pin,
                          userId:
                              forgotPasswordBloc.responseForgotPassword.userId!,
                        );

                        if (response is ResponseForgotPassword) {
                          if (response.status == 'success') {
                            GlobalSnackBar.showInfoSnackBarIcon(
                                context, response.message!);

                            Route route = MaterialPageRoute(
                              builder: (_) =>
                                  RecoveryPasswordScreen.init(context),
                            );
                            context.loaderOverlay.hide();
                            Navigator.push(context, route);
                            return;
                          }

                          GlobalSnackBar.showErrorSnackBarIcon(
                              context, response.message!);
                        } else {
                          GlobalSnackBar.showWarningSnackBar(context,
                              "Tuvimos problemas, vuelva a intentarlo más tarde.");
                        }

                        context.loaderOverlay.hide();
                        otpBloc.controller.clear();
                        otpBloc.responseError.value = true;
                      },
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.04),
                    ValueListenableBuilder(
                      valueListenable: otpBloc.counter,
                      builder: (context, int value, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Solicitar reenvio de código:  ${value != 0 ? "espere $value segundos" : ""}',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            value == 0
                                ? InkWell(
                                    onTap: () async {
                                      KeyboardUtil.hideKeyboard(context);
                                      context.loaderOverlay.show();

                                      final response = await forgotPasswordBloc
                                          .validateNumberDoc(
                                        value: forgotPasswordBloc
                                            .emailPhoneController.text,
                                        valueType: forgotPasswordBloc.valueType,
                                      );

                                      if (response is ResponseForgotPassword) {
                                        forgotPasswordBloc
                                            .responseForgotPassword = response;
                                        if (response.status == 'success') {
                                          GlobalSnackBar.showInfoSnackBarIcon(
                                            context,
                                            response.message!,
                                          );

                                          otpBloc.responseError.value = false;
                                          otpBloc.counter.value = 60;
                                          otpBloc.startTimer();
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
                                    },
                                    child: Text(
                                      "Reenviar código",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(color: kPrimaryColor),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.02),
                    ValueListenableBuilder(
                      valueListenable: otpBloc.responseError,
                      builder: (context, bool value, child) {
                        if (value) {
                          return Text(
                            '* Código incorrecto, compruebe su código de verificación',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Colors.red),
                          );
                        }

                        return const SizedBox();
                      },
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
