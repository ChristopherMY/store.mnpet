import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/product_bloc.dart';

class ProductPrice extends StatelessWidget {
  const ProductPrice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productBloc = Provider.of<ProductBloc>(context, listen: true);

    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: productBloc.salePrice,
          builder: (context, double value, widget) {
            return Text(
              "S/ ${parseDouble(value.toString())}",
              style: Theme.of(context).textTheme.subtitle1,
            );
          },
        ),
        const SizedBox(width: 5),
        ValueListenableBuilder(
          valueListenable: productBloc.regularPrice,
          builder: (context, double value, widget) {
            return Text(
              "S/ ${parseDouble(value.toString())}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: Colors.red,
                decoration: TextDecoration.lineThrough,
              ),
            );
          },
        ),
      ],
    );
  }

  String parseDouble(String value) {
    final calc = double.parse(value).toStringAsFixed(2);
    return calc.toString();
  }
}
