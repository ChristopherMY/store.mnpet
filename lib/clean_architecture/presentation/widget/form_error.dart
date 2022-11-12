import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: getProportionateScreenHeight(20.0),
            // decoration: const BoxDecoration(
            //   image: DecorationImage(
            //     fit: BoxFit.contain,
            //     alignment: FractionalOffset.topCenter,
            //     image: AssetImage("assets/icons/advertencia.png"),
            //   ),
            // ),
            child: const Icon(
              CommunityMaterialIcons.alert_circle_outline,
              color: Colors.red,
            ),
          ),
          SizedBox(width: getProportionateScreenWidth(10.0)),
          Text(error),
        ],
      ),
    );
  }
}
