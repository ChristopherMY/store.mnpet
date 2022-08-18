import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';

class FormError extends StatelessWidget {
  const FormError({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        errors.length,
        (index) => formErrorText(error: errors[index]),
      ),
    );
  }

  Padding formErrorText({required String error}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Container(
            height: getProportionateScreenWidth(14.0),
            width: getProportionateScreenWidth(14.0),
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                alignment: FractionalOffset.topCenter,
                image: AssetImage(
                  "assets/icons/advertencia.png",
                ),
              ),
            ),
          ),
          SizedBox(width: getProportionateScreenWidth(10.0)),
          Text(error),
        ],
      ),
    );
  }
}
