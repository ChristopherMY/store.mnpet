import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/home/home_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/splash/splash_bloc.dart';
import 'package:uni_links/uni_links.dart';

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

  late Timer _timer;

  // Future<void> _handleInitialUri() async {
  //   final homeBloc = context.read<HomeBloc>();
  //   if (!homeBloc.initialUriIsHandled) {
  //     homeBloc.initialUriIsHandled = true;
  //
  //     try {
  //       final uri = await getInitialUri();
  //       if (uri == null) {
  //         print('no initial uri');
  //         homeBloc.queryParametersAll = {};
  //         homeBloc.hasQueryUri = false;
  //         return;
  //       }
  //
  //       homeBloc.queryParametersAll = uri.queryParametersAll;
  //       homeBloc.hasQueryUri = true;
  //
  //       print('got initial uri: $uri');
  //       print('got initial uri: ${uri.query}');
  //       print("Query: ${uri.queryParametersAll}");
  //       print(
  //           "Query: ${uri.queryParametersAll.values.map((e) => e).toString()}");
  //
  //       final queryParams = uri.queryParametersAll.entries.toList();
  //       for (final item in queryParams)
  //         print("Title: ${item.key}, Trailing: ${item.value.join(", ")}");
  //     } on PlatformException {
  //       // Platform messages may fail but we ignore the exception
  //     } on FormatException catch (err) {
  //       if (!mounted) return;
  //     }
  //   }
  // }

  void _initEventDecrement() {
    final splashBloc = context.read<SplashBloc>();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
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
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
   // _handleInitialUri();
    _initEventDecrement();
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
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          "assets/presentation/presentation_origin.png"),
                      fit: BoxFit.cover,
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
