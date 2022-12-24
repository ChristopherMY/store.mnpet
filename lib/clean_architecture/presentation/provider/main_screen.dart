import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/authentication.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/account/account_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/cart/cart_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/home/home_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/custom_navigation_bottom_bar.dart';
import 'package:store_mundo_negocio/main.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
    // required this.queryParametersAll,
    // required this.hasQueryUri,
  }) : super(key: key);

  // final Map<String, List<String>> queryParametersAll;
  // final bool hasQueryUri;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void onChangeNavigator(int index) {
    final mainBloc = context.read<MainBloc>();
    mainBloc.onChangeIndexSelected(
      index: index,
      context: context,
    );
  }

  void initializationAuth() async {
    final mainBloc = context.read<MainBloc>();
    mainBloc.userAuth.value = await Authentication.initializeFirebase(context: context);
  }

  @override
  void initState() {
    /// Mandar a la categoria
    /// Mandar a un producto.

    /// Aqui puede ir el Navigator Splash
    initializationAuth();

    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      final mainBloc = context.read<MainBloc>();
      // mainBloc.userAuth.value = User;

      print('RESULTADO GOOGLE');
      print(account!.displayName.toString());

    });

    googleSignIn.signInSilently();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.watch<MainBloc>();
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        if (mainBloc.indexSelected.value != 0) {
          mainBloc.indexSelected.value = 0;
          return false;
        }

        return true;
      },
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        backgroundColor: kBackGroundColor,
        body: Stack(
          children: [
            Positioned.fill(
              child: ValueListenableBuilder(
                valueListenable: mainBloc.indexSelected,
                builder: (context, int value, child) {
                  print("INDEXED SELECT");
                  return IndexedStack(
                    index: value,
                    children: <Widget>[
                      HomeScreen.init(context),
                      CartScreen.init(context),
                      AccountScreen.init(context),
                    ],
                  );
                },
              ),
            ),

            /// NavigationBottomBar

            AnimatedBuilder(
              animation: Listenable.merge(
                [mainBloc.bottomBarVisible, mainBloc.indexSelected],
              ),
              builder: (context, child) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  bottom: mainBloc.bottomBarVisible.value
                      ? getProportionateScreenHeight(15.0)
                      : -(kToolbarHeight + getProportionateScreenHeight(15.0)),
                  height: kToolbarHeight,
                  left: getProportionateScreenWidth(25.0),
                  right: getProportionateScreenWidth(25.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(27),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          blurRadius: 4.1,
                          color: Colors.black12,
                          offset: Offset(0, 2.1),
                          spreadRadius: 2.4,
                        )
                      ],
                    ),
                    child: CustomNavigationBottomBar(
                      currentIndex: mainBloc.indexSelected.value,
                      onTap: onChangeNavigator,
                      items: [
                        /// Home
                        SalomonBottomBarItem(
                          icon: const Icon(Icons.home_outlined),
                          title: const Text("Home"),
                          selectedColor: kPrimaryColor,
                        ),

                        /// Likes
                        SalomonBottomBarItem(
                          icon: const Icon(Icons.shopping_basket_outlined),
                          title: const Text("Carrito"),
                          selectedColor: kPrimaryColor,
                        ),

                        /// Search
                        SalomonBottomBarItem(
                          icon: const Icon(Icons.person_outline),
                          title: const Text("Mi cuenta"),
                          selectedColor: kPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
