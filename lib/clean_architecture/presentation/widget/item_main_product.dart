import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/cart_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/local_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/product_repository.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/product_bloc.dart';
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              child: AspectRatio(
                aspectRatio: product.mainImage!.aspectRatio!,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: "$_cloudFront/${product.mainImage!.src!}",
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: imageProvider,
                      ),
                    ),
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
            ),
            _productDetails(context)
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context) {
                return ProductBloc(
                  productRepositoryInterface:
                      context.read<ProductRepositoryInterface>(),
                  cartRepositoryInterface:
                      context.read<CartRepositoryInterface>(),
                  localRepositoryInterface:
                      context.read<LocalRepositoryInterface>(),
                  hiveRepositoryInterface:
                      context.read<HiveRepositoryInterface>(),
                )
                  ..isLoadingPage = true
                  ..loadVimeoVideoConfig(galleryVideo: product.galleryVideo!)
                  ..initProduct(slug: product.slug!)
                  ..initRelatedProductsPagination(
                    categories: product.categories!,
                  )
                  ..refreshUbigeo(
                    slug: product.slug!,
                  );
              },
              // ..add(PDProvideEvent(
              //   slug: product.slug!,
              //   productId: product.id!,
              //   categories: product.categories!,
              // ))
              // ..isLoadMore = false,
              builder: (context, child) => ProductScreen(),
            ),
          ),
        );
      },
    );
  }

/*
  _productImage() {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 407 / 371,
          child: Container(
            color: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: FadeInImage(
                image: NetworkImage(
                    "$_url${product.mainImage}"),
                fit: BoxFit.fill,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage("assets/no-image.png"),
              ),
            ),
          ),
        ),
      ],
    );
  }
*/
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

          //SizedBox(height: 2),
          //Row(
          //children: [
          //Expanded(child: StarRating(rating: rating, size: 13)),
          // SizedBox(width: 3),
          // Text(
          //   "${product.totalPurchased} vendido(s)",
          //   style: TextStyle(fontSize: 12),
          // )
          //],
          //)
        ],
      ),
    );
  }

  String parseDouble(String value) {
    final calc = double.parse(value).toStringAsFixed(2);
    return calc.toString();
  }
}
