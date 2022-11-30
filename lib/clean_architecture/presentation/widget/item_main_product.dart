import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/product/product_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/star_rating.dart';

const _cloudFront = Environment.CLOUD_FRONT;

class TrendingItemMain extends StatelessWidget {
  final Product product;
  final List<Color> gradientColors;
  final bool showHero;

  const TrendingItemMain({
    Key? key,
    required this.product,
    this.gradientColors = const [],
    this.showHero = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final aspectRatio =
        product.mainImage is MainImage ? product.mainImage!.aspectRatio! : 0.86;

    print("Esta recargando: ${product.name}");

    //final aspectRatio = doubleInRange(Random(), 0.88, 1.19);

    return GestureDetector(
      onTap: () async {
        final mainBloc = context.read<MainBloc>();

        mainBloc.bottomBarVisible.value = false;

        await Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration:
                Duration(milliseconds: showHero ? 400 : 300),
            pageBuilder: (_, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: ProductScreen.init(context, product, showHero),
              );
            },
          ),
        );

        mainBloc.bottomBarVisible.value = true;
      },
      child: AspectRatio(
        aspectRatio: aspectRatio - aspectRatio * 0.24,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: showHero
                  ? Hero(
                      tag: "background-${product.id!}",
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                    ),
            ),
            Positioned(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: showHero
                      ? Hero(
                          tag: product.mainImage!.id!,
                          child: CachedNetworkImage(
                            imageUrl: product.mainImage is MainImage
                                ? "$_cloudFront/${product.mainImage!.src!}"
                                : "",
                            errorWidget: (context, url, error) =>
                                Image.asset("assets/no-image.png"),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: product.mainImage is MainImage
                              ? "$_cloudFront/${product.mainImage!.src!}"
                              : "",
                          errorWidget: (context, url, error) =>
                              Image.asset("assets/no-image.png"),
                        ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _ProductDetails(product: product),
            ),
          ],
          //   ),
        ),
      ),
    );
  }

// double doubleInRange(Random source, num start, num end) =>
//     source.nextDouble() * (end - start) + start;
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    double rating = product.rating! * 0.05;
    return Padding(
      padding:
          const EdgeInsets.only(top: 1.5, right: 3.0, bottom: 6.0, left: 3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            product.categories!.map((e) => e.name).join(", "),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.black45),
          ),
          const SizedBox(height: 1),
          Text(
            product.name!,
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
                      "S/ ${parseDouble(product.price!.sale!)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 3.0),
                    Text(
                      parseDouble(product.price!.regular!),
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
}
