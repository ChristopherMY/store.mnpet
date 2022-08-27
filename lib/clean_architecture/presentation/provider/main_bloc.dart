import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/domain/model/cart.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/credentials_auth.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/district.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/province.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/region.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information_local.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/cart_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/product_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/region_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/login/login_screen.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/splash/splash_screen.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/loadany.dart';

class MainBloc extends ChangeNotifier {
  RegionRepositoryInterface regionRepositoryInterface;
  HiveRepositoryInterface hiveRepositoryInterface;
  ProductRepositoryInterface productRepositoryInterface;
  UserRepositoryInterface userRepositoryInterface;
  CartRepositoryInterface cartRepositoryInterface;

  MainBloc({
    required this.regionRepositoryInterface,
    required this.hiveRepositoryInterface,
    required this.productRepositoryInterface,
    required this.userRepositoryInterface,
    required this.cartRepositoryInterface,
  });

  dynamic credentials;

  bool isLogged = false;
  ValueNotifier<LoadStatus> accountLoaded = ValueNotifier(LoadStatus.loading);
  ValueNotifier<LoadStatus> shoppingCartLoaded =
      ValueNotifier(LoadStatus.loading);
  ValueNotifier<int> indexSelected = ValueNotifier(0);

  List<Region> regions = List.of(<Region>[]);

  List<Region> extraRegions = List.of(<Region>[]);
  List<Province> provinces = <Province>[];
  List<District> districts = <District>[];

  List<String> errors = [];

  ValueNotifier<String> departmentName =
      ValueNotifier("Seleccione un departamento");
  String departmentId = "";

  ValueNotifier<String> provinceName =
      ValueNotifier("Seleccione una provincia");
  String provinceId = "";

  ValueNotifier<String> districtName = ValueNotifier("Seleccione un distrito");
  String districtId = "";

  String ubigeo = "";

  dynamic informationUser;
  dynamic informationCart;

  Map<String, String> headers = {
    "Content-type": "application/json",
    "Custom-Origin": "app",
  };

  void onChangeIndexSelected({
    required int index,
    required BuildContext context,
  }) {
    if (indexSelected.value != index) {
      indexSelected.value = index;

      if (indexSelected.value == 0) {
        return;
      }

      if (indexSelected.value == 1) {
        if (credentials is! CredentialsAuth) {
          requestAccess(context);
          accountLoaded.value = LoadStatus.normal;
          // return;
        } else {
          if (informationUser is! UserInformation) {
            loadShipmentResidence().then(
              (shipmentResidence) {
                fetchGetShoppingCart(districtId: shipmentResidence.districtId!)
                    .then(
                  (cart) {
                    if (cart is Cart) {
                      informationCart = cart;
                    }
                    shoppingCartLoaded.value = LoadStatus.normal;
                  },
                );
              },
            );
          }
        }
      }

      if (indexSelected.value == 2) {
        if (credentials is! CredentialsAuth) {
          requestAccess(context);
          accountLoaded.value = LoadStatus.normal;
          return;
        } else {
          if (informationUser is! UserInformation) {
            fetchGetUserInformation().then(
              (loadInformation) {
                if (loadInformation is UserInformation) {
                  informationUser = loadInformation;
                }

                accountLoaded.value = LoadStatus.normal;
              },
            );
          }

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
          data.map((element) => Region.fromMap(element)).toList().cast(),
        );

        extraRegions.addAll(
          data.map((element) => Region.fromMap(element)).toList().cast(),
        );

        return;
      }

      regions = [];
      extraRegions = [];
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      regions = [];
      extraRegions = [];
    }
  }

