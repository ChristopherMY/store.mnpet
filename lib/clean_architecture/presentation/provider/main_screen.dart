import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/home_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/account/account_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/cart/cart_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/home/home_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/home/home_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/splash/splash_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeBloc(
        homeRepositoryInterface: context.read<HomeRepositoryInterface>(),
        hiveRepositoryInterface: context.read<HiveRepositoryInterface>(),
      )..handleInitComponents(),
      builder: (_, __) => const MainScreen._(),
    );
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with AfterLayoutMixin<MainScreen> {


  Future<void> loadingScreen(BuildContext context) async {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: false,
        opaque: true,
        //barrierColor: Colors.white,
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.decelerate;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return FadeTransition(
            opacity: animation,
            //position: animation.drive(tween),
            child: child,
          );
        },
        pageBuilder: (_, animation1, animation2) => SplashScreen.init(context),
      ),
    );
  }

  void onChangeNavigator(int index) {
    final mainBloc = context.read<MainBloc>();
    mainBloc.onChangeIndexSelected(
      index: index,
      context: context,
    );
  }

  @override
  void initState() {
    // TODO: implement initStat
    super.initState();
    //
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   forceLoadingScreen(context);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.watch<MainBloc>();
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: Stack(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Positioned.fill(
            child: ValueListenableBuilder(
              valueListenable: mainBloc.indexSelected,
              builder: (context, int value, child) {
                return IndexedStack(
                  index: value,
                  children: <Widget>[
                    const HomeScreen(),
                    CartScreen.init(context),
                    AccountScreen.init(context),
                  ],
                );
              },
            ),
          ),
          // ValueListenableBuilder(
          //   valueListenable: notifierBottomBarVisible,
          //   child: Container(
          //     color: Colors.white,
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: GestureDetector(
          //             onTap: () {
          //               mainBloc.onChangeIndexSelected(
          //                 index: 0,
          //                 context: context,
          //               );
          //             },
          //             child: const Icon(Icons.home),
          //           ),
          //         ),
          //         Expanded(
          //           child: Container(
          //             color: Colors.red,
          //             height: kBottomNavigationBarHeight,
          //             child: GestureDetector(
          //               onTap: () {
          //                 mainBloc.onChangeIndexSelected(
          //                   index: 1,
          //                   context: context,
          //                 );
          //               },
          //               child: const Icon(Icons.shopping_basket_outlined),
          //             ),
          //           ),
          //         ),
          //         /*
          //
          //
          //          */
          //
          //         // Expanded(
          //         //   child: SizedBox(
          //         //     height: kBottomNavigationBarHeight,
          //         //     child: Material(
          //         //       color: Colors.white,
          //         //       child: IconButton(
          //         //         onPressed: () {
          //         //           mainBloc.onChangeIndexSelected(
          //         //             index: 2,
          //         //             context: context,
          //         //           );
          //         //         },
          //         //         highlightColor: kPrimaryColor,
          //         //         icon: const Icon(Icons.person_outline),
          //         //       ),
          //         //     ),
          //         //   ),
          //         // ),
          //       ],
          //     ),
          //   ),
          //   builder: (context, bool value, child) {
          //     return AnimatedPositioned(
          //       duration: kThemeAnimationDuration,
          //       left: 0,
          //       right: 0,
          //       bottom: value ? 0.0 : -kToolbarHeight,
          //       height: kToolbarHeight,
          //       child: child!,
          //     );
          //   },
          // ),

          /// NavigationBottomBar

          ValueListenableBuilder(
            valueListenable: mainBloc.indexSelected,
            builder: (context, int value, child) {
              return AnimatedPositioned(
                duration: kThemeAnimationDuration,
                bottom: mainBloc.bottomBarVisible ? 0.0 : -kToolbarHeight,
                height: kToolbarHeight,
                width: SizeConfig.screenWidth,
                child: BottomNavigationBar(
                  currentIndex: value,
                  onTap: onChangeNavigator,
                  selectedItemColor: kPrimaryColor,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_basket_outlined),
                      label: "Carrito",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      label: "Mi cuenta",
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) =>
      loadingScreen(context);
}
