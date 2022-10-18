import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/cart.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/global_snackbar.dart';

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
    final mainBloc = context.read<MainBloc>();
    return ValueListenableBuilder(
      valueListenable: productBloc.stateOnlyCustomIndicatorText,
      builder: (context, ButtonState value, child) {
        return ProgressButton(
          radius: 26.0,
          stateWidgets: {
            ButtonState.idle: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(
                  CommunityMaterialIcons.cart_outline,
                  color: Colors.white,
                ),
                SizedBox(width: 10.0),
                Text(
                  "Añadir al carrito",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            ButtonState.loading: const Text(
              "Añadiendo a tu carrito...",
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
            )
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
          //onPressed: isDialog! ? onAddDialogCart : onAddCart,
          onPressed: () async {
            final response = await productBloc.onSaveShoppingCart(headers: mainBloc.headers);

            if (response is bool) {
              if (response) {
                //TODO: Debe de esperar que el shopping cart termine de cargar para
                // que muestre la cantidad de items en el carrito

                mainBloc.handleFnShoppingCart(enableLoader: true);

                GlobalSnackBar.showInfoSnackBarIcon(
                  context,
                  "Tu producto a sido agregado exitosamente al carrito",
                );

              } else {
                GlobalSnackBar.showErrorSnackBarIcon(
                  context,
                  'Ups, tuvimos un problema. Vuelva a intentarlo más tarde',
                );
              }

              if (buttonComesFromModal) {
                Navigator.of(context).pop();
              }

            }
          },
          state: value,
          padding: const EdgeInsets.only(left: 15.0),
          progressIndicatorSize: 20.0,
        );
      },
    );
  }
}
