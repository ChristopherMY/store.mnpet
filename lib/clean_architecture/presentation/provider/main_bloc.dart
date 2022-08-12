import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/domain/model/credentials_auth.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/district.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/province.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/region.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information_local.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/product_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/region_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/login/login_screen.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/splash/splash_screen.dart';

class MainBloc extends ChangeNotifier {
  RegionRepositoryInterface regionRepositoryInterface;
  HiveRepositoryInterface hiveRepositoryInterface;
  ProductRepositoryInterface productRepositoryInterface;
  UserRepositoryInterface userRepositoryInterface;

  MainBloc({
    required this.regionRepositoryInterface,
    required this.hiveRepositoryInterface,
    required this.productRepositoryInterface,
    required this.userRepositoryInterface,
  });

  dynamic credentials;

  int indexSelected = 0;
  bool isLogged = false;
  ValueNotifier<bool> isLoadProfileScreen = ValueNotifier(false);

  List<Region> regions = <Region>[];
  List<Province> provinces = <Province>[];
  List<District> districts = <District>[];

  List<String> errors = [];

  String departmentName = "Seleccione un departamento";
  String departmentId = "";

  String provinceName = "Seleccione una provincia";
  String provinceId = "";

  String districtName = "Seleccione un distrito";
  String districtId = "";

  String ubigeo = "";

  dynamic informationUser;

  Map<String, String> headers = {
    "Content-type": "application/json",
    "Custom-Origin": "app",
    "Authorization": ""
  };

  void onChangeIndexSelected({
    required int index,
    required BuildContext context,
  }) async {
    if (indexSelected != index) {
      indexSelected = index;

      if (indexSelected == 0) {
        notifyListeners();
        return;
      }

      if (indexSelected == 1) {
        if (credentials is! CredentialsAuth) {
          requestAccess(context);
        }

        notifyListeners();
        return;
      }

      if (indexSelected == 2) {
        if (credentials is! CredentialsAuth) {
          requestAccess(context);
          isLoadProfileScreen.value = true;
          notifyListeners();
          return;
        } else {
          if (informationUser is! UserInformation) {
            loadUserInformationPromise().then((loadInformation) {
              // TODO: No importa la respuesta solo importa que termine de cargar para despejar el placeholder de espera proveniente de la lectura de Hive Storage

              if (loadInformation) {
                isLoadProfileScreen.value = true;
              }
            });
          }

          notifyListeners();
          return;
        }
      }
    }
  }

