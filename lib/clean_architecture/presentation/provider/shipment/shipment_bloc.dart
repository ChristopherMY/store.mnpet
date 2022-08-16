import 'package:flutter/cupertino.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';

class ShipmentBloc extends ChangeNotifier {
  ShipmentBloc();

  TextEditingController addressNameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ValueNotifier<List<String>> errors = ValueNotifier([]);

  List<Map<String, dynamic>> addressTypes = const [
    {"name": "Casa", "checked": false},
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
  }

  String? onValidationLotNumber(String? value) {
    if (value!.isEmpty) {
      addError(error: kNumberLotNullError);
      return "";
    }

    return null;
  }

  void onChangeRegion({
    required int index,
    required Address address,
  }) async {
    //  _regions[index].checked = true;
    address.ubigeo!.department = "_regions[index].name";
    address.ubigeo!.province = "Seleccione";
    address.ubigeo!.district = "Seleccione";

    address.ubigeo!.departmentId = "_regions[index].id";
    //departmentIdMainDepartmentId = _regions[index].regionId;

    // _provinces = await _userProvider.getProvinces(
    //   departmentId: departmentIdMainDepartmentId,
    // );

    removeError(error: kDeparmentNullError);
    addError(error: kProvinceNullError);
    addError(error: kDistrictNullError);
  }
}
