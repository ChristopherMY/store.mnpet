import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/progress.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/cart/cart_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/loadany.dart';

class CartScreen extends StatelessWidget {
  const CartScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartBloc(),
      builder: (_, __) => const CartScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryBackgroundColor,
      // appBar: widget.showAppBar
      // ? new AppBar(
      // iconTheme: new IconThemeData(color: Colors.black),
      // backgroundColor: Colors.transparent,
      // bottomOpacity: 0.0,
      // elevation: 0.0,
      // title: new Text(
      // "Carro de compras",
      // style: new TextStyle(color: Colors.black, fontSize: 16),
      // ),
      // )
      //     : null,
      body: BodyCartScreen(),
    );
  }
}

class BodyCartScreen extends StatelessWidget {
  BodyCartScreen({Key? key}) : super(key: key);
  final HelperProgress _helperProgress = HelperProgress();

  @override
  Widget build(BuildContext context) {
    final cartBloc = context.watch<CartBloc>();
    if (cartBloc.isCartLoaded) {
      if (cartBloc.isSessionEnable) {
        return Stack(
          children: [
            SafeArea(
              child: SizedBox(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(10.0),
                    vertical: getProportionateScreenHeight(10.0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: (cartBloc.loginState == LoadStatus.loading)
                  ? Container(
                      color: Colors.black26,
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox.shrink(),
            )
          ],
        );
      }

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/no_logging.png",
                  height: 175,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Para visualizar su información necesita iniciar sessión con su cuenta.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return _helperProgress.progressCheckOutLayout(context);
  }
}