  void requestAccess(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => const LoginScreen()),
      ),
    );
  }

  void forceLoadingScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SplashScreen(),
    ));
  }

  void initRegion() async {
    final response = await regionRepositoryInterface.getRegions();
    if (response is http.Response) {
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        regions.addAll(
            data.map((element) => Region.fromMap(element)).toList().cast());
      } else {
        regions = [];
      }
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      regions = [];
    }
  }

  void onChangeRegion({
    required int index,
    required StateSetter stateAlertMain,
    required StateSetter stateAlertRegion,
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

    departmentId = regions[index].regionId.toString();

    final response = await regionRepositoryInterface.getProvinces(
      departmentId: departmentId,
    );

    if (response is http.Response) {
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;

        provinces.addAll(
            data.map((element) => Province.fromMap(element)).toList().cast());
      } else {
        provinces = [];
      }
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      provinces = [];
    }

    stateAlertMain(() {
      departmentName = regions[index].name.toString();
      provinceName = "Seleccione";
      districtName = "Seleccione";
    });

    notifyListeners();
  }

  void onChangeProvince({
    required int index,
    required StateSetter stateAlertMain,
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

    provinceId = provinces[index].provinceId.toString();
    final response =
        await regionRepositoryInterface.getDistricts(provinceId: provinceId);

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

    stateAlertMain(() {
      provinceName = provinces[index].name.toString();
      districtName = "Seleccione";
    });
  }

  void onChangeDistrict({
    required int index,
    required StateSetter stateAlertMain,
    required StateSetter stateAlertDistrict,
  }) {
    for (final district in districts) {
      if (district.checked == true) {
        district.checked = false;
      } else {
        continue;
      }
    }

    districtId = districts[index].id.toString();
    stateAlertMain(() => districts[index].checked = true);
    stateAlertDistrict(() => districtName = districts[index].name.toString());
  }

  void addError({required String error, state}) {
    if (!errors.contains(error)) state(() => errors.add(error));
  }

  void removeError({required String error, state}) {
    if (errors.contains(error)) state(() => errors.remove(error));
  }

  Future<dynamic> onSaveShippingAddress({
    required StateSetter stateAlertMain,
    required String slug,
    required int quantity,
  }) async {
    departmentName == "Seleccione un departamento" ||
            departmentName == "Seleccione"
        ? addError(
            error: kDeparmentNullError,
            state: stateAlertMain,
          )
        : removeError(
            error: kDeparmentNullError,
            state: stateAlertMain,
          );

    provinceName == "Seleccione una provincia" || provinceName == "Seleccione"
        ? addError(
            error: kProvinceNullError,
            state: stateAlertMain,
          )
        : removeError(
            error: kProvinceNullError,
            state: stateAlertMain,
          );

    districtName == "Seleccione un distrito" || districtName == "Seleccione"
        ? addError(
            error: kDistrictNullError,
            state: stateAlertMain,
          )
        : removeError(
            error: kDistrictNullError,
            state: stateAlertMain,
          );

    if (errors.isEmpty) {
      final userInformationLocal = UserInformationLocal(
        department: departmentName,
        province: provinceName,
        district: districtName,
        districtId: districtId,
        ubigeo: "$departmentName - $provinceName - $districtName",
      );

      ubigeo = "$departmentName - $provinceName - $districtName";

      hiveRepositoryInterface.save(
        containerName: "profile",
        key: "residence",
        value: userInformationLocal.toMap(),
      );

      final response = await productRepositoryInterface.getShipmentPriceCost(
        slug: slug,
        districtId: districtId,
        quantity: quantity,
      );

      if (response is http.Response) {
        if (response.statusCode == 200) {
          return double.parse(response.body.replaceAll('"', ""));
        } else {
          return null;
        }
      } else if (response is String) {
        if (kDebugMode) {
          print("Error in response shipping price main bloc");
        }

        return null;
      }
    } else {
      print("RETORNO NULL");
      return null;
    }
  }

  Future<bool> loadSessionPromise() async {
    final responseCredentials = CredentialsAuth.fromMap(
      await hiveRepositoryInterface.read(
            containerName: "authentication",
            key: "credentials",
          ) ??
          {"email": "", "email_confirmed": false, "token": ""},
    );

    if (responseCredentials.token.isNotEmpty) {
      credentials = responseCredentials;
      headers["Authorization"] = "Bearer ${responseCredentials.token}";
      return true;
    }

    return false;
  }

// TODO: Solo se trabajara en el Main Screen
  void loadSession() async {
    final responseCredentials = CredentialsAuth.fromMap(
      await hiveRepositoryInterface.read(
            containerName: "authentication",
            key: "credentials",
          ) ??
          {"email": "", "email_confirmed": false, "token": ""},
    );

    if (responseCredentials.token.isNotEmpty) {
      credentials = responseCredentials;
      headers["Authorization"] = "Bearer ${responseCredentials.token}";
    }
  }

  void signOut() async {
    await hiveRepositoryInterface.remove(
      containerName: "authentication",
      key: "credentials",
    );
    credentials = dynamic;
    informationUser = dynamic;
    headers["Authorization"] = '';

    notifyListeners();
  }

  Future<bool> loadUserInformationPromise() async {
    final response = await userRepositoryInterface.getInformationUser(
      headers: headers,
    );

    if (response is http.Response) {
      if (response.statusCode == 200) {
        final decodeResponse = json.decode(response.body);
        if (kDebugMode) {
          print(decodeResponse);
        }

        informationUser = UserInformation.fromMap(decodeResponse);
        return true;
      }
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }
    }

    return false;
  }

  // TODO: Solo se trabajara en el Main Screen
  void loadUserInformation() async {
    final response = await userRepositoryInterface.getInformationUser(
      headers: headers,
    );

    if (response is http.Response) {
      if (response.statusCode == 200) {
        final decodeResponse = json.decode(response.body);
        if (kDebugMode) {
          print(decodeResponse);
        }

        informationUser = UserInformation.fromMap(decodeResponse);
      }
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }
    }

    notifyListeners();
  }

  void refreshMainBloc() {
    notifyListeners();
  }
}
