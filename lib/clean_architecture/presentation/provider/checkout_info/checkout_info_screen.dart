import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/cart/cart_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/checkout_info/checkout_info_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/default_button.dart';

class CheckoutInfoScreen extends StatefulWidget {
  const CheckoutInfoScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider<CartBloc>.value(
      value: context.read<CartBloc>(),
      child: ChangeNotifierProvider<CheckOutInfoBloc>(
        create: (context) => CheckOutInfoBloc(),
        builder: (_, __) => const CheckoutInfoScreen._(),
      ),
    );
    ;
  }

  @override
  State<CheckoutInfoScreen> createState() => _CheckoutInfoScreenState();
}

class _CheckoutInfoScreenState extends State<CheckoutInfoScreen> {
  bool hasTe = false;

  @override
  Widget build(BuildContext context) {
    final cartBloc = context.read<CartBloc>();
    final mainBloc = context.read<MainBloc>();
    final checkoutInfoBloc = context.read<CheckOutInfoBloc>();

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
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              width: SizeConfig.screenWidth!,
              child: GestureDetector(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "S/ 3.499.99",
                                style: TextStyle(
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
                                    Text(
                                      "Total",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "S/ 3.499.99",
                                      style: TextStyle(
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
                                    price: 3499.99,
                                    fontSize: 12,
                                    verticalPadding: 5.0,
                                  ),
                                  _divider(),
                                  RowDetailPriceInfo(
                                    title: "Envío",
                                    price: 43.00,
                                    fontSize: 12,
                                    verticalPadding: 5.0,
                                  ),
                                  _divider(),
                                  RowDetailPriceInfo(
                                    title: "Total",
                                    price: 3542.00,
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
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: getProportionateScreenHeight(65.0),
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
            color: kBackGroundColor,
            colorText: Colors.black,
            press: () {},
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

// ValueListenableBuilder(
// valueListenable: mainBloc.informationCart,
// builder: (context, shoppingCart, child) {
// if (shoppingCart is Cart) {
// if (shoppingCart.products!.isNotEmpty) {
// return InfoCartDetail(
// cart: shoppingCart,
// );
// }
//
// return const SizedBox.shrink();
// }
//
// return const SizedBox.shrink();
// },
// ),

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
  final double price;
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
