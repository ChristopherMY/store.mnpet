import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/cart.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/mercado_pago_payment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/mercado_pago_payment_method_installments.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/tab_payment_page.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/local_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/payment_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/cart/cart_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/checkout_info/checkout_info_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/checkout_info/components/transaction_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/phone/phone_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/search_keyword/search_keyword_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/shipment/shipment_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/dialog_helper.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/button_crud.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/copy_right.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/default_button.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/expandable_page_view.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/loading_bag_full_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/lottie_animation.dart';

import '../../../domain/model/credit_card_brand.dart';
import '../../../domain/model/custom_card_type_icon.dart';
import '../../../domain/usecase/page.dart';
import '../../util/glassmorphism_config.dart';
import '../../widget/credit_card_form.dart';
import '../../widget/credit_card_widget.dart';
import '../../../helper/http_response.dart';

class CheckoutInfoScreen extends StatefulWidget {
  const CheckoutInfoScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider<CartBloc>.value(
      value: Provider.of<CartBloc>(context, listen: false),
      child: ChangeNotifierProvider<CheckOutInfoBloc>(
        create: (context) => CheckOutInfoBloc(
          paymentRepositoryInterface:
              context.read<PaymentRepositoryInterface>(),
          hiveRepositoryInterface: context.read<HiveRepositoryInterface>(),
        )..getIdentificationTypes(context),
        builder: (_, __) => const CheckoutInfoScreen._(),
      ),
    );
  }

  @override
  State<CheckoutInfoScreen> createState() => _CheckoutInfoScreenState();
}

