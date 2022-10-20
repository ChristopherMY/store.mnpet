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
import 'package:store_mundo_pet/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information_local.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/cart_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/local_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/product_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/login/login_screen.dart';

class MainBloc extends ChangeNotifier {
  LocalRepositoryInterface localRepositoryInterface;
  HiveRepositoryInterface hiveRepositoryInterface;
  ProductRepositoryInterface productRepositoryInterface;
  UserRepositoryInterface userRepositoryInterface;
  CartRepositoryInterface cartRepositoryInterface;

  MainBloc({
    required this.localRepositoryInterface,
    required this.hiveRepositoryInterface,
    required this.productRepositoryInterface,
    required this.userRepositoryInterface,
    required this.cartRepositoryInterface,
  });

  ValueNotifier<Session> sessionAccount = ValueNotifier(Session.inactive);
  ValueNotifier<Account> account = ValueNotifier(Account.inactive);
  ValueNotifier<Home> home = ValueNotifier(Home.inactive);
  ValueNotifier<ShoppingCart> shoppingCart =
      ValueNotifier(ShoppingCart.inactive);

  ValueNotifier<int> indexSelected = ValueNotifier(0);

  ValueNotifier<int> cartLength = ValueNotifier(0);

  List<Region> extraRegions = List.of(<Region>[]);
  List<Region> regions = List.of(<Region>[]);
  List<Province> provinces = <Province>[];
  List<District> districts = <District>[];

  ValueNotifier<List<String>> errors = ValueNotifier([]);

  ValueNotifier<String> departmentName =
      ValueNotifier("Seleccione un departamento");
  String departmentId = "";

  ValueNotifier<String> provinceName =
      ValueNotifier("Seleccione una provincia");
  String provinceId = "";

  ValueNotifier<String> districtName = ValueNotifier("Seleccione un distrito");
  String districtId = "";

  String ubigeo = "";

  int countNavigateIterationScreen = 3;

  dynamic informationUser;
  ValueNotifier<dynamic> informationCart = ValueNotifier(dynamic);
  dynamic residence;
  dynamic credentials;

  Map<String, String> headers = {
    "Content-type": "application/json",
    "Custom-Origin": "app",
  };

  void onChangeIndexSelected({
    required int index,
    required BuildContext context,
  }) async {
    if (indexSelected.value != index) {
      indexSelected.value = index;

      if (indexSelected.value == 0) {
        return;
      }

      if (indexSelected.value == 1) {
        if (credentials is! CredentialsAuth) {
          //  sessionAccount.value = Session.inactive;
          if (informationCart.value is! Cart) {
            handleGetShoppingCartNotAccount();
            return;
          }
        } else {
          if (informationCart.value is! Cart) {
            handleGetShoppingCart();
            return;
          }
        }
      }

      if (indexSelected.value == 2) {
        if (credentials is! CredentialsAuth) {
          handleAuthAccess(context);

          return;
        } else {
          if (informationUser is! UserInformation) {
            getUserInformation().then(
              (loadInformation) {
                if (loadInformation is UserInformation) {
                  informationUser = loadInformation;
                }

                account.value = Account.active;
              },
            );
          }

          return;
        }
      }
    }
  }

