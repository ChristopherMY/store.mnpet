import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/lottie_animation.dart';

class LoadingFullScreen extends StatelessWidget {
  const LoadingFullScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: kBackGroundColor,
        body: Align(
          alignment: Alignment.center,
          child: LottieAnimation(source: "assets/lottie/paw.json"),
        ),
      ),
    );
  }
}
