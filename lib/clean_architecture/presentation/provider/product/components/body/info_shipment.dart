import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/product/product_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/dialog_helper.dart';

import '../../../../../domain/model/user_information_local.dart';

class InfoShipment extends StatelessWidget {
  const InfoShipment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productBloc = context.watch<ProductBloc>();

    return InkWell(
      onTap: () {
        DialogHelper.showDialogShipping(
          context: context,
          onSaveShippingAddress: (_) async {
            final mainBloc = context.read<MainBloc>();

            final shippingPrice = await mainBloc.onSaveShippingAddress(
              slug: productBloc.product!.slug!,
              quantity: productBloc.quantity.value,
            );


            if (shippingPrice is double) {
              productBloc.shippingPrice.value = shippingPrice;
              productBloc.refreshUbigeo(slug: productBloc.product!.slug!);


              const snackBar = SnackBar(
                content: Text('Dirección guardada correctamente'),
                backgroundColor: kBlackColor,
              );

              ScaffoldMessenger.of(_).removeCurrentSnackBar();
              ScaffoldMessenger.of(_).showSnackBar(snackBar);

              Navigator.pop(_);
              return;
            }

          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: ValueListenableBuilder(
                        valueListenable: productBloc.shippingPrice,
                        builder: (context, double value, widget) {
                          return Text(
                            "Envio: ${value == 0 ? "Pago de envio en destino" : "S/ ${parseDouble(value.toString())}"}",
                            style: Theme.of(context).textTheme.subtitle2,
                          );
                        }),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                width: 16,
                child: Icon(
                  Icons.local_shipping,
                  size: 16,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Envío rápido a todo lima metropolitana",
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              const Text("Ubicación: "),
              ValueListenableBuilder(
                valueListenable: productBloc.informationLocal,
                builder: (context, UserInformationLocal value, widget) {
                  return Text(
                    "${value.ubigeo}",
                    style: Theme.of(context).textTheme.bodyText1,
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  String parseDouble(String value) {
    final calc = double.parse(value).toStringAsFixed(2);
    return calc.toString();
  }
}
