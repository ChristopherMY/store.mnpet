import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/product/product_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/star_rating.dart';
import 'package:uuid/uuid.dart';

const _cloudFront = Environment.CLOUD_FRONT;
const uuid = Uuid();

class TrendingItemMain extends StatelessWidget {
  final Product product;
  final List<Color> gradientColors;

  const TrendingItemMain({
    Key? key,
    required this.product,
    this.gradientColors = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final aspectRatio =
        product.mainImage is MainImage ? product.mainImage!.aspectRatio! : 0.86;

    // final aspectRatio = doubleInRange(Random(), 0.88, 1.19);
    //final codeDatetimeNow = DateTime.now().microsecondsSinceEpoch.toString();

    final String code = uuid.v1();

    return GestureDetector(
      onTap: () async {
        final mainBloc = context.read<MainBloc>();

        mainBloc.bottomBarVisible.value = false;

        await Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: ProductScreen.init(context, product, code),
              );
            },
          ),
        );

        mainBloc.bottomBarVisible.value = true;
      },
      child: AspectRatio(
        aspectRatio: aspectRatio - aspectRatio * 0.24,

        /// 24%
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Hero(
                tag: "background-${product.id!}-$code",
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Hero(
                    tag: "image-${product.mainImage!.id!}-$code",
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            product.mainImage is MainImage
                                ? "$_cloudFront/${product.mainImage!.src!}"
                                : "",
                          ),
                        ),
                      ),
                    ),
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
