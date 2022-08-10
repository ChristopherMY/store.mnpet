import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';

class LottieAnimation extends StatefulWidget {
  const LottieAnimation({
    Key? key,
    required this.source,
  }) : super(key: key);

  final String source;

  @override
  _LottieAnimationState createState() => _LottieAnimationState();
}

class _LottieAnimationState extends State<LottieAnimation>
    with TickerProviderStateMixin<LottieAnimation> {
  late final AnimationController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.stop();
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Lottie.asset(
        widget.source,
        controller: _controller,
        repeat: false,
        reverse: true,
        height: SizeConfig.screenHeight,
        animate: true,
        onLoaded: (composition) {
          _controller!
            ..duration = composition.duration
            ..forward().whenComplete(() => {
                  /*
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    )
                  */
                });
          _controller!.animateTo(5);
        },
      ),
    );
  }
}
