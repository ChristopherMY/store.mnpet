import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/lottie_animation.dart';

class LoadingBag extends StatelessWidget {
  const LoadingBag({Key? key, this.isFullScreen = true}) : super(key: key);

  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
    if (isFullScreen) {
      return Scaffold(
        backgroundColor: kBackGroundColor,
        appBar: AppBar(
          backgroundColor: kBackGroundColor,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: kBackGroundColor,
            statusBarIconBrightness: Brightness.dark,
          ),
          toolbarHeight: 0,
          elevation: 0,
        ),
        body: const Align(
          alignment: Alignment.center,
          child: LottieAnimation(source: "assets/lottie/shopping-bag.json"),
        ),
      );
    }

    return const Align(
      alignment: Alignment.center,
      child: LottieAnimation(source: "assets/lottie/shopping-bag.json"),
    );
  }
}
