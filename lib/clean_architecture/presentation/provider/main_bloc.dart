import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/cart.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/credentials_auth.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/district.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/province.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/region.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/user_information_local.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/cart_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/local_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/product_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/login/login_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/product/product_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';

import '../../helper/http_response.dart';

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

  // ValueNotifier<ShoppingCart> shoppingCart =
  //     ValueNotifier(ShoppingCart.inactive);

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
  String districtId = "61856a14587c82ef50c1b44b";

  String ubigeo = "";

  int countNavigateIterationScreen = 3;
  bool loadingScreenAccount = false;

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
          if (informationCart.value is! Cart) {
            await getShoppingCartTemp(context: context);
            return;
          }
        } else {
          if (informationCart.value is! Cart) {
            handleGetShoppingCart(context);
            return;
          }
        }
      }

      if (indexSelected.value == 2) {
        if (credentials is! CredentialsAuth) {
          handleAuthAccess(context);
          return;
        }

        if (informationUser is! UserInformation) {
          loadingScreenAccount = true;

          handleLoadUserInformation(context);
        }

        return;
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

  void initRegion(BuildContext context) async {
    final responseApi = await localRepositoryInterface.getRegions();

    if (responseApi.data == null) {
      print("No cargo las regiones");
      final statusCode = responseApi.error!.statusCode;
      if (statusCode == -1) {
        GlobalSnackBar.showWarningSnackBar(context, kNoInternet);
      }

      regions = [];
      extraRegions = [];
      return;
    }

    regions.addAll(
      (responseApi.data as List).map((x) => Region.fromMap(x)).toList(),
    );

    extraRegions.addAll(
      (responseApi.data as List).map((x) => Region.fromMap(x)).toList(),
    );
  }

  void onChangeRegion(
    BuildContext context, {
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

    final responseApi = await localRepositoryInterface.getProvinces(
      departmentId: departmentId,
    );

    if (responseApi.data == null) {
      final statusCode = responseApi.error!.statusCode;
      provinces = [];

      if (statusCode == 400) {
        final response = ResponseApi.fromMap(responseApi.error!.data);
        GlobalSnackBar.showWarningSnackBar(context, response.message);
        return;
      }

      GlobalSnackBar.showWarningSnackBar(
        context,
        "No pudimos cargar la información, vuelva a intentarlo más tarde.",
      );
      return;
    }

    provinces.addAll(
      (responseApi.data as List)
          .map((element) => Province.fromMap(element))
          .toList(),
    );

    departmentName.value = regions[index].name.toString();
    provinceName.value = "Seleccione";
    districtName.value = "Seleccione";
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

    provinceId = provinces[index].provinceId.toString();
    final responseApi =
        await localRepositoryInterface.getDistricts(provinceId: provinceId);

    if (responseApi.data == null) {
      final statusCode = responseApi.error!.statusCode;
      if (statusCode == -1) {
        GlobalSnackBar.showWarningSnackBar(context, kNoInternet);
      }

      districts = [];
      return;
    }

    districts.addAll(
      (responseApi.data as List)
          .map((element) => District.fromMap(element))
          .toList(),
    );

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

    districtId = districts[index].id!;
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

  void onSubmitShippingAddress(
    BuildContext context, {
    required String slug,
    required int quantity,
  }) async {
    final productBloc = context.read<ProductBloc>();

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

      final responseApi = await productRepositoryInterface.getShipmentPriceCost(
        slug: slug,
        districtId: districtId,
        quantity: quantity,
      );

      if (responseApi.data == null) {
        GlobalSnackBar.showWarningSnackBar(context, kOtherProblem);
        return;
      }

      final shippingPrice = double.parse(responseApi.data.replaceAll('"', ""));

      productBloc.shippingPrice.value = shippingPrice;
      productBloc.refreshUbigeo(context, slug: productBloc.product!.slug!);

      GlobalSnackBar.showInfoSnackBarIcon(
        context,
        'Dirección guardada correctamente',
      );

      Navigator.of(context).pop();
      return;
    }
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

    if (responseCredentials.token.isEmpty) return false;

    credentials = responseCredentials;
    headers[HttpHeaders.authorizationHeader] =
        "Bearer ${responseCredentials.token}";

    return true;
  }

  Future<CredentialsAuth> loadCredentialsAuth() async {
    return await Future.microtask(
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

      sessionAccount.value = Session.active;
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

    // await hiveRepositoryInterface.remove(
    //   containerName: "shopping_temporal",
    //   key: "cartId",
    // );

    credentials = dynamic;
    informationCart.value = dynamic;
    informationUser = dynamic;
    headers[HttpHeaders.authorizationHeader] = '';
    sessionAccount.value = Session.inactive;
    account.value = Account.inactive;

    notifyListeners();
  }

  void handleLoadUserInformation(BuildContext context) async {
    final responseApi = await userRepositoryInterface.getInformationUser(
      headers: headers,
    );

    if (responseApi.data == null) {
      final statusCode = responseApi.error!.statusCode;
      if (statusCode == 400) {
        final response = ResponseApi.fromMap(responseApi.error!.data);
        GlobalSnackBar.showWarningSnackBar(context, response.message);
        return;
      }

      GlobalSnackBar.showWarningSnackBar(
        context,
        "Ups tenemos problemas, vuelva a intentarlo más tarde.",
      );

      return;
    }

    final response = UserInformation.fromMap(responseApi.data);
    informationUser = response;

    account.value = Account.active;
    sessionAccount.value = Session.active;
    loadingScreenAccount = false;

    GlobalSnackBar.showInfoSnackBarIcon(
      context,
      "Información actualizada.",
    );

    refreshMainBloc();
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

  Future<dynamic> getShoppingCartTemp({
    required BuildContext context,
  }) async {
    final shoppingCartId = await handleGetShoppingCartId();

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Custom-Origin": "app",
      'Custom-Cart': shoppingCartId
    };

    final responseApi = await cartRepositoryInterface.getShoppingCartTemp(
      districtId: residence.districtId!,
      headers: headers,
    );

    if (responseApi.data == null) {
      final statusCode = responseApi.error!.statusCode;

      if (statusCode == -1) {
        GlobalSnackBar.showErrorSnackBarIcon(
          context,
          "Compruebe su conexion a internet",
        );
        return;
      }

      GlobalSnackBar.showErrorSnackBarIcon(
        context,
        "Ups tuvimos problemas, vuelva a intentarlo más tarde",
      );
      return;
    }

    final cartInfo = Cart.fromMap(responseApi.data);

    if (shoppingCartId.toString().isEmpty) {
      await hiveRepositoryInterface.save(
        containerName: "shopping_temporal",
        key: "cartId",
        value: cartInfo.id,
      );
    }

    cartLength.value = cartInfo.products!.length;
    informationCart.value = cartInfo;
  }

  Future<void> handleGetShoppingCart(BuildContext context) async {
    final responseApi = await cartRepositoryInterface.getShoppingCart(
      districtId: districtId,
      headers: headers,
    );

    if (responseApi.data == null) {
      final statusCode = responseApi.error!.statusCode;

      if (statusCode == -1) {
        GlobalSnackBar.showErrorSnackBarIcon(
          context,
          "Compruebe su conexion a internet",
        );
        return;
      }

      GlobalSnackBar.showErrorSnackBarIcon(
        context,
        "Ups tuvimos problemas, vuelva a intentarlo más tarde",
      );
      return;
    }

    final cartInfo = Cart.fromMap(responseApi.data);

    informationCart.value = cartInfo;
    cartLength.value = cartInfo.products!.length;
  }

  void moveShoppingCart(BuildContext context) async {
    final shoppingCartId = await handleGetShoppingCartId();

    final responseApi = await cartRepositoryInterface.moveShoppingCart(
      cartId: shoppingCartId,
      headers: headers,
    );

    if (responseApi.data == null) {
      // GlobalSnackBar.showInfoSnackBarIcon(
      //   context,
      //   'Ups tenemos problemas, vuelva a intentarlo más tarde.',
      // );
      return;
    }

    // final response = ResponseApi.fromMap(responseApi.data);
    //
    // GlobalSnackBar.showInfoSnackBarIcon(
    //   context,
    //   response.message,
    // );
  }

  Future<void> handleRemoveShoppingCart() async {
    await hiveRepositoryInterface.remove(
      containerName: "shopping_temporal",
      key: "cartId",
    );
  }

  void deleteItemShoppingCart({
    required String variationId,
    required String productId,
    required BuildContext context,
  }) async {
    final HttpResponse responseApi;
    context.loaderOverlay.show();
    if (sessionAccount.value == Session.active) {
      responseApi = await cartRepositoryInterface.deleteProductCart(
        productId: productId,
        variationId: variationId,
        headers: headers,
      );
    } else {
      responseApi = await cartRepositoryInterface.deleteProductCartTemp(
        cartId: informationCart.value.id!,
        variationId: variationId,
        productId: productId,
      );
    }

    context.loaderOverlay.hide();
    if (responseApi.data == null) {
      final statusCode = responseApi.error!.statusCode;
      if (statusCode >= 400) {
        if (statusCode == 400) {
          final response = ResponseApi.fromMap(responseApi.error!.data);
          GlobalSnackBar.showErrorSnackBarIcon(
            context,
            response.message,
          );
        }

        return;
      }

      GlobalSnackBar.showErrorSnackBarIcon(
        context,
        "Tuvimos problemas, vuelva a intentarlo más tarde.",
      );
      return;
    }

    final response = ResponseApi.fromMap(responseApi.data);
    handleShoppingCart(context);
    GlobalSnackBar.showInfoSnackBarIcon(
      context,
      response.message,
    );
  }

  void handleShoppingCart(BuildContext context) async {
    if (sessionAccount.value == Session.active) {
      await handleGetShoppingCart(context);
      return;
    }

    await getShoppingCartTemp(context: context);
  }

  void changeQuantity({
    required String productId,
    required int quantity,
    required String variationId,
    required BuildContext context,
  }) async {
    final HttpResponse responseApi;
    context.loaderOverlay.show();
    if (sessionAccount.value == Session.active) {
      responseApi = await cartRepositoryInterface.updateProductCart(
        productId: productId,
        variationId: variationId,
        quantity: quantity,
        headers: headers,
      );
    } else {
      final shoppingCartId = await handleGetShoppingCartId();

      responseApi = await cartRepositoryInterface.updateProductCartTemp(
        cartId: shoppingCartId,
        productId: productId,
        variationId: variationId,
        quantity: quantity,
      );
    }

    context.loaderOverlay.hide();
    if (responseApi.data == null) {
      final statusCode = responseApi.error!.statusCode;
      if (statusCode >= 400) {
        if (statusCode == 400) {
          final response = ResponseApi.fromMap(responseApi.error!.data);
          GlobalSnackBar.showErrorSnackBarIcon(
            context,
            response.message,
          );
        }

        return;
      }

      GlobalSnackBar.showErrorSnackBarIcon(
        context,
        "Tuvimos problemas, vuelva a intentarlo más tarde.",
      );
      return;
    }

    final response = ResponseApi.fromMap(responseApi.data);
    handleShoppingCart(context);
    GlobalSnackBar.showInfoSnackBarIcon(
      context,
      response.message,
    );
  }

  Future<String> handleGetShoppingCartId() async {
    return await hiveRepositoryInterface.read(
          containerName: "shopping_temporal",
          key: "cartId",
        ) ??
        "";
  }
}
