import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/product/product_screen.dart';

const _url = Environment.CLOUD_FRONT;

class TrendingItemMainGrid extends StatelessWidget {
  const TrendingItemMainGrid({
    Key? key,
    required this.product,
    required this.gradientColors,
    this.showHero = false,
  }) : super(key: key);

  final Product product;
  final List<Color> gradientColors;
  final bool showHero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductScreen.init(context, product, showHero),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        borderOnForeground: false,
        elevation: 0.1,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: AspectRatio(
                aspectRatio: product.mainImage!.aspectRatio!,
                child: ExtendedImage(
                  fit: BoxFit.cover,
                  clearMemoryCacheIfFailed: true,
                  enableMemoryCache: true,
                  image: ExtendedResizeImage(
                    ExtendedNetworkImageProvider(
                      "$_url/${product.mainImage!.src!}",
                      cache: true,
                      timeLimit: const Duration(seconds: 3),
                    ),
                    compressionRatio: 0.75,
                    maxBytes: 50,
                  ),
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
    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenHeight(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              product.categories![0].name!.trim(),
              style: const TextStyle(fontSize: 13, color: Colors.black45),
            ),
            const SizedBox(height: 5.0),
            Text(
              product.name!,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(height: 5.0),
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
                const SizedBox(width: 5.0),
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
          ],
        ),
      ),
    );
  }
}
