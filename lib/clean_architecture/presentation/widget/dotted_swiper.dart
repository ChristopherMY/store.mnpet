import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/product_bloc.dart';

class DotCustomSwiperPaginationBuilder extends SwiperPlugin {
  const DotCustomSwiperPaginationBuilder({
    required this.activeColor,
    required this.color,
    this.key,
    this.size = 10.0,
    this.activeSize = 10.0,
    this.space = 3.0,
  });

  final Color activeColor;
  final Color color;
  final double activeSize;
  final double size;
  final double space;
  final Key? key;

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    final productBloc = context.watch<ProductBloc>();
    if (config.itemCount > 20) {
      if (kDebugMode) {
        print(
            "The itemCount is too big, we suggest use FractionPaginationBuilder instead of DotSwiperPaginationBuilder in this sitituation");
      }
    }
    Color activeColor = this.activeColor;
    Color color = this.color;

    if (activeColor == null || color == null) {
      ThemeData themeData = Theme.of(context);
      activeColor = this.activeColor;
      color = this.color;
    }

    if (config.indicatorLayout != PageIndicatorLayout.NONE &&
        config.layout == SwiperLayout.DEFAULT) {
      return PageIndicator(
        count: config.itemCount,
        controller: config.pageController!,
        layout: config.indicatorLayout,
        size: size,
        activeColor: activeColor,
        color: color,
        space: space,
      );
    }

    int itemCount = config.itemCount;
    int activeIndex = config.activeIndex;

    if (config.scrollDirection == Axis.vertical) {
      return Container(
        key: key,
        padding: const EdgeInsets.symmetric(
          horizontal: 4.0,
          vertical: 2.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey.withOpacity(.8),
        ),
        child: Text(
          "${activeIndex + 1}/$itemCount",
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      );
    } else {
      return ValueListenableBuilder(
        valueListenable: productBloc.showSwiperPagination,
        builder: (context, bool value, child) {
          if (value) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    key: key,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 1.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.black38,
                    ),
                    child: Text(
                      "${activeIndex + 1}/$itemCount",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      );
    }
  }
}
