import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/local_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';

import '../../../helper/http_response.dart';

class PhoneBloc extends ChangeNotifier {
  LocalRepositoryInterface localRepositoryInterface;
  UserRepositoryInterface userRepositoryInterface;

  PhoneBloc({
    required this.localRepositoryInterface,
    required this.userRepositoryInterface,
  });

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ValueNotifier<List<String>> errors = ValueNotifier([]);

  bool isUpdate = false;

  Phone phone = Phone(
    phoneDefault: false,
    type: "phone",
    areaCode: "51",
  );

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

  void onChangePhoneNumber(String value) {
    if (value.isNotEmpty) {
      removeError(error: kPhoneNumberNullError);
    }

    if (value.length == 9) {
      removeError(error: kPhoneNumberLostNullError);
    }

    phone.value = value;
  }

  String? onValidationPhoneNumber(String? value) {
    if (value!.isEmpty) {
      addError(error: kPhoneNumberNullError);
      return "";
    }

    if (value.length < 9) {
      addError(error: kPhoneNumberLostNullError);
      return "";
    }

    return null;
  }

  void onChangePhoneDefault(bool? value) {
    phone.phoneDefault = value;

    notifyListeners();
  }

  Future<dynamic> onChangeDefaultPhone(
    BuildContext context, {
    required String phoneId,
    required Map<String, String> headers,
  }) async {
    final mainBloc = context.read<MainBloc>();
    context.loaderOverlay.show();
    final responseApi = await userRepositoryInterface.changeMainPhone(
      phoneId: phoneId,
      headers: headers,
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
          context, "Ups tuvimos un problema, vuelva a intentarlo más tarde.");
      return;
    }

    mainBloc.handleLoadUserInformation(context);
    context.loaderOverlay.hide();

    final response = ResponseApi.fromMap(responseApi.data);
    GlobalSnackBar.showWarningSnackBar(context, response.message);
    return;
  }

  void onDeletePhone(
    BuildContext context, {
    required String phoneId,
    required Map<String, String> headers,
  }) async {
    context.loaderOverlay.show();
    final mainBloc = context.read<MainBloc>();
    final responseApi = await userRepositoryInterface.deleteUserPhone(
      phoneId: phoneId,
      headers: headers,
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
          context, "Ups tuvimos un problema, vuelva a intentarlo más tarde.");
      return;
    }

    mainBloc.handleLoadUserInformation(context);
    context.loaderOverlay.hide();

    final response = ResponseApi.fromMap(responseApi.data);
    GlobalSnackBar.showWarningSnackBar(context, response.message);
    return;
  }

  void onSave(
    BuildContext context, {
    required Map<String, String> headers,
  }) async {
    final mainBloc = context.read<MainBloc>();
    final HttpResponse responseApi;

    context.loaderOverlay.show();
    if (isUpdate) {
      responseApi = await userRepositoryInterface.updateUserPhone(
        phone: phone,
        headers: headers,
      );
    } else {
      responseApi = await userRepositoryInterface.createPhone(
        phone: phone,
        headers: headers,
      );
    }

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
        "Ups tuvimos un problema, vuelva a intentarlo más tarde.",
      );
      return;
    }

    mainBloc.handleLoadUserInformation(context);
    context.loaderOverlay.hide();

    final response = ResponseApi.fromMap(responseApi.data);
    GlobalSnackBar.showWarningSnackBar(context, response.message);
    return;
  }
}
