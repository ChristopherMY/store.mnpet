import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/region_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:http/http.dart' as http;

class PhoneBloc extends ChangeNotifier {
  RegionRepositoryInterface regionRepositoryInterface;
  UserRepositoryInterface userRepositoryInterface;

  PhoneBloc({
    required this.regionRepositoryInterface,
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
      // removeError(error: kAddressNameNullError);
    }

    phone.value = value;
  }

  String? onValidationPhoneNumber(String? value) {
    if (value!.isEmpty) {
      //addError(error: kAddressNameNullError);
      return "";
    }

    return null;
  }

  void onChangePhoneDefault(bool? value) {
    phone.phoneDefault = value;

    notifyListeners();
  }


  Future<dynamic> onChangeDefaultPhone({
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

  Future<dynamic> onDeletePhone({
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

}
