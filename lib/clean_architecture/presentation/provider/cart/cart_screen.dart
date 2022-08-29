import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/cart.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/cart_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/product_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/cart/cart_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/default_button.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/loadany.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/lottie_animation.dart';

import '../../../domain/model/credentials_auth.dart';
import '../../../domain/model/user_information.dart';
import '../../widget/item_main_product.dart';

class CartScreen extends StatelessWidget {
  const CartScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartBloc(
        cartRepositoryInterface: context.read<CartRepositoryInterface>(),
        hiveRepositoryInterface: context.read<HiveRepositoryInterface>(),
        productRepositoryInterface: context.read<ProductRepositoryInterface>(),
      )..initRelatedProductsPagination(categories: [Brand(id: "621f9beeb5ab45b8097f3454", slug: "accesorios-para-mascotas")]),
      builder: (_, __) => const CartScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.watch<MainBloc>();
    final cartBloc = context.watch<CartBloc>();
    print("RECARGO SHOPPING CART SCREEN");

    if (mainBloc.credentials is CredentialsAuth) {
      if (mainBloc.informationUser is! UserInformation) {
        cartBloc.loadShipmentResidence().then(
          (shipmentResidence) {
            cartBloc
                .fetchGetShoppingCart(
              districtId: shipmentResidence.districtId!,
              headers: mainBloc.headers,
            )
                .then(
              (cart) {
                if (cart is Cart) {
                  mainBloc.informationCart = cart;
                }

                cartBloc.cart.value = LoadStatus.normal;
              },
            );
          },
        );
      }
    }

    return Stack(
      children: [
        // shoppingCartLoaded == LoadStatus.normal
        //     ?
        RefreshIndicator(
          notificationPredicate: (notification) => true,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async {},
          child: ValueListenableBuilder(
            valueListenable: cartBloc.loadStatus,
            builder: (context, LoadStatus value, child) {
              return LoadAny(
                status: value,
                loadingMsg: 'Cargando... ',
                errorMsg: 'Error de carga, haga clic en reintentar ',
                finishMsg:
                    'Seguiremos trabajando para tener los productos que buscas.',
                endLoadMore: false,
                onLoadMore: () async {
                  cartBloc.initRelatedProductsPagination(
                    categories: [],
                  );
                },
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
                      title: ValueListenableBuilder(
                        valueListenable: cartBloc.cartLength,
                        builder: (context, int value, child) {
                          return Text(
                            "Carrito($value)",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      actions: const [],
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      sliver: SliverToBoxAdapter(
                        child: ValueListenableBuilder(
                          valueListenable: cartBloc.cart,
                          builder: (context, LoadStatus shoppingCart, child) {
                            if (shoppingCart == LoadStatus.normal) {
                              return Column(
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
                              );
                            }
                            return const Center(
                              child: LottieAnimation(
                                source: "assets/lottie/paw.json",
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 15.0,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: ValueListenableBuilder(
                          valueListenable: cartBloc.cart,
                          builder: (context, LoadStatus shoppingCart, child) {
                            if (shoppingCart == LoadStatus.normal) {
                              return InfoCartDetail(
                                cart: mainBloc.informationCart!,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 15.0,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: ValueListenableBuilder(
                          valueListenable: cartBloc.cart,
                          builder: (context, LoadStatus shoppingCart, child) {
                            if (shoppingCart == LoadStatus.normal) {
                              return DefaultButton(
                                text: "Ir a pagar",
                                press: () {},
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    MultiSliver(
                      children: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Seguro que te gusta",
                                  style: Theme.of(context).textTheme.subtitle2,
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 5)
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: MasonryGrid(
                              column: 2,
                              staggered: false,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              children: List.generate(
                                cartBloc.productsList.length,
                                (index) => TrendingItemMain(
                                  product: cartBloc.productsList[index],
                                  gradientColors: [
                                    const Color(0xFFF28767),
                                    Colors.orange.shade400
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        )
        // : const Positioned.fill(
        //     child: Center(
        //       child: LottieAnimation(
        //         source: "assets/lottie/paw.json",
        //       ),
        //     ),
        //   ),
      ],
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
