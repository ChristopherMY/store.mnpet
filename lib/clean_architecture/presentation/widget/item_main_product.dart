import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/product_screen.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/star_rating.dart';

class TrendingItemMain extends StatelessWidget {
  final _cloudFront = Environment.CLOUD_FRONT;

  final Product product;
  final List<Color> gradientColors;

  const TrendingItemMain({
    Key? key,
    required this.product,
    this.gradientColors = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Card(
          color: Colors.white,
          borderOnForeground: false,
          elevation: 0.0,
          child: Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: product.mainImage!.aspectRatio!,
                // aspectRatio: doubleInRange(Random(), 0.88, 1.19),
                child: CachedNetworkImage(
                  imageUrl: "$_cloudFront/${product.mainImage!.src!}",
                  imageBuilder: (context, imageProvider) => Image(
                    image: imageProvider,
                  ),
                  placeholder: (context, url) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image.asset("assets/no-image.png"),
                  ),
                ),
              ),
              _productDetails(context)
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductScreen.init(context, product),
          ),
        );
      },
    );
  }

  _productDetails(context) {
    double rating = product.rating! * 0.05;
    return Padding(
      padding:
          const EdgeInsets.only(top: 1.5, right: 3.0, bottom: 6.0, left: 3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            product.categories![0].name!,
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
                        fontSize: 14,
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

  double doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;
}
