import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/district.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/province.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/region.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/local_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';

import '../../../domain/repository/user_repository.dart';
import '../../../helper/http_response.dart';

class ShipmentBloc extends ChangeNotifier {
  LocalRepositoryInterface localRepositoryInterface;
  UserRepositoryInterface userRepositoryInterface;

  ShipmentBloc({
    required this.localRepositoryInterface,
    required this.userRepositoryInterface,
  });

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ValueNotifier<List<String>> errors = ValueNotifier([]);

  List<Map<String, dynamic>> addressTypes = [
    {
      "name": "Casa",
      "checked": false,
    },
    {"name": "Centro", "checked": false},
    {"name": "Condominio", "checked": false},
    {"name": "Departamento", "checked": false},
    {"name": "Galeria", "checked": false},
    {"name": "Local", "checked": false},
    {"name": "Mercado", "checked": false},
    {"name": "Oficina", "checked": false},
    {"name": "Recidencial", "checked": false},
    {"name": "Otro", "checked": false}
  ];

  Address address = addressDefault;

  List<Province> provinces = <Province>[];
  List<District> districts = <District>[];

  bool isUpdate = false;

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

  void onChangeAddressName(String value) {
    if (value.isNotEmpty) {
      removeError(error: kAddressNameNullError);
    }

    address.addressName = value;
  }

  String? onValidationAddressName(String? value) {
    if (value!.isEmpty) {
      addError(error: kAddressNameNullError);
      return "";
    }

    return null;
  }

  void onChangeDirection(String value) {
    if (value.isNotEmpty) {
      removeError(error: kDirectionNullError);
    }

    address.direction = value;
  }

  String? onValidationDirection(String? value) {
    if (value!.isEmpty) {
      addError(error: kDirectionNullError);
      return "";
    }

    return null;
  }

  void onChangeLotNumber(String value) {
    if (value.isNotEmpty) {
      removeError(error: kNumberLotNullError);
    }

    if (value.isNotEmpty) {
      address.lotNumber = int.parse(value);
    }
  }

  String? onValidationLotNumber(String? value) {
    if (value!.isEmpty) {
      addError(error: kNumberLotNullError);
      return "";
    }

    return null;
  }

  void onChangeDPTO(String value) {
    if (value.isNotEmpty) {
      address.dptoInt = int.parse(value);
    }
  }

  void onChangeRegion(
    BuildContext context, {
    required int index,
    required StateSetter stateAlertRegion,
    required List<Region> regions,
  }) async {
    provinces.clear();
    for (final region in regions) {
      if (region.checked == true) {
        region.checked = false;
      } else {
        continue;
      }
    }

    stateAlertRegion(() {
      regions[index].checked = true;
    });

    address.ubigeo!.departmentId = regions[index].id.toString();

    final responseApi = await localRepositoryInterface.getProvinces(
      departmentId: regions[index].regionId!,
    );

    if (responseApi.data == null) {
      provinces = [];
      final statusCode = responseApi.error!.statusCode;

      if (statusCode == 400) {
        final response = ResponseApi.fromMap(responseApi.error!.data);
        GlobalSnackBar.showWarningSnackBar(context, response.message);
        return;
      }

      GlobalSnackBar.showWarningSnackBar(context, kOtherProblem);
      return;
    }

    final data = responseApi.data;

    provinces.addAll(
      data.map((element) => Province.fromMap(element)).toList().cast(),
    );

    address.ubigeo!.department = regions[index].name.toString();
    address.ubigeo!.province = "Seleccione";
    address.ubigeo!.district = "Seleccione";

    notifyListeners();
  }

  void onChangeProvince(
    BuildContext context, {
    required int index,
    required StateSetter stateAlertProvince,
  }) async {
    districts.clear();
    for (final province in provinces) {
      if (province.checked == true) {
        province.checked = false;
      } else {
        continue;
      }
    }

    stateAlertProvince(() => provinces[index].checked = true);

    address.ubigeo!.provinceId = provinces[index].id.toString();

    final responseApi = await localRepositoryInterface.getDistricts(
      provinceId: provinces[index].provinceId!,
    );

    if (responseApi.data == null) {
      districts = [];
      final statusCode = responseApi.error!.statusCode;

      if (statusCode == 400) {
        final response = ResponseApi.fromMap(responseApi.error!.data);
        GlobalSnackBar.showWarningSnackBar(context, response.message);
        return;
      }

      GlobalSnackBar.showWarningSnackBar(context, kOtherProblem);
      return;
    }

    final data = responseApi.data;

    districts.addAll(
        data.map((element) => District.fromMap(element)).toList().cast());

    address.ubigeo!.province = provinces[index].name.toString();
    address.ubigeo!.district = "Seleccione";

    notifyListeners();
  }

  void onChangeDistrict({
    required int index,
    required StateSetter stateAlertDistrict,
  }) {
    for (final district in districts) {
      if (district.checked == true) {
        district.checked = false;
      } else {
        continue;
      }
    }

    address.ubigeo!.districtId = districts[index].id.toString();
    districts[index].checked = true;

    stateAlertDistrict(() {
      address.ubigeo!.district = districts[index].name.toString();
    });

    notifyListeners();
  }

  void onChangeAddressTypes({required int index}) {
    for (var type in addressTypes) {
      if (type['checked']) {
        type['checked'] = false;
      } else {
        continue;
      }
    }

    addressTypes[index]["checked"] = true;

    address.addressType = addressTypes[index]["name"];
    notifyListeners();
  }

  void onSave(
    BuildContext context, {
    required Map<String, String> headers,
  }) async {
    final mainBloc = context.read<MainBloc>();
    context.loaderOverlay.show();
    final HttpResponse responseApi;

    if (isUpdate) {
      responseApi = await userRepositoryInterface.updateUserAddress(
        address: address,
        headers: headers,
      );
    } else {
      responseApi = await userRepositoryInterface.createAddress(
        address: address,
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
        "Ups tuvimos problemas, vuelva a intentarlo más tarde",
      );
      return;
    }

    mainBloc.handleLoadUserInformation(context);
    context.loaderOverlay.hide();

    final response = ResponseApi.fromMap(responseApi.data);
    GlobalSnackBar.showWarningSnackBar(context, response.message);
    return;
  }

  void onChangeDefaultAddress(
    BuildContext context, {
    required String addressId,
    required Map<String, String> headers,
  }) async {
    final mainBloc = context.read<MainBloc>();
    context.loaderOverlay.show();
    final responseApi = await userRepositoryInterface.changeMainAddress(
      addressId: addressId,
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
        context,
        "Ups tuvimos problemas, vuelva a intentarlo más tarde",
      );
      return;
    }

    mainBloc.handleLoadUserInformation(context);
    context.loaderOverlay.hide();

    final response = ResponseApi.fromMap(responseApi.data);
    GlobalSnackBar.showWarningSnackBar(context, response.message);
    return;
  }

  void onDeleteAddress(
    BuildContext context, {
    required String addressId,
    required Map<String, String> headers,
  }) async {
    final mainBloc = context.read<MainBloc>();
    context.loaderOverlay.show();
    final responseApi = await userRepositoryInterface.deleteUserAddress(
      addressId: addressId,
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
        context,
        "Ups tuvimos problemas, vuelva a intentarlo más tarde",
      );
      return;
    }

    mainBloc.handleLoadUserInformation(context);
    context.loaderOverlay.hide();

    final response = ResponseApi.fromMap(responseApi.data);
    GlobalSnackBar.showWarningSnackBar(context, response.message);
    return;
  }

  void onChangeAddressDefault(bool? value) {
    address.addressDefault = value;

    notifyListeners();
  }
}
