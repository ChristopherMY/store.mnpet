import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/lottie_animation.dart';

class HelperProgress {
  searchingImage({required BuildContext context}) {
    return SizedBox(
      height: 250,
      width: SizeConfig.screenWidth,
      child: const LottieAnimation(
        source: "assets/lottie/searching_image.json",
      ),
    );
  }

  Widget progressGroupLayout(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double shimmerWidth = width * 0.5;

    Color? baseColor = Colors.grey[300];
    Color? highLightColor = Colors.grey[100];

    return SizedBox(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Shimmer.fromColors(
              baseColor: baseColor!,
              highlightColor: highLightColor!,
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(
                    width: double.infinity, height: 85.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60.0),
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highLightColor,
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(
                    width: double.infinity, height: 70.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highLightColor,
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(
                    width: double.infinity, height: 70.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highLightColor,
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(
                    width: double.infinity, height: 70.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highLightColor,
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(
                    width: double.infinity, height: 70.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25.0),
          ],
        ),
      ),
    );
  }

  //progressCheckOutLayout
  Widget progressCheckOutLayout(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double shimmerWidth = width * 0.5;

    Color? baseColor = Colors.grey[300];
    Color? highLightColor = Colors.grey[100];

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: 10, left: 15, right: 15, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Shimmer.fromColors(
              baseColor: baseColor!,
              highlightColor: highLightColor!,
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(
                  width: double.infinity,
                  height: 160.0,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highLightColor,
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(
                  width: double.infinity,
                  height: 160.0,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highLightColor,
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(
                  width: double.infinity,
                  height: 65.0,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),
            const SizedBox(height: 7.0),
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highLightColor,
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(
                  width: double.infinity,
                  height: 100.0,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highLightColor,
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(
                  width: double.infinity,
                  height: 55.0,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