class _CheckoutInfoScreenState extends State<CheckoutInfoScreen> {
  void handleUserInformation() async {
    final mainBloc = context.read<MainBloc>();
    if (mainBloc.informationUser is! UserInformation) {
      mainBloc.handleLoadUserInformation(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    handleUserInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.watch<MainBloc>();

    if (mainBloc.informationUser is UserInformation) {
      final checkoutInfoBloc = context.watch<CheckOutInfoBloc>();

      return LoaderOverlay(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            bottomOpacity: 0.0,
            elevation: 0.0,
            backgroundColor: kBackGroundColor,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: kBackGroundColor,
              statusBarIconBrightness: Brightness.dark,
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black12,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 20.0,
                  ),
                ),
              ),
            ),
            centerTitle: false,
            title: Text(
              "Pago",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return SearchKeywordScreen.init(context);
                      },
                    ),
                  );
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.black12,
                  child: Icon(
                    CommunityMaterialIcons.magnify,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 15.0),
            ],
            leadingWidth: 55.0,
          ),
          backgroundColor: kBackGroundColor,
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ExpandablePageView(
                          controller: checkoutInfoBloc.pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: const <Widget>[
                            OrderCheckoutScreen(),
                            PaymentCheckoutScreen(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  width: SizeConfig.screenWidth!,
                  child: ValueListenableBuilder(
                    valueListenable: mainBloc.informationCart,
                    builder: (_, cart, __) {
                      if (cart is Cart) {
                        return Column(
                          children: [
                            SizedBox(
                              width: SizeConfig.screenWidth!,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 15.0,
                                  right: 10.0,
                                ),
                                child: ValueListenableBuilder(
                                  valueListenable:
                                      checkoutInfoBloc.tabsPaymentPage,
                                  builder: (
                                    _,
                                    List<TabPaymentPage> tabsPaymentPage,
                                    __,
                                  ) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: List.generate(
                                        tabsPaymentPage.length,
                                        (index) {
                                          final tabPaymentPage =
                                              tabsPaymentPage[index];
                                          return _TabPaymentPage(
                                            onTap: () async {
                                              dynamic existsDefaultAddress;
                                              dynamic existsDefaultPhone;

                                              if (mainBloc.informationUser
                                                  is UserInformation) {
                                                UserInformation userInfo =
                                                    mainBloc.informationUser;
                                                List<Address> addresses =
                                                    userInfo.addresses ?? [];
                                                List<Phone> phones =
                                                    userInfo.phones ?? [];

                                                if (addresses.isNotEmpty) {
                                                  existsDefaultAddress =
                                                      addresses.firstWhereOrNull(
                                                          (element) =>
                                                              element
                                                                  .addressDefault ==
                                                              true);
                                                }

                                                if (phones.isNotEmpty) {
                                                  existsDefaultPhone = phones
                                                      .firstWhereOrNull(
                                                          (element) =>
                                                              element
                                                                  .phoneDefault ==
                                                              true);
                                                }
                                              }

                                              if (existsDefaultAddress !=
                                                      null &&
                                                  existsDefaultAddress
                                                      is Address &&
                                                  existsDefaultPhone != null &&
                                                  existsDefaultPhone is Phone) {
                                                await Future.value(
                                                  checkoutInfoBloc
                                                      .pageController
                                                      .animateToPage(
                                                    checkoutInfoBloc
                                                        .pageController.page!
                                                        .toInt(),
                                                    duration: const Duration(
                                                        milliseconds: 400),
                                                    curve: Curves.easeIn,
                                                  ),
                                                );

                                                checkoutInfoBloc
                                                    .handleChangeTabPaymentPage(
                                                        index);
                                                return;
                                              }

                                              GlobalSnackBar
                                                  .showWarningSnackBar(
                                                context,
                                                "Complete los datos para continuar",
                                              );
                                            },
                                            tabPaymentPage: tabPaymentPage,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Container(
                              color: kPrimaryColor,
                              child: GestureDetector(
                                onTap: () {
                                  checkoutInfoBloc.isExpanded =
                                      !checkoutInfoBloc.isExpanded;
                                  checkoutInfoBloc.refresh();
                                },
                                child: AnimatedCrossFade(
                                  firstChild: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 15.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Total",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          "S/ ${parseDouble(cart.total!)}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  secondChild: Column(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(width: 1),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                            horizontal: 15.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Total",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                "S/ ${parseDouble(cart.total!)}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                          vertical: 15.0,
                                        ),
                                        child: Column(
                                          children: [
                                            RowDetailPriceInfo(
                                              title: "Subtotal",
                                              price:
                                                  parseDouble(cart.subTotal!),
                                              fontSize: 12,
                                              verticalPadding: 5.0,
                                            ),
                                            _divider(),
                                            RowDetailPriceInfo(
                                              title: "Envío",
                                              price:
                                                  parseDouble(cart.shipment!),
                                              fontSize: 12,
                                              verticalPadding: 5.0,
                                            ),
                                            _divider(),
                                            RowDetailPriceInfo(
                                              title: "Total",
                                              price: parseDouble(cart.total!),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              verticalPadding: 5.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  crossFadeState: checkoutInfoBloc.isExpanded
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                                  duration: kThemeAnimationDuration,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: SizeConfig.screenHeight! - SizeConfig.screenHeight! * 0.923,
            decoration: const BoxDecoration(
              color: kPrimaryColor,
              border: Border(
                top: BorderSide(width: 1),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: DefaultButton(
                text: 'Continuar',
                color: Colors.white,
                colorText: Colors.black,
                press: () async {
                  dynamic existsDefaultAddress;
                  dynamic existsDefaultPhone;

                  if (mainBloc.informationUser is UserInformation) {
                    UserInformation userInfo = mainBloc.informationUser;
                    List<Address> addresses = userInfo.addresses ?? [];
                    List<Phone> phones = userInfo.phones ?? [];

                    switch (checkoutInfoBloc.pageController.page!.toInt()) {
                      case 0:
                        {
                          if (addresses.isNotEmpty) {
                            existsDefaultAddress = addresses.firstWhereOrNull(
                                (element) => element.addressDefault == true);
                          }

                          if (phones.isNotEmpty) {
                            existsDefaultPhone = phones.firstWhereOrNull(
                                (element) => element.phoneDefault == true);
                          }

                          if (existsDefaultAddress != null &&
                              existsDefaultAddress is Address &&
                              existsDefaultPhone != null &&
                              existsDefaultPhone is Phone) {
                            checkoutInfoBloc.handleChangeTabPaymentPage(1);

                            await Future.value(
                              checkoutInfoBloc.pageController.animateToPage(
                                checkoutInfoBloc.pageController.page!.toInt() +
                                    1,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeIn,
                              ),
                            );
                            return;
                          }

                          GlobalSnackBar.showWarningSnackBar(
                            context,
                            "Complete los datos para continuar",
                          );
                        }
                        break;
                      case 1:
                        {
                          if (checkoutInfoBloc.formKey.currentState!
                              .validate()) {
                            checkoutInfoBloc.formKey.currentState!.save();

                            if (mainBloc.informationCart.value is Cart) {
                              context.loaderOverlay.show();
                              final responseApi = await checkoutInfoBloc.handlePayment(
                                cartInformation: mainBloc.informationCart.value,
                                userInformation: mainBloc.informationUser,
                                context: context,
                              );

                              if (!mounted) return;

                              if (responseApi is! HttpResponse) {
                                context.loaderOverlay.hide();
                                GlobalSnackBar.showWarningSnackBar(context, kOtherProblem);
                                return;
                              }

                              if(responseApi.data == null){
                                final statusCode = responseApi.error!.statusCode;
                                final data = responseApi.error!.data;

                                context.loaderOverlay.hide();
                                if(statusCode == 402){
                                  final response = ResponseApi.fromMap(responseApi.error!.data);
                                  GlobalSnackBar.showWarningSnackBar(context, response.message);
                                  return;
                                }

                                if(statusCode == 400){
                                  if (data['error']['status'] == 400) {
                                    final errorText = checkoutInfoBloc.badRequestProcess(data);

                                    context.loaderOverlay.hide();
                                    GlobalSnackBar.showErrorSnackBarIcon(
                                      context,
                                      errorText,
                                    );

                                    return;
                                  }

                                  GlobalSnackBar.showWarningSnackBar(context, kOtherProblem);
                                  return;
                                }

                                if (checkoutInfoBloc.installmentsDetail is! MercadoPagoPaymentMethodInstallments) {
                                  context.loaderOverlay.hide();
                                  GlobalSnackBar.showWarningSnackBar(
                                    context,
                                    kOtherProblem,
                                  );

                                  return;
                                }

                                if (statusCode != 400) {
                                  final errorText =
                                  checkoutInfoBloc.badTokenProcess(
                                    status: data['status'],
                                    installments:
                                    checkoutInfoBloc.installmentsDetail,
                                  );

                                  GlobalSnackBar.showErrorSnackBarIcon(
                                    context,
                                    errorText,
                                  );

                                  return;
                                }

                                GlobalSnackBar.showWarningSnackBar(context, kOtherProblem);
                                return;
                              }

                              MercadoPagoPayment infoPayment = MercadoPagoPayment.fromJsonMap(responseApi.data);
                              context.loaderOverlay.hide();
                              if (infoPayment.status == "rejected") {
                                final errorDescription = statusDetailName(
                                    statusDetail: infoPayment.statusDetail!);
                                GlobalSnackBar.showErrorSnackBarIcon(
                                  context,
                                  errorDescription!,
                                );
                                return;
                              }

                              if (infoPayment.statusDetail == "accredited") {
                                await mainBloc.handleGetShoppingCart(context);

                                await Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => TransactionScreen(
                                      mercadoPagoPayment: infoPayment,
                                    ),
                                  ),
                                );
                              }

                            }
                          }

                          /// END IF VALIDATION FORM
                        }
                        break;
                      default:
                        GlobalSnackBar.showWarningSnackBar(
                          context,
                          kOtherProblem,
                        );
                    }
                  }
                },
              ),
            ),
          ),
        ),
      );
    } else {
      return const LoadingBagFullScreen();
    }
  }

  _divider() {
    return const Divider(
      thickness: 1.5,
      color: kBackGroundColor,
    );
  }
}

class RowDetailPriceInfo extends StatelessWidget {
  const RowDetailPriceInfo({
    Key? key,
    required this.title,
    required this.price,
    this.fontWeight = FontWeight.w400,
    required this.fontSize,
    required this.verticalPadding,
  }) : super(key: key);

  final String title;
  final String price;
  final FontWeight fontWeight;
  final double fontSize;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: verticalPadding),
      child: DefaultTextStyle(
        style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text("S/ $price"),
          ],
        ),
      ),
    );
  }
}

class OrderCheckoutScreen extends StatelessWidget {
  const OrderCheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Información de envío",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 8.0),
              Text(
                "* Se debe de mantener un registro como principal",
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(20.0)),
          _OrderCheckoutShipping.init(context),
          SizedBox(height: getProportionateScreenHeight(15.0)),
          _OrderCheckoutShippingPhone.init(context),
        ],
      ),
    );
  }
}

class _OrderCheckoutShipping extends StatefulWidget {
  const _OrderCheckoutShipping._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ShipmentBloc(
        localRepositoryInterface: context.read<LocalRepositoryInterface>(),
        userRepositoryInterface: context.read<UserRepositoryInterface>(),
      ),
      builder: (_, __) => const _OrderCheckoutShipping._(),
    );
  }

  @override
  State<_OrderCheckoutShipping> createState() => _OrderCheckoutShippingState();
}

