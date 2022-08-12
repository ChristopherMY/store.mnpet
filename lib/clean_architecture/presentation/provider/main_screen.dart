import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/home_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/account/account_screen.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/cart/cart_screen.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/home/home_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/home/home_screen.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/splash/splash_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeBloc(
        homeRepositoryInterface: context.read<HomeRepositoryInterface>(),
      )
        ..loadCategories()
        ..initPaginationProducts(),
      builder: (_, __) => const MainScreen._(),
    );
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<void> forceLoadingScreen(BuildContext context) async {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) => const SplashScreen(),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initStat
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      forceLoadingScreen(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.watch<MainBloc>();
    SizeConfig().init(context);
    return Scaffold(
      // appBar: AppBar(
      //   // backgroundColor: kPrimaryColor,
      //   // systemOverlayStyle: const SystemUiOverlayStyle(
      //   //   statusBarColor: kPrimaryColor,
      //   //   //statusBarIconBrightness: Brightness.light,
      //   // ),
      //   bottomOpacity: 0,
      //   shadowColor: Colors.transparent,
      //   toolbarHeight: 0,
      // ),
      backgroundColor: kBackGroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: IndexedStack(
              index: mainBloc.indexSelected,
              children: <Widget>[
                const HomeScreen(),
                CartScreen.init(context),
                AccountScreen.init(context),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        currentIndex: mainBloc.indexSelected,
        onTap: (index) =>
            mainBloc.onChangeIndexSelected(index: index, context: context),
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
  }
}
