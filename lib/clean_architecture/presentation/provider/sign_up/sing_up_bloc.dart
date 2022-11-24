import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/credentials_auth.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/auth_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/keyboard.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';

class SignUpBloc extends ChangeNotifier {
  final AuthRepositoryInterface authRepositoryInterface;
  final HiveRepositoryInterface hiveRepositoryInterface;

  SignUpBloc({
    required this.authRepositoryInterface,
    required this.hiveRepositoryInterface,
  });

  ValueNotifier<List<String>> errors = ValueNotifier([]);

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController numDocController = TextEditingController();

  // TextEditingController phoneNumberController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ValueNotifier<bool> termsConditionsConfirmed = ValueNotifier(false);

  /*
    String name;
  String lastname;
  String email;
  String password;
  String confirmPassword;
  String numDoc;
  String phoneNumber;
  bool terms = false;
   */
  bool loginState = false;
  bool obscureTextNewPassword = true;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };

    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }

    return kPrimaryColor;
  }

  void addError({required String error}) {
    List<String> values = List.from(errors.value);
    if (!values.contains(error)) {
      values.add(error);
      errors.value = values;
    }
  }

  void removeError({required String error}) {
    List<String> values = List.from(errors.value);
    if (values.contains(error)) {
      values.remove(error);
      errors.value = values;
    }
  }

  void onChangeName(String value) {
    if (value.isNotEmpty) {
      removeError(error: kNamelNullError);
    }
  }

  String? onValidationName(String? value) {
    if (value!.isEmpty) {
      addError(error: kNamelNullError);
      return "";
    }

    return null;
  }

  void onChangeLastName(String value) {
    if (value.isNotEmpty) {
      removeError(error: kLastNameNullError);
    }
  }

  String? onValidationLastName(String? value) {
    if (value!.isEmpty) {
      addError(error: kLastNameNullError);
      return "";
    }

    return null;
  }

  void onChangePassword(String value) {
    if (value.length >= 8) {
      removeError(error: kShortPassError);
    } else if (value.isNotEmpty) {
      removeError(error: kPassNullError);
    }
  }

  String? onValidationPassword(String? value) {
    if (value!.isEmpty) {
      addError(error: kPassNullError);
      return "";
    } else if (value.length < 8) {
      addError(error: kShortPassError);
      return "";
    }

    return null;
  }

  void onChangeEmail(String value) {
    if (value.isNotEmpty) {
      removeError(error: kEmailNullError);
    }

    if (emailValidatorRegExp.hasMatch(value)) {
      removeError(error: kInvalidEmailError);
    }
  }

  String? onValidationEmail(String? value) {
    if (value!.isEmpty) {
      addError(error: kEmailNullError);
      return "";
    }

    if (!emailValidatorRegExp.hasMatch(value)) {
      addError(error: kInvalidEmailError);
      return "";
    }

    return null;
  }

  void onChangeNumberDoc(String value) {
    if (value.isNotEmpty) {
      removeError(error: kNumDocNullError);
    }
  }

  String? onValidationNumberDoc(String? value) {
    if (value!.isEmpty) {
      addError(error: kNumDocNullError);
      return "";
    }

    return null;
  }

  bool? onChangeTermsInfo(bool? value) {
    if (value!) {
      removeError(error: kTermsNullError);
    } else {
      addError(error: kTermsNullError);
    }

    termsConditionsConfirmed.value = value;
    return value;
  }

  void registerUser(
    BuildContext context, {
    required Map<String, dynamic> user,
  }) async {
    if (!termsConditionsConfirmed.value) {
      addError(error: kTermsNullError);
    }

    if (formKey.currentState!.validate()) {
      context.loaderOverlay.show();
      formKey.currentState!.save();
      KeyboardUtil.hideKeyboard(context);

      final mainBloc = context.read<MainBloc>();

      if (errors.value.isNotEmpty) {
        context.loaderOverlay.hide();
        return GlobalSnackBar.showWarningSnackBar(
          context,
          "Vuelva a revisar la información ingresada",
        );
      }

      Map<String, dynamic> modelUser = {
        "name": nameController.text,
        "lastname": lastnameController.text,
        "password": passwordController.text,
        "email": emailController.text,
        "document": {"value": numDocController.text, "type": "DNI"},
        "terms_conditions_confirmed": termsConditionsConfirmed.value
      };

      final responseApi = await authRepositoryInterface.createUser(data: user);

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

      final credentials = CredentialsAuth.fromMap(responseApi.data);

      await hiveRepositoryInterface.save(
        containerName: "authentication",
        key: "credentials",
        value: credentials.toMap(),
      );


      final responseSession = await mainBloc.loadSessionPromise();
      context.loaderOverlay.hide();

      if (responseSession) {
        mainBloc.handleLoadUserInformation(context);

        /// Procedemos a cambiar los items a carrito [produccion]
        mainBloc.moveShoppingCart(context);
        await mainBloc.handleGetShoppingCart(context);

        /// Count step to back
        int count = 0;
        Navigator.of(context).popUntil((route) => count++ >= mainBloc.countNavigateIterationScreen);

        return;
      }

      context.loaderOverlay.hide();
      GlobalSnackBar.showWarningSnackBar(
        context,
        "Tenemos un problema, por favor inténtelo más tarde.",
      );
    }
  }

  void refreshBloc() {
    notifyListeners();
  }
}