class _OrderCheckoutShippingState extends State<_OrderCheckoutShipping> {
  @override
  Widget build(BuildContext context) {
    final shipmentBloc = context.watch<ShipmentBloc>();
    final mainBloc = context.watch<MainBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 190,
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: mainBloc.informationUser!.addresses.length > 0
                  ? ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(0),
                      children: List.generate(
                        mainBloc.informationUser!.addresses.length,
                        (index) {
                          final address =
                              mainBloc.informationUser!.addresses[index]!;
                          return SizedBox(
                            width: SizeConfig.screenWidth! -
                                SizeConfig.screenWidth! * 0.13,
                            child: Card(
                              color: Colors.white,
                              // margin: const EdgeInsets.all(5.0),
                              elevation: 1,
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(address.addressType!),
                                        Container(
                                          clipBehavior: Clip.hardEdge,
                                          width: 25.0,
                                          height: 25.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: address!.addressDefault!
                                                ? Colors.green
                                                : Colors.white,
                                            border: Border.all(width: 0.5),
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            size: 15.0,
                                            color: address!.addressDefault!
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      "${address.ubigeo!.department} - ${address.ubigeo!.province} - ${address.ubigeo!.district}",
                                    ),
                                    const SizedBox(height: 5.0),
                                    Expanded(
                                      child: Text(address.direction!),
                                    ),
                                    Row(
                                      children: [
                                        const Spacer(),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                shipmentBloc.isUpdate = true;
                                                shipmentBloc.address = address;

                                                await DialogHelper
                                                    .showAddressDialog(
                                                        context: context);
                                              },
                                              child: const CircleAvatar(
                                                radius: 15.0,
                                                backgroundColor: Colors.black,
                                                child: Icon(
                                                  CommunityMaterialIcons
                                                      .pencil_outline,
                                                  size: 18.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5.0),
                                            GestureDetector(
                                              onTap: () {
                                                shipmentBloc.onDeleteAddress(
                                                  context,
                                                  addressId: address.id!,
                                                  headers: mainBloc.headers,
                                                );
                                              },
                                              child: const CircleAvatar(
                                                radius: 15.0,
                                                backgroundColor: Colors.black,
                                                child: Icon(
                                                  CommunityMaterialIcons
                                                      .trash_can_outline,
                                                  size: 18.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const LottieAnimation(
                      source: "assets/lottie/no_data_preview.json",
                    ),
            ),
          ),
        ),
        ButtonCrud(
          onTap: () async {
            shipmentBloc.isUpdate = false;
            // shipmentBloc.address = addressDefault;

            for (var type in shipmentBloc.addressTypes) {
              type['checked'] = false;
            }

            for (final region in mainBloc.extraRegions) {
              region.checked = false;
            }

            for (final district in mainBloc.districts) {
              district.checked = false;
            }

            for (final province in mainBloc.provinces) {
              province.checked = false;
            }

            //*****************************
            // Reset address
            //*****************************

            shipmentBloc.address = Address(
              ubigeo: Ubigeo(
                department: "Seleccione un departamento",
                province: "Seleccione una provincia",
                district: "Seleccione un distrito",
              ),
              addressType: "Seleccione un tipo",
              lotNumber: 1,
              dptoInt: 1,
              addressDefault: false,
            );

            await DialogHelper.showAddressDialog(context: context);
          },
          titleButton: "Añadir dirección",
        ),
      ],
    );
  }
}

class _OrderCheckoutShippingPhone extends StatefulWidget {
  const _OrderCheckoutShippingPhone._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PhoneBloc(
        localRepositoryInterface: context.read<LocalRepositoryInterface>(),
        userRepositoryInterface: context.read<UserRepositoryInterface>(),
      ),
      builder: (_, __) => const _OrderCheckoutShippingPhone._(),
    );
  }

  @override
  State<_OrderCheckoutShippingPhone> createState() =>
      _OrderCheckoutShippingPhoneState();
}

class _OrderCheckoutShippingPhoneState
    extends State<_OrderCheckoutShippingPhone> {
  @override
  Widget build(BuildContext context) {
    final phoneBloc = context.watch<PhoneBloc>();
    final mainBloc = context.watch<MainBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 135.0,
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: AnimatedSwitcher(
              duration: const Duration(microseconds: 500),
              child: mainBloc.informationUser.phones.length > 0
                  ? ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        mainBloc.informationUser.phones.length,
                        (index) {
                          final Phone phone =
                              mainBloc.informationUser.phones[index]!;

                          return SizedBox(
                            width: SizeConfig.screenWidth! -
                                SizeConfig.screenWidth! * 0.13,
                            child: Card(
                              color: Colors.white,
                              // margin: const EdgeInsets.all(5.0),
                              elevation: 2,
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Número de teléfono",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!,
                                              ),
                                              Container(
                                                clipBehavior: Clip.hardEdge,
                                                width: 25,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: phone.phoneDefault!
                                                      ? Colors.green
                                                      : Colors.white,
                                                  border:
                                                      Border.all(width: 0.5),
                                                ),
                                                child: Icon(
                                                  Icons.check,
                                                  size: 15.0,
                                                  color: phone.phoneDefault!
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5.0),
                                          Text(
                                              "+51 ${splitNumberJoin(phone.value!)}"),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            phoneBloc.isUpdate = true;
                                            phoneBloc.phone = phone;

                                            await DialogHelper.showPhonesDialog(
                                                context: context);
                                          },
                                          child: const CircleAvatar(
                                            radius: 15.0,
                                            backgroundColor: Colors.black,
                                            child: Icon(
                                              CommunityMaterialIcons
                                                  .pencil_outline,
                                              size: 18.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5.0),
                                        GestureDetector(
                                          onTap: () {
                                            phoneBloc.onDeletePhone(
                                              context,
                                              phoneId: phone.id!,
                                              headers: mainBloc.headers,
                                            );
                                          },
                                          child: const CircleAvatar(
                                            radius: 15.0,
                                            backgroundColor: Colors.black,
                                            child: Icon(
                                              CommunityMaterialIcons
                                                  .trash_can_outline,
                                              size: 18.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const LottieAnimation(
                      source: "assets/lottie/no_data_preview.json",
                    ),
            ),
          ),
        ),
        ButtonCrud(
          onTap: () async {
            phoneBloc.isUpdate = false;
            phoneBloc.phone = Phone(
              phoneDefault: false,
              type: "phone",
              areaCode: "51",
            );
            await DialogHelper.showPhonesDialog(context: context);
          },
          titleButton: "Añadir teléfono",
        ),
      ],
    );
  }
}

class PaymentCheckoutScreen extends StatefulWidget {
  const PaymentCheckoutScreen({Key? key}) : super(key: key);

  @override
  State<PaymentCheckoutScreen> createState() => _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutInfoBloc = context.watch<CheckOutInfoBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Proceso de pago",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 8.0),
                Text(
                  "* Ingresa los datos de tu tarjeta",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(15.0)),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(30.0)),
            child: CreditCardWidget(
              glassmorphismConfig: Glassmorphism(
                blurX: 1.0,
                blurY: 1.0,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xFF464b5f),
                    Color(0xFF464b5f),
                  ],
                  stops: <double>[
                    0.3,
                    0,
                  ],
                ),
              ),
              labelCardHolder: 'TITULAR DE LA TARJETA',
              cardNumber: checkoutInfoBloc.cardNumber,
              expiryDate: checkoutInfoBloc.expiryDate,
              cardHolderName: checkoutInfoBloc.cardHolderName,
              cvvCode: checkoutInfoBloc.cvvCode,
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              showBackView: checkoutInfoBloc.isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: false,
              cardBgColor: const Color(0xFF464b5f),
              chipColor: Colors.white,
              isSwipeGestureEnabled: true,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
              customCardTypeIcons: <CustomCardTypeIcon>[
                CustomCardTypeIcon(
                  cardType: CardType.visa,
                  cardImage: Image.asset(
                    'assets/banks/visa.png',
                    height: 48,
                    width: 48,
                  ),
                ),
                CustomCardTypeIcon(
                  cardType: CardType.mastercard,
                  cardImage: Image.asset(
                    'assets/banks/mastercard.png',
                    height: 48,
                    width: 48,
                  ),
                ),
                CustomCardTypeIcon(
                  cardType: CardType.discover,
                  cardImage: Image.asset(
                    'assets/banks/discover.png',
                    height: 48,
                    width: 48,
                  ),
                ),
                CustomCardTypeIcon(
                  cardType: CardType.americanExpress,
                  cardImage: Image.asset(
                    'assets/banks/amex.png',
                    height: 45,
                    width: 45,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Material(
              color: Colors.white,
              elevation: 1.0,
              borderRadius: BorderRadius.circular(18.0),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(15.0)),
                child: CreditCardForm(
                  formKey: checkoutInfoBloc.formKey,
                  obscureCvv: true,
                  obscureNumber: false,
                  cardNumber: checkoutInfoBloc.cardNumber,
                  cvvCode: checkoutInfoBloc.cvvCode,
                  isHolderNameVisible: false,
                  isCardNumberVisible: true,
                  isExpiryDateVisible: true,
                  cardHolderName: checkoutInfoBloc.cardHolderName,
                  expiryDate: checkoutInfoBloc.expiryDate,
                  themeColor: Colors.blue,
                  textColor: Colors.black,
                  cvvValidationMessage: "Ingrese un CVV valido",
                  dateValidationMessage: "Fecha de expiración invalido",
                  numberValidationMessage: "Numero de tarjeta invalido",
                  cardNumberDecoration: const InputDecoration(
                    labelText: 'Número de tarjeta',
                    hintText: 'Número de la tarjeta',
                    hintStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black),
                    errorStyle: TextStyle(height: 0.0),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  expiryDateDecoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black),
                    errorStyle: TextStyle(height: 0.0),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Fecha de expiración',
                    hintText: 'Fecha de expiración',
                  ),
                  cvvCodeDecoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black),
                    errorStyle: TextStyle(height: 0.0),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'CVV',
                    hintText: 'CVV',
                  ),
                  cardHolderDecoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black),
                    errorStyle: TextStyle(height: 0.0),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Titular de la tarjeta',
                  ),
                  onCreditCardModelChange:
                      checkoutInfoBloc.onCreditCardModelChange,
                ),
              ),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(15.0),
          ),
          const Align(
            alignment: Alignment.center,
            child: CopyRight(),
          ),
          SizedBox(
            height: getProportionateScreenHeight(40.0),
          ),
        ],
      ),
    );
  }
}