  void handleAuthAccess(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => const LoginScreen()),
      ),
    );
  }

  void initRegion() async {
    final response = await localRepositoryInterface.getRegions();

    if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      regions = [];
      extraRegions = [];
      return;
    }

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

    final response = await localRepositoryInterface.getProvinces(
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
        await localRepositoryInterface.getDistricts(provinceId: provinceId);

    if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      districts = [];
    }

    if (response is http.Response) {
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        districts.addAll(
          data.map((element) => District.fromMap(element)).toList().cast(),
        );
      } else {
        districts = [];
      }
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

    if (errors.value.isEmpty) {
      ubigeo =
          "${departmentName.value} - ${provinceName.value} - ${districtName.value}";
      final userInformationLocal = UserInformationLocal(
        department: departmentName.value,
        province: provinceName.value,
        district: districtName.value,
        districtId: districtId,
        ubigeo: ubigeo,
      );

      await hiveRepositoryInterface.save(
        containerName: "shipment",
        key: "residence",
        value: userInformationLocal.toMap(),
      );

      final response = await productRepositoryInterface.getShipmentPriceCost(
        slug: slug,
        districtId: districtId,
        quantity: quantity,
      );

      if (response is String) {
        if (kDebugMode) {
          print(response);
        }

        return null;
      }

      if (response is http.Response) {
        if (response.statusCode == 200) {
          return double.parse(response.body.replaceAll('"', ""));
        } else {
          return null;
        }
      }
    }

    return null;
  }

  Future<bool> loadSessionPromise() async {
    final responseCredentials = await Future.microtask(
      () async {
        return CredentialsAuth.fromMap(
          await hiveRepositoryInterface.read(
                containerName: "authentication",
                key: "credentials",
              ) ??
              {"email": "", "email_confirmed": false, "token": ""},
        );
      },
    );

    if (responseCredentials.token.isEmpty) {
      return false;
    }

    credentials = responseCredentials;
    headers[HttpHeaders.authorizationHeader] =
        "Bearer ${responseCredentials.token}";

    return true;
  }

