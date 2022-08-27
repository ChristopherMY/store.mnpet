import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/cart.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/cart/cart_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/default_button.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/loadany.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/lottie_animation.dart';

class CartScreen extends StatelessWidget {
  const CartScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartBloc(),
      builder: (_, __) => const CartScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.watch<MainBloc>();
    final cartBloc = context.watch<CartBloc>();

    return ValueListenableBuilder(
      valueListenable: mainBloc.shoppingCartLoaded,
      builder: (context, LoadStatus shoppingCartLoaded, child) {
        return Stack(
          children: [
            shoppingCartLoaded == LoadStatus.normal
                ? RefreshIndicator(
                    notificationPredicate: (notification) => true,
                    triggerMode: RefreshIndicatorTriggerMode.onEdge,
                    onRefresh: () async {},
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          pinned: true,
                          snap: false,
                          floating: false,
                          toolbarHeight: 56.0,
                          backgroundColor: kBackGroundColor,
                          systemOverlayStyle: const SystemUiOverlayStyle(
                            statusBarColor: kBackGroundColor,
                            statusBarIconBrightness: Brightness.dark,
                          ),
                          expandedHeight: getProportionateScreenHeight(56.0),
                          title: Text(
                            "Carrito(18)",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          actions: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: GestureDetector(
                                onTap: () {},
                                child: const Icon(Icons.settings),
                              ),
                            ),
                          ],
                        ),
                        SliverVisibility(
                          visible: mainBloc.informationCart is Cart,
                          sliver: SliverPadding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: mainBloc
                                        .informationCart!.products.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const Divider();
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final product = mainBloc
                                          .informationCart!.products[index];

                                      if (!product.isFree) {
                                        return CardItem(product: product);
                                      }

                                      return CardItemFree(
                                        productName: product.name,
                                        imageUrl: product.mainImage.src,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverVisibility(
                          visible: mainBloc.informationCart is Cart,
                          sliver: SliverPadding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15.0),
                            sliver: SliverToBoxAdapter(
                              child: InfoCartDetail(
                                cart: mainBloc.informationCart!,
                              ),
                            ),
                          ),
                        ),
                        SliverVisibility(
                          visible: mainBloc.informationCart is Cart,
                          sliver: SliverPadding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15.0),
                            sliver: SliverToBoxAdapter(
                              child: DefaultButton(
                                text: "Ir a pagar",
                                press: () {},
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : const Positioned.fill(
                    child: Center(
                      child: LottieAnimation(
                        source: "assets/lottie/paw.json",
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}

class InfoCartDetail extends StatelessWidget {
  const InfoCartDetail({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text("Resumen", style: Theme.of(context).textTheme.bodyText2),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Subtotal", style: Theme.of(context).textTheme.bodyText2),
                Text("S/ ${cart.subTotal}",
                    style: Theme.of(context).textTheme.bodyText2)
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Costo de envío",
                    style: Theme.of(context).textTheme.bodyText2),
                Text(
                  "S/ ${cart.shipment}",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Total",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text("S/ ${cart.total}",
                    style: Theme.of(context).textTheme.bodyText2)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    const url = Environment.API_DAO;
    return Container(
      constraints: const BoxConstraints(minHeight: 125.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0), // Image border
              child: CachedNetworkImage(
                height: 100,
                width: 100,
                imageUrl: "$url/${product.mainImage!.src!}",
                imageBuilder: (context, imageProvider) =>
                    Image(image: imageProvider),
                placeholder: (context, url) => Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  "assets/no-image.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 105.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  product.name!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                const SizedBox(height: 10.0),
                                product.hasVariations!
                                    ? Column(
                                        children: product.attributes!
                                            .map((element) {
                                              return Text(
                                                "${element.name}: ${element.terms!.first.label}",
                                              );
                                            })
                                            .toList()
                                            .cast(),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          GestureDetector(
                            child: const Icon(
                              CupertinoIcons.trash_fill,
                              size: 22,
                            ),
                            // onTap: () => _deleteProductCart(
                            //   productCart: productCart,
                            //   userId: userId,
                            //   preferences: preferences,
                            // ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              "\S/ ${product.price!.sale! * product.quantity!}",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                child: const Icon(Icons.remove_circle_outline),
                                // onTap: () => quantityLess(
                                //   productCart: productCart,
                                //   preferences: preferences,
                                //   userId: userId,
                                // ),
                              ),
                              SizedBox(
                                width: 35,
                                child: Text(
                                  product.quantity.toString(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                              GestureDetector(
                                child: const Icon(Icons.add_circle_outline),
                                // onTap: () => quantityMore(
                                //   productCart: productCart,
                                //   preferences: preferences,
                                //   userId: userId,
                                // ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardItemFree extends StatelessWidget {
  const CardItemFree({
    Key? key,
    required this.productName,
    required this.imageUrl,
  }) : super(key: key);

  final String productName;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    const url = Environment.API_DAO;
    return Banner(
      message: "Gratis",
      location: BannerLocation.topStart,
      color: Colors.red,
      child: Container(
        constraints: const BoxConstraints(minHeight: 100.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0), // Image border
                    child: CachedNetworkImage(
                      height: 100,
                      width: 100,
                      imageUrl: "$url/$imageUrl",
                      imageBuilder: (context, imageProvider) =>
                          Image(image: imageProvider),
                      placeholder: (context, url) => Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/no-image.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 100.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              width: 120.0,
                              child: Text(
                                productName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              height: 25.0,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(14.0),
                  bottomRight: Radius.circular(14.0),
                ),
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFFff6a71),
                    kPrimaryColor,
                  ],
                ),
              ),
              child: Text(
                "Obtienes un producto de regalo",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
