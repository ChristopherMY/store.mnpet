import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/product/product_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/star_rating.dart';

class TrendingItemMain extends StatefulWidget {
  final Product product;
  final List<Color> gradientColors;

  const TrendingItemMain({
    Key? key,
    required this.product,
    this.gradientColors = const [],
  }) : super(key: key);

  @override
  State<TrendingItemMain> createState() => _TrendingItemMainState();
}

class _TrendingItemMainState extends State<TrendingItemMain>
    with TickerProviderStateMixin {
  final _cloudFront = Environment.CLOUD_FRONT;
  AnimationController? _controller;

  @override
  initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final mainBloc = context.read<MainBloc>();

        mainBloc.bottomBarVisible = false;
        mainBloc.refreshMainBloc();

        await Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: ProductScreen.init(context, widget.product),
              );
            },
          ),
        );

        mainBloc.bottomBarVisible = true;
        mainBloc.refreshMainBloc();
      },
      child: Card(
        color: Colors.white,
        borderOnForeground: false,
        elevation: 0.1,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kSizeBorderRounded)),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
              child: AspectRatio(
                aspectRatio: widget.product.mainImage is MainImage
                    ? widget.product.mainImage!.aspectRatio!
                    : 0.86,
                // aspectRatio: doubleInRange(Random(), 0.88, 1.19),
                child: ExtendedImage(
                  fit: BoxFit.fitHeight,
                  clearMemoryCacheIfFailed: true,
                  enableMemoryCache: true,
                  image: ExtendedNetworkImageProvider(
                    widget.product.mainImage is MainImage
                        ? "$_cloudFront/${widget.product.mainImage!.src!}"
                        : "",
                    cache: true,
                    timeLimit: const Duration(seconds: 3),
                  ),
                  loadStateChanged: (ExtendedImageState state) {
                    switch (state.extendedImageLoadState) {
                      case LoadState.loading:
                        _controller!.reset();
                        _controller!.forward();
                        return FadeTransition(
                          opacity: _controller!,
                          child: const Align(
                            alignment: Alignment.topCenter,
                            child: LinearProgressIndicator(
                              color: Colors.black,
                              backgroundColor: Colors.black12,
                            ),
                          ),
                        );
                        break;

                      case LoadState.completed:
                        _controller!.forward();
                        return FadeTransition(
                          opacity: _controller!,
                          child: ExtendedRawImage(
                            image: state.extendedImageInfo?.image,
                          ),
                        );
                        break;

                      case LoadState.failed:
                        _controller!.reset();
                        return GestureDetector(
                          onTap: () {
                            state.reLoadImage();
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Image.asset(
                                "assets/no-image.png",
                                fit: BoxFit.fill,
                              ),
                              Positioned(
                                bottom: 10.0,
                                left: 0.0,
                                right: 0.0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Text(
                                    "Presione para volver a intentarlo",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                          getProportionateScreenWidth(8.0),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                        break;
                    }
                  },
                ),
              ),
            ),
            _productDetails(context)
          ],
        ),
      ),
    );
  }

  _productDetails(context) {
    double rating = widget.product.rating! * 0.05;
    return Padding(
      padding:
          const EdgeInsets.only(top: 1.5, right: 3.0, bottom: 6.0, left: 3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.product.categories![0].name!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.black45),
          ),
          const SizedBox(height: 1),
          Text(
            widget.product.name!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(height: 3),
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      "S/ ${parseDouble(widget.product.price!.sale!)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 3.0),
                    Text(
                      parseDouble(widget.product.price!.regular!),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ),
              StarRating(rating: rating, size: 13),
            ],
          ),
        ],
      ),
    );
  }

  double doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;
}
