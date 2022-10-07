import 'package:collection/collection.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/cart.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/local_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/payment_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/cart/cart_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/checkout_info/checkout_info_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/phone/phone_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/shipment/shipment_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/dialog_helper.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/global_snackbar.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/default_button.dart';

import '../../../domain/model/credit_card_brand.dart';
import '../../../domain/model/custom_card_type_icon.dart';
import '../../../domain/usecase/page.dart';
import '../../util/glassmorphism_config.dart';
import '../../widget/credit_card_form.dart';
import '../../widget/credit_card_widget.dart';

class CheckoutInfoScreen extends StatefulWidget {
  const CheckoutInfoScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider<CartBloc>.value(
      value: context.read<CartBloc>(),
      child: ChangeNotifierProvider<CheckOutInfoBloc>(
        create: (context) => CheckOutInfoBloc(paymentRepository: context.read<PaymentRepository>()),
        builder: (_, __) => const CheckoutInfoScreen._(),
      ),
    );
  }

  @override
  State<CheckoutInfoScreen> createState() => _CheckoutInfoScreenState();
}

class _CheckoutInfoScreenState extends State<CheckoutInfoScreen> {
  bool hasTe = false;

  final colors = [
    Colors.grey.shade300,
    Colors.grey.shade300,
  ];

