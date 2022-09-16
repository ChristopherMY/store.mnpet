import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/product_screen.dart';

class TrendingItemMainGrid extends StatelessWidget {
  final _url = Environment.CLOUD_FRONT;
  final Product product;
  final List<Color> gradientColors;

  const TrendingItemMainGrid(
      {required this.product, required this.gradientColors});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints(
                maxHeight: 155,
                minHeight: 155,
                minWidth: 150,
                maxWidth: 150,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    "$_url/${product.mainImage!.src!}",
                  ),
                ),
              ),
            ),
            //_productImage(),
            _productDetails(context)
          ],
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

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenHeight(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              product.categories![0].name!.trim(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: Colors.black45),
            ),
            const SizedBox(height: 3.0),
            Text(
              product.name!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(height: 3.0),
            Row(
              children: <Widget>[
                Text(
                  "S/ ${parseDouble(product.price!.sale!)}",
                  style: const TextStyle(
                    fontSize: 15,
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
                )
              ],
            ),
            /*SizedBox(height: 3),
            Row(
              children: [
                Expanded(child: StarRating(rating: rating, size: 14)),
                  SizedBox(width: 3),
                  Text(
                    "${product.totalPurchased} vendido(s)",
                    style: TextStyle(fontSize: 14),
                )
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}