class _TabPaymentPage extends StatelessWidget {
  const _TabPaymentPage({
    Key? key,
    required this.onTap,
    required this.tabPaymentPage,
  }) : super(key: key);

  final VoidCallback onTap;
  final TabPaymentPage tabPaymentPage;

  @override
  Widget build(BuildContext context) {
    final checkoutInfoBloc = context.watch<CheckOutInfoBloc>();
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: checkoutInfoBloc.duration,
        margin: const EdgeInsets.only(bottom: 10.0),
        width: tabPaymentPage.checked!
            ? getProportionateScreenWidth(60.0)
            : getProportionateScreenWidth(55.0),
        height: tabPaymentPage.checked!
            ? getProportionateScreenWidth(60.0)
            : getProportionateScreenWidth(55.0),
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          // color: tabPaymentPage.checked! ? Colors.black : Colors.white,
          color: Colors.black,
          borderRadius: BorderRadius.circular(15.0),
          // boxShadow: const [
          //   BoxShadow(
          //     color: Colors.black, //New
          //     blurRadius: 1.0,
          //     offset: Offset(0, 1),
          //   )
          // ],
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   colors: <Color>[
          //     Colors.black,
          //     kPrimaryColor.withOpacity(.1),
          //   ],
          // ),
        ),
        child: Text(
          tabPaymentPage.title!,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
