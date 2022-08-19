import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/domain/model/district.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/province.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/region.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/region_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';

import '../../../domain/repository/user_repository.dart';

class ShipmentBloc extends ChangeNotifier {
  RegionRepositoryInterface regionRepositoryInterface;
  UserRepositoryInterface userRepositoryInterface;

  ShipmentBloc({
    required this.regionRepositoryInterface,
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

  Address address = Address(
    ubigeo: Ubigeo(),
    lotNumber: 1,
    dptoInt: 1,
    addressDefault: false,
  );

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

  void onChangeRegion({
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

    final response = await regionRepositoryInterface.getProvinces(
      departmentId: regions[index].regionId!,
    );

    if (response is http.Response) {
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;

        provinces.addAll(
          data.map((element) => Province.fromMap(element)).toList().cast(),
        );
      } else {
        provinces = [];
      }
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      provinces = [];
    }

    address.ubigeo!.department = regions[index].name.toString();
    address.ubigeo!.province = "Seleccione";
    address.ubigeo!.district = "Seleccione";

    notifyListeners();
  }

  void onChangeProvince({
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

    final response = await regionRepositoryInterface.getDistricts(
      provinceId: provinces[index].provinceId!,
    );

    if (response is http.Response) {
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        districts.addAll(
            data.map((element) => District.fromMap(element)).toList().cast());
      } else {
        districts = [];
      }
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      districts = [];
    }

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

  Future<dynamic> onSave({required Map<String, String> headers}) async {
    if (isUpdate) {
      final response = await userRepositoryInterface.updateUserAddress(
        address: address,
        headers: headers,
      );

      if (response is http.Response) {
        if (response.statusCode == 200) {
          return responseApiFromMap(response.body);
        }

        return false;
      } else if (response is String) {
        if (kDebugMode) {
          print(response);
        }
      }
    } else {
      final response = await userRepositoryInterface.createAddress(
        address: address,
        headers: headers,
      );

      if (response is http.Response) {
        if (response.statusCode == 200) {
          return responseApiFromMap(response.body);
        }

        return false;
      } else if (response is String) {
        if (kDebugMode) {
          print(response);
        }
      }
    }

    return false;
  }

  Future<dynamic> onChangeDefaultAddress({
    required String addressId,
    required Map<String, String> headers,
  }) async {
    final response = await userRepositoryInterface.changeMainAddress(
      addressId: addressId,
      headers: headers,
    );

    if (response is http.Response) {
      if (response.statusCode == 200) {
        return responseApiFromMap(response.body);
      }

      return false;
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }
    }

    return false;
  }

  Future<dynamic> onDeleteAddress({
    required String addressId,
    required Map<String, String> headers,
  }) async {
    final response = await userRepositoryInterface.deleteUserAddress(
      addressId: addressId,
      headers: headers,
    );

    if (response is http.Response) {
      if (response.statusCode == 200) {
        return responseApiFromMap(response.body);
      }

      return false;
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }
    }

    return false;
  }

  void onChangeAddressDefault(bool? value) {
    address.addressDefault = value;

    notifyListeners();
  }


}
