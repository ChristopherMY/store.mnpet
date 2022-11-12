import 'package:flutter/material.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/lottie_animation.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 250,
          width: SizeConfig.screenWidth,
          child: const LottieAnimation(
            source: "assets/lottie/lonely-404.json",
          ),
        ),
        const Text(
          "No encontramos la información solicitada, vuelve a intentarlo más tarde",
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Courier New',
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