// TODO: Solo se trabajara en el Main Screen
  Future<void> handleLoadSession() async {
    final responseCredentials = await Future.microtask(
      () async {
        return CredentialsAuth.fromMap(
          await hiveRepositoryInterface.read(
                containerName: "authentication",
                key: "credentials",
              ) ??
              {
                "email": "",
                "email_confirmed": false,
                "token": "",
              },
        );
      },
    );

    if (responseCredentials.token.isNotEmpty) {
      credentials = responseCredentials;
      headers[HttpHeaders.authorizationHeader] =
          "Bearer ${responseCredentials.token}";

      // sessionAccount.value = Session.active;
    }
  }

  void signOut() async {
    await hiveRepositoryInterface.remove(
      containerName: "authentication",
      key: "credentials",
    );

    await hiveRepositoryInterface.remove(
      containerName: "shipment",
      key: "residence",
    );

    credentials = dynamic;
    informationCart.value = dynamic;
    informationUser = dynamic;
    headers[HttpHeaders.authorizationHeader] = '';
    sessionAccount.value = Session.inactive;
    account.value = Account.inactive;
  }

  Future<dynamic> getUserInformation() async {
    final response = await userRepositoryInterface.getInformationUser(
      headers: headers,
    );

    if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      return false;
    }

    if (response is! http.Response) {
      return false;
    }

    if (response.statusCode != 200) {
      return false;
    }

    final decodeResponse = json.decode(response.body);
    return UserInformation.fromMap(decodeResponse);
  }

  void refreshMainBloc() {
    notifyListeners();
  }

  void handleLoadShipmentResidence() async {
    residence = await Future.microtask(
      () async {
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
      },
    );
  }

  Future<dynamic> getShoppingCart({
    required String districtId,
    required Map<String, String> headers,
  }) async {
    final response = await cartRepositoryInterface.getShoppingCart(
      districtId: districtId,
      headers: headers,
    );

    if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      return false;
    }

    if (response is! http.Response) {
      return false;
    }

    if (response.statusCode != 200) {
      return false;
    }

    final decodeResponse = jsonDecode(response.body);
    return Cart.fromMap(decodeResponse);
  }

  Future<dynamic> getShoppingCartTemp({
    required String districtId,
  }) async {
    final shoppingCartId = await handleGetShoppingCartId();

    Map<String, String> headers = {'Custom-Cart': shoppingCartId};

    final response = await cartRepositoryInterface.getShoppingCartTemp(
      districtId: districtId,
      headers: headers,
    );

    if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      return false;
    }

    if (response is! http.Response) {
      return false;
    }

    if (response.statusCode != 200) {
      return false;
    }

    final decodeResponse = jsonDecode(response.body);
    return Cart.fromMap(decodeResponse);
  }

  void handleGetShoppingCartNotAccount() async {
    final shoppingCartId = await handleGetShoppingCartId();

    getShoppingCartTemp(
      districtId: residence.districtId!,
    ).then(
      (cart) async {
        if (cart is Cart) {
          if (shoppingCartId.toString().isEmpty) {
            await hiveRepositoryInterface.save(
              containerName: "shopping",
              key: "cartId",
              value: cart.id,
            );
          }

          cartLength.value = cart.products!.length;
          informationCart.value = cart;
        }

        shoppingCart.value = ShoppingCart.active;
      },
    );
  }

  Future<void> handleGetShoppingCart() async {
    getShoppingCart(
      districtId: residence.districtId!,
      headers: headers,
    ).then(
      (cart) {
        if (cart is Cart) {
          informationCart.value = cart;
          cartLength.value = cart.products!.length;
        }

        shoppingCart.value = ShoppingCart.active;
      },
    );
  }

  Future<dynamic> changeShoppingCart() async {
    final shoppingCartId = await handleGetShoppingCartId();

    final response = await cartRepositoryInterface.moveShoppingCart(
      cartId: shoppingCartId,
      headers: headers,
    );

    if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      return false;
    }

    if (response is http.Response) {
      if (response.statusCode == 200) {
        return responseApiFromMap(response.body);
      }
    }
  }

  Future<void> handleRemoveShoppingCart() async {
    await hiveRepositoryInterface.remove(
      containerName: "shopping",
      key: "cartId",
    );
  }

  Future<dynamic> deleteItemShoppingCart({
    required String variationId,
    required String productId,
  }) async {
    dynamic response;
    if (sessionAccount.value == Session.active) {
      response = await cartRepositoryInterface.deleteProductCart(
        productId: productId,
        variationId: variationId,
        headers: headers,
      );
    } else {
      response = await cartRepositoryInterface.deleteProductCartTemp(
        cartId: informationCart.value.id!,
        variationId: variationId,
        productId: productId,
      );
    }

    if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      return false;
    }

    if (response is http.Response) {
      if (response.statusCode == 200) {
        return responseApiFromMap(response.body);
      }
    }
  }

  Future<void> handleFnShoppingCart({bool enableLoader = false}) async {
    if (sessionAccount.value == Session.active) {
      final cart = await getShoppingCart(
        districtId: residence.districtId!,
        headers: headers,
      );

      if (cart is Cart) {
        informationCart.value = cart;
        cartLength.value = cart.products!.length;
      }

      return;
    }

    /// Continue computing execution code

    final shoppingCartId = await handleGetShoppingCartId();

    final cart = await getShoppingCartTemp(
      districtId: residence.districtId!,
    );

    print("RESOLVIO!!!");
    print("Cart");
    print(cart);

    if (cart is Cart) {
      print(cart.toMap());
      if (shoppingCartId.toString().isEmpty) {
        await hiveRepositoryInterface.save(
          containerName: "shopping",
          key: "cartId",
          value: cart.id,
        );
      }

      cartLength.value = cart.products!.length;
      informationCart.value = cart;
    }
  }

  Future<dynamic> changeQuantity({
    required String productId,
    required int quantity,
    required String variationId,
  }) async {
    dynamic response;
    if (sessionAccount.value == Session.active) {
      response = await cartRepositoryInterface.updateProductCart(
        productId: productId,
        variationId: variationId,
        quantity: quantity,
        headers: headers,
      );
    } else {
      final shoppingCartId = await handleGetShoppingCartId();

      response = await cartRepositoryInterface.updateProductCartTemp(
        cartId: shoppingCartId,
        productId: productId,
        variationId: variationId,
        quantity: quantity,
      );
    }

    if (response is http.Response) {
      if (response.statusCode == 200) {
        return responseApiFromMap(response.body);
      }
    }

    return false;
  }

  Future<String> handleGetShoppingCartId() async {
    return await hiveRepositoryInterface.read(
          containerName: "shopping",
          key: "cartId",
        ) ??
        "";
  }


}
