import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/account/account_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/cart/cart_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/home/home_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.watch<MainBloc>();
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        if(mainBloc.indexSelected.value != 0){
          mainBloc.indexSelected.value = 0;
          return false;
        }

        return true;
      },
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        backgroundColor: kBackGroundColor,
        body: Stack(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  bottom:
                      mainBloc.bottomBarVisible.value ? 0.0 : -kToolbarHeight,
                  height: kToolbarHeight,
                  width: SizeConfig.screenWidth,
                  child: BottomNavigationBar(
                    currentIndex: mainBloc.indexSelected.value,
                    backgroundColor: Colors.white,
                    onTap: onChangeNavigator,
                    fixedColor: kPrimaryColor,
                    unselectedItemColor: Colors.black45,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        label: "Home",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.shopping_basket_outlined),
                        backgroundColor: kPrimaryColor,
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
      ),
    );
  }
}
