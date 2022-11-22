import 'package:flutter/material.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';

class CopyRight extends StatelessWidget {
  const CopyRight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: getProportionateScreenHeight(45.0),
          child: Image.asset(
            "assets/images/logo-mn.png",
          ),
        ),
        const Text(
          "Versión $versionCodePlayStore",
          style: TextStyle(
            color: Colors.black38,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 5.0),
        DefaultTextStyle(
          style: const TextStyle(fontSize: 13, color: Colors.black),
          child: Column(
            children: const [
              Text("© 2022 - 2022 mundonegocio.com.pe."),
              Text("Todos los derechos reservados")
            ],
          ),
        )
      ],
    );
  }
}
