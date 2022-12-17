import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';

import '../../product_bloc.dart';

class CustomProgressButton extends StatelessWidget {
  const CustomProgressButton({
    Key? key,
    this.buttonComesFromModal = false,
  }) : super(key: key);

  final bool buttonComesFromModal;

  @override
  Widget build(BuildContext context) {
    final productBloc = context.watch<ProductBloc>();

    return ValueListenableBuilder(
      valueListenable: productBloc.stateOnlyCustomIndicatorText,
      builder: (context, ButtonState value, child) {
        return ProgressButton(
          radius: 26.0,
          stateWidgets: {
            ButtonState.idle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const <Widget>[
                Icon(
                  CommunityMaterialIcons.cart_outline,
                  color: Colors.white,
                ),
                Text(
                  "Añadir al carrito",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            ButtonState.loading: const Text(
              "Añadiendo ...",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            ButtonState.fail: const Text(
              "Ups, algo salio mal",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
            ),
            ButtonState.success: const Text(
              "Producto añadido",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
            ),
          },
          progressIndicator: const CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
            strokeWidth: 3,
          ),
          stateColors: const {
            ButtonState.idle: kPrimaryColor,
            ButtonState.loading: kPrimaryColor,
            ButtonState.fail: kPrimaryColorRed,
            ButtonState.success: kPrimaryColor,
          },
          onPressed: () {
            productBloc.onSaveShoppingCart(context);

            if (buttonComesFromModal) {
              Navigator.of(context).pop();
            }
          },
          state: value,
          progressIndicatorSize: 20.0,
          progressIndicatorAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }
}