  void onChangeRegion({
    required int index,
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

    departmentName.value = regions[index].name.toString();
    provinceName.value = "Seleccione";
    districtName.value = "Seleccione";
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

    provinceName.value = provinces[index].name.toString();
    districtName.value = "Seleccione";
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

    districtId = districts[index].id.toString();
    districts[index].checked = true;

    stateAlertDistrict(() {
      districtName.value = districts[index].name.toString();
    });
  }

  void addError({required String error, state}) {
    if (!errors.contains(error)) state(() => errors.add(error));
  }

  void removeError({required String error, state}) {
    if (errors.contains(error)) state(() => errors.remove(error));
  }

  Future<dynamic> onSaveShippingAddress({
    required String slug,
    required int quantity,
  }) async {
    departmentName.value == "Seleccione un departamento" ||
            departmentName.value == "Seleccione"
        ? addError(
            error: kDeparmentNullError,
          )
        : removeError(
            error: kDeparmentNullError,
          );

    provinceName.value == "Seleccione una provincia" ||
            provinceName.value == "Seleccione"
        ? addError(
            error: kProvinceNullError,
          )
        : removeError(
            error: kProvinceNullError,
          );

    districtName.value == "Seleccione un distrito" ||
            districtName.value == "Seleccione"
        ? addError(
            error: kDistrictNullError,
          )
        : removeError(
            error: kDistrictNullError,
          );

    if (errors.isEmpty) {
      ubigeo =
          "${departmentName.value} - ${provinceName.value} - ${districtName.value}";
      final userInformationLocal = UserInformationLocal(
        department: departmentName.value,
        province: provinceName.value,
        district: districtName.value,
        districtId: districtId,
        ubigeo: ubigeo,
      );

      hiveRepositoryInterface.save(
        containerName: "shipment",
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
      return null;
    }
  }

  Future<UserInformationLocal> loadShipmentResidence() async {
    return UserInformationLocal.fromMap(
      await hiveRepositoryInterface.read(
            containerName: "shipment",
            key: "residence",
          ) ??
          {
            "department": "Lima",
            "province": "Lima",
            "district": "Miraflores",
            "districtId": "61856a14587c82ef50c1b44b",
            "ubigeo": "Lima - Lima - Miraflores",
          },
    );
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
      headers[HttpHeaders.authorizationHeader] =
          "Bearer ${responseCredentials.token}";

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
      headers[HttpHeaders.authorizationHeader] =
          "Bearer ${responseCredentials.token}";
    }
  }

  void signOut() async {
    await hiveRepositoryInterface.remove(
      containerName: "authentication",
      key: "credentials",
    );

    credentials = dynamic;
    informationUser = dynamic;
    headers[HttpHeaders.authorizationHeader] = '';
    accountLoaded.value = LoadStatus.loading;

    notifyListeners();
  }

  Future<dynamic> fetchGetUserInformation() async {
    final response = await userRepositoryInterface.getInformationUser(
      headers: headers,
    );

    if (response is http.Response) {
      if (response.statusCode == 200) {
        final decodeResponse = json.decode(response.body);

        return UserInformation.fromMap(decodeResponse);
      }
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }
    }

    return false;
  }

  Future<dynamic> fetchGetShoppingCart({required String districtId}) async {
    final response = await cartRepositoryInterface.getShoppingCart(
      districtId: districtId,
      headers: headers,
    );

    if (response is http.Response) {
      if (response.statusCode == 200) {
        final decodeResponse = json.decode(response.body);

        return Cart.fromMap(decodeResponse);
      }
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }
    }

    return false;
  }

  // TODO: Solo se trabajara en el Main Screen
  // void loadUserInformation() async {
  //   final response = await userRepositoryInterface.getInformationUser(
  //     headers: headers,
  //   );
  //
  //   if (response is http.Response) {
  //     if (response.statusCode == 200) {
  //       final decodeResponse = json.decode(response.body);
  //       // if (kDebugMode) {
  //       //   print(decodeResponse);
  //       // }
  //
  //       informationUser = UserInformation.fromMap(decodeResponse);
  //       print("Quiere informat");
  //       accountLoaded.value = LoadStatus.normal;
  //     }
  //   } else if (response is String) {
  //     if (kDebugMode) {
  //       print(response);
  //     }
  //   }
  // }

  void refreshMainBloc() {
    notifyListeners();
  }
}
