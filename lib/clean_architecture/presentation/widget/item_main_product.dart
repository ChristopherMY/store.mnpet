import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/product/product_screen.dart';
import 'package:uuid/uuid.dart';

const _cloudFront = Environment.CLOUD_FRONT;
const uuid = Uuid();

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

class _TrendingItemMainState extends State<TrendingItemMain> {
  bool showStackContent = false;

  @override
  Widget build(BuildContext context) {
    final aspectRatio = widget.product.mainImage is MainImage
        ? widget.product.mainImage!.aspectRatio!
        : 0.86;

    // final aspectRatio = doubleInRange(Random(), 0.88, 1.19);
    //final codeDatetimeNow = DateTime.now().microsecondsSinceEpoch.toString();

    final String code = uuid.v1();

    return AspectRatio(
      aspectRatio: aspectRatio - aspectRatio * 0.245,

      /// 24%
      child: Stack(
        children: <Widget>[
          Hero(
            tag: "background-${widget.product.id!}-$code",
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              final mainBloc = context.read<MainBloc>();
              mainBloc.bottomBarVisible.value = false;

              /// Condicionar la carga del producto por preloader solicitud de datos mediante Api
              /// De lo contrario que mantenga trabajando su forma normal

              await Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 300),
                  reverseTransitionDuration: const Duration(milliseconds: 400),
                  pageBuilder: (_, animation, secondaryAnimation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ProductScreen.init(
                        context: context,
                        product: widget.product,
                        code: code,
                        fullSource: false,
                        slug: "",
                      ),
                    );
                  },
                ),
              );

              mainBloc.bottomBarVisible.value = true;
            },
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: AspectRatio(
                    aspectRatio: aspectRatio,
                    child: Hero(
                      tag: "image-${widget.product.mainImage!.id!}-$code",
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              widget.product.mainImage is MainImage
                                  ? "$_cloudFront/${widget.product.mainImage!.src!}"
                                  : "",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _ProductDetails(
                  product: widget.product,
                  onTap: () {
                    setState(() {
                      showStackContent = !showStackContent;
                    });
                    print("Ontap");
                  },
                )
              ],
            ),
          ),
          if (showStackContent)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.black12,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({
    Key? key,
    required this.product,
    required this.onTap,
  }) : super(key: key);

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    double rating = product.rating! * 0.05;
    return Padding(
      padding:
          const EdgeInsets.only(top: 1.5, right: 3.0, bottom: 6.0, left: 3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
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
              Row(
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
                      height: 1.5,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 3.0),
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 13,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 3.0),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontSize: 12.0),
                    ),
                    // StarRating(rating: rating, size: 13),
                  ],
                ),
              ),
              // Material(
              //   child: InkWell(
              //     borderRadius: BorderRadius.circular(18.0),
              //     onTap: onTap,
              //     child: const Icon(
              //       CupertinoIcons.ellipsis_vertical,
              //       size: 13,
              //     ),
              //   ),
              // )
            ],
          ),
        ],
      ),
    );
  }
}
