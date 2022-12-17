import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/product/product_screen.dart';
import 'package:uuid/uuid.dart';

const _url = Environment.CLOUD_FRONT;

class TrendingItemMainGrid extends StatelessWidget {
  const TrendingItemMainGrid({
    Key? key,
    required this.product,
    required this.gradientColors,
  }) : super(key: key);

  final Product product;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    const uuid = Uuid();
    final String code = uuid.v1();
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductScreen.init(
              context: context,
              product: product,
              code: code,
              fullSource: false,
              slug: ""
            ),
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
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          "$_url/${product.mainImage!.src!}",
                        ),
                      ),
                    ),
                  )),
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
