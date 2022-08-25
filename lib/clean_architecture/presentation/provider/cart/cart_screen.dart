import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/cart/cart_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/loadany.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/lottie_animation.dart';

class CartScreen extends StatelessWidget {
  const CartScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartBloc(),
      builder: (_, __) => const CartScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.watch<MainBloc>();
    final cartBloc = context.watch<CartBloc>();

    return ValueListenableBuilder(
      valueListenable: mainBloc.accountLoaded,
      builder: (context, LoadStatus accountLoaded, child) {
        return Stack(
          children: [
            accountLoaded == LoadStatus.normal
                ? RefreshIndicator(
                    notificationPredicate: (notification) => true,
                    triggerMode: RefreshIndicatorTriggerMode.onEdge,
                    onRefresh: () async {},
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          pinned: true,
                          snap: false,
                          floating: false,
                          toolbarHeight: 56.0,
                          backgroundColor: kBackGroundColor,
                          systemOverlayStyle: const SystemUiOverlayStyle(
                            statusBarColor: kBackGroundColor,
                            statusBarIconBrightness: Brightness.dark,
                          ),
                          expandedHeight: getProportionateScreenHeight(56.0),
                          title: const Text(
                            "Mi cuenta",
                            style: TextStyle(color: Colors.black),
                          ),
                          actions: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: GestureDetector(
                                onTap: () {},
                                child: const Icon(Icons.settings),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const Positioned.fill(
                    child: Center(
                      child: LottieAnimation(
                        source: "assets/lottie/paw.json",
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
