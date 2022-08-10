import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';

import '../../product_bloc.dart';

class CustomProgressButton extends StatelessWidget {
  const CustomProgressButton({
    Key? key,
  }) : super(key: key);

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(
                  CommunityMaterialIcons.cart_outline,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
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
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            ButtonState.success: const Text(
              "Producto añadido",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
            print("PRESIONO");
            final isSaved = await productBloc.onAddShoppingCart();
            ScaffoldMessenger.of(context).removeCurrentSnackBar();

            if (isSaved is bool) {
              if (isSaved) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Row(
                    children: const [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                      Text(
                        'Tu producto a sido agregado exitosamente a su carrito',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  backgroundColor: Colors.red[400],
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text(
                    'Tuvimos problemas, vuelva a intentarlo',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red[400],
                ));
              }
            } else if (isSaved is String) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.blueAccent,
                    ),
                    Text(
                      'La sessión no se encuentra activa',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Iniciar sessión",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    )
                  ],
                ),
                backgroundColor: kPrimaryBackgroundColor,
              ));
            }
          },
          state: value,
          padding: const EdgeInsets.only(left: 15),
          progressIndicatorSize: 20,
        );
      },
    );
  }
}
