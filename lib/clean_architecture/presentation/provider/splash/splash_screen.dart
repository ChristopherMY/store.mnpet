import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/home/home_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/splash/splash_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/loadany.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider<HomeBloc>.value(
      value: Provider.of<HomeBloc>(context),
      child: ChangeNotifierProvider(
        create: (context) => SplashBloc(),
        child: const SplashScreen._(),
      ),
    );
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer;

  void initEventDecrement() {
    final splashBloc = context.read<SplashBloc>();

    timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        final homeBloc = context.read<HomeBloc>();
        if (homeBloc.components == LoadStatus.normal) {
          timer.cancel();
          Navigator.of(context).pop();
        }

        if (splashBloc.countdown.value == 0) {
          timer.cancel();

          Navigator.of(context).pop();
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

    //WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initEventDecrement();
    //});
  }

  @override
  Widget build(BuildContext context) {
    final splashBloc = context.watch<SplashBloc>();

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/presentation/lettering_v3.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 15.0,
              top: 15.0,
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
      ),
    );
  }
}