  @override
  Widget build(BuildContext context) {
    // final cartBloc = context.read<CartBloc>();
    final mainBloc = context.read<MainBloc>();
    // final checkoutInfoBloc = context.read<CheckOutInfoBloc>();

    final checkoutInfoBloc = context.watch<CheckOutInfoBloc>();

    return Scaffold(
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
          "Orden",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        leadingWidth: 50.0,
      ),
      backgroundColor: kBackGroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight! -
                          SizeConfig.screenHeight! * 0.27,
                      child: PageView(
                        controller: checkoutInfoBloc.pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const <Widget>[
                          OrderCheckoutScreen(),
                          PaymentCheckoutScreen()
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: SmoothPageIndicator(
                        controller: checkoutInfoBloc.pageController,
                        count: 2,
                        onDotClicked: (index) async {
                          await checkoutInfoBloc.pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn,
                          );
                        },
                        effect: CustomizableEffect(
                          activeDotDecoration: DotDecoration(
                            width: getProportionateScreenWidth(66.0),
                            height: 12.0,
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          dotDecoration: DotDecoration(
                            width: 44.0,
                            height: 12.0,
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(16.0),
                            verticalOffset: 0,
                          ),
                          spacing: 20.0,
                          inActiveColorOverride: (i) => colors[i],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              width: SizeConfig.screenWidth!,
              child: ValueListenableBuilder(
                valueListenable: mainBloc.informationCart,
                builder: (_, cart, __) {
                  if (cart is Cart) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          hasTe = !hasTe;
                        });
                      },
                      child: Container(
                        color: kPrimaryColor,
                        child: Column(
                          children: [
                            AnimatedCrossFade(
                              firstChild: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
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
                                        vertical: 8.0,
                                        horizontal: 15.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Total",
                                            style:
                                                TextStyle(color: Colors.white),
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
                                          price: parseDouble(cart.subTotal!),
                                          fontSize: 12,
                                          verticalPadding: 5.0,
                                        ),
                                        _divider(),
                                        RowDetailPriceInfo(
                                          title: "Envío",
                                          price: parseDouble(cart.shipment!),
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
                              crossFadeState: hasTe
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              duration: kThemeAnimationDuration,
                            ),
                          ],
                        ),
                      ),
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
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: DefaultButton(
            text: 'Continuar',
            color: Colors.white,
            colorText: Colors.black,
            press: () async {
              dynamic existsDefaultAddress;
              dynamic existsDefaultPhone;

              print(checkoutInfoBloc.pageController.page!);
              print(checkoutInfoBloc.pageController.page!.toInt());

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
                        await Future.value(
                          checkoutInfoBloc.pageController.animateToPage(
                            checkoutInfoBloc.pageController.page!.toInt() + 1,
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
                  case 1: {
                       checkoutInfoBloc.handlePayment(identificationNumber: userInfo.document!.value!);
                    }
                    break;
                  default:
                    GlobalSnackBar.showWarningSnackBar(
                      context,
                      "Ups. Tuvimos un problema, vuelva a intentarlo más tarde",
                    );
                }
              }
            },
          ),
        ),
      ),
    );
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

class _ButtonCrud extends StatelessWidget {
  const _ButtonCrud({
    Key? key,
    required this.onTap,
    required this.titleButton,
  }) : super(key: key);

  final VoidCallback onTap;
  final String titleButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth! - SizeConfig.screenWidth! * 0.55,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Material(
          color: kBackGroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 25.0,
                    height: 25.0,
                    child: Icon(
                      CupertinoIcons.plus,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text(titleButton)
                ],
              ),
            ),
          ),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.grey.shade300,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
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
          ),
          _OrderCheckoutShipping.init(context),
          SizedBox(height: getProportionateScreenHeight(25.0)),
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
            padding: const EdgeInsets.only(left: 7.0),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: List.generate(
                mainBloc.informationUser!.addresses.length,
                (index) {
                  final address = mainBloc.informationUser!.addresses[index]!;
                  return SizedBox(
                    width: SizeConfig.screenWidth! -
                        SizeConfig.screenWidth! * 0.13,
                    child: Card(
                      color: Colors.white,
                      margin: const EdgeInsets.all(5.0),
                      elevation: 2,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(address.addressType!),
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: address!.addressDefault!
                                        ? Colors.green
                                        : Colors.white,
                                    border: Border.all(width: 0.5),
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    size: 15,
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

                                        await DialogHelper.showAddressDialog(
                                            context: context);
                                      },
                                      child: const CircleAvatar(
                                        radius: 15.0,
                                        backgroundColor: Colors.black,
                                        child: Icon(
                                          CommunityMaterialIcons.pencil_outline,
                                          size: 18.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5.0),
                                    GestureDetector(
                                      onTap: () async {
                                        context.loaderOverlay.show();
                                        final response =
                                            await shipmentBloc.onDeleteAddress(
                                          addressId: address.id!,
                                          headers: mainBloc.headers,
                                        );

                                        if (response is ResponseApi) {
                                          shipmentBloc.address = Address(
                                            ubigeo: Ubigeo(),
                                            lotNumber: 1,
                                            dptoInt: 1,
                                            addressDefault: false,
                                          );

                                          final responseUserInformation =
                                              await mainBloc
                                                  .getUserInformation();

                                          if (responseUserInformation
                                              is UserInformation) {
                                            mainBloc.informationUser =
                                                responseUserInformation;

                                            mainBloc.refreshMainBloc();
                                            context.loaderOverlay.hide();

                                            if (!mounted) return;
                                            await GlobalSnackBar
                                                .showInfoSnackBarIcon(
                                              context,
                                              response.message,
                                            );

                                            return;
                                          }
                                        }

                                        context.loaderOverlay.hide();
                                        if (!mounted) return;
                                        await GlobalSnackBar
                                            .showWarningSnackBar(
                                          context,
                                          "Ups, vuelvalo a intentar más tarde",
                                        );

                                        return;
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
            ),
          ),
        ),
        _ButtonCrud(
          onTap: () async {
            shipmentBloc.isUpdate = false;
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
  String splitNumberJoin(String number) {
    const int splitSize = 3;
    RegExp exp = RegExp(r"\d{" + splitSize.toString() + "}");
    Iterable<Match> matches = exp.allMatches(number);
    return matches.map((m) => int.tryParse(m.group(0)!)).join(" ");
  }

  @override
  Widget build(BuildContext context) {
    final phoneBloc = context.watch<PhoneBloc>();
    final mainBloc = context.watch<MainBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 135,
          child: Padding(
            padding: const EdgeInsets.only(left: 7.0),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: List.generate(
                mainBloc.informationUser.phones.length,
                (index) {
                  final Phone phone = mainBloc.informationUser.phones[index];
                  return SizedBox(
                    width: SizeConfig.screenWidth! -
                        SizeConfig.screenWidth! * 0.13,
                    child: Card(
                      color: Colors.white,
                      margin: const EdgeInsets.all(5.0),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          border: Border.all(width: 0.5),
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 15,
                                          color: phone.phoneDefault!
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text("+51 ${splitNumberJoin(phone.value!)}"),
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
                                      CommunityMaterialIcons.pencil_outline,
                                      size: 18.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                GestureDetector(
                                  onTap: () async {
                                    context.loaderOverlay.show();
                                    final response =
                                        await phoneBloc.onDeletePhone(
                                      phoneId: phone.id!,
                                      headers: mainBloc.headers,
                                    );

                                    if (response is ResponseApi) {
                                      phoneBloc.phone = Phone(
                                        phoneDefault: false,
                                        type: "phone",
                                        areaCode: "51",
                                      );

                                      final responseUserInformation =
                                          await mainBloc.getUserInformation();

                                      if (responseUserInformation
                                          is UserInformation) {
                                        mainBloc.informationUser =
                                            responseUserInformation;
                                        mainBloc.refreshMainBloc();

                                        context.loaderOverlay.hide();

                                        if (!mounted) return;
                                        await GlobalSnackBar
                                            .showInfoSnackBarIcon(
                                          context,
                                          response.message,
                                        );

                                        return;
                                      }
                                    }

                                    context.loaderOverlay.hide();
                                    if (!mounted) return;
                                    await GlobalSnackBar.showWarningSnackBar(
                                      context,
                                      "Ups, vuelvalo a intentar más tarde",
                                    );

                                    return;
                                  },
                                  child: const CircleAvatar(
                                    radius: 15.0,
                                    backgroundColor: Colors.black,
                                    child: Icon(
                                      CommunityMaterialIcons.trash_can_outline,
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
            ),
          ),
        ),
        _ButtonCrud(
          onTap: () async {
            phoneBloc.isUpdate = false;
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.grey.shade300,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
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
              isHolderNameVisible: true,
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
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
            child: Text("Detalle de la tarjeta"),
          ),
          Expanded(
            flex: 1,
            child: Material(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
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
                  hintText: 'XXXX XXXX XXXX XXXX',
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
                  hintText: 'XX/XX',
                ),
                cvvCodeDecoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black),
                  labelStyle: TextStyle(color: Colors.black),
                  errorStyle: TextStyle(height: 0.0),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'CVV',
                  hintText: 'XXX',
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
        ],
      ),
    );
  }
}
