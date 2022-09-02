import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/splash/splash_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashBloc(),
      child: const SplashScreen._(),
    );
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late Timer timer;

  void initEventDecrement() {
    final splashBloc = scaffoldKey.currentState!.context.read<SplashBloc>();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (splashBloc.countdown.value == 0) {
          timer.cancel();

          Navigator.of(scaffoldKey.currentState!.context).pop();
          return;
        }

        splashBloc.countdown.value = splashBloc.countdown.value - 1;
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initEventDecrement();
    });
  }

  @override
  Widget build(BuildContext context) {
    final splashBloc = context.watch<SplashBloc>();

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/presentation/presentation_2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: getProportionateScreenWidth(10),
            top: getProportionateScreenHeight(70),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white38,
                    spreadRadius: 3,
                  )
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.white,
                  child: ValueListenableBuilder(
                    valueListenable: splashBloc.countdown,
                    builder: (context, int value, child) {
                      return Text(
                        value.toString(),
                        style: Theme.of(context).textTheme.bodyText2,
                      );
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
