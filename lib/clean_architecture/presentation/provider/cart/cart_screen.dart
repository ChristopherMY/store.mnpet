import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/cart.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/credentials_auth.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/cart_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/product_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/cart/cart_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/checkout_info/checkout_info_screen.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/global_snackbar.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/default_button.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/lottie_animation.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/paged_sliver_masonry_grid.dart';

import '../../widget/item_main_product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartBloc(
        cartRepositoryInterface: context.read<CartRepositoryInterface>(),
        hiveRepositoryInterface: context.read<HiveRepositoryInterface>(),
        productRepositoryInterface: context.read<ProductRepositoryInterface>(),
      ),
      builder: (_, __) => const CartScreen._(),
    );
  }

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    final cartBloc = context.read<CartBloc>();

    cartBloc.pagingController.addPageRequestListener(
      (pageKey) {
        cartBloc.fetchPage(
          pageKey: pageKey,
          categories: [
            Brand(
              id: "621f9beeb5ab45b8097f3454",
              slug: "accesorios-para-mascotas",
            )
          ],
        );
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.watch<MainBloc>();
    final cartBloc = context.watch<CartBloc>();

    return Material(
      color: kBackGroundColor,
      child: Stack(
        children: [
          LoaderOverlay(
            child: RefreshIndicator(
              notificationPredicate: (notification) => true,
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: () async {
                dynamic response;
                if (mainBloc.sessionAccount.value == Session.active) {
                  response = await mainBloc.getShoppingCart(
                    districtId: mainBloc.residence.districtId!,
                    headers: mainBloc.headers,
                  );
                } else {
                  response = await mainBloc.getShoppingCartTemp(
                    districtId: mainBloc.residence.districtId!,
                  );
                }

                if (response is Cart) {
                  final shoppingCartId = await mainBloc.handleGetShoppingCartId();
                  if (shoppingCartId.toString().isEmpty) {
                    await mainBloc.hiveRepositoryInterface.save(
                      containerName: "shopping",
                      key: "cartId",
                      value: response.id,
                    );
                  }

                  mainBloc.informationCart.value = response;
                  mainBloc.cartLength.value = response.products!.length;
                }
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    snap: false,
                    floating: false,
                    toolbarHeight: 56.0,
                    iconTheme: const IconThemeData(color: Colors.black),
                    backgroundColor: kBackGroundColor,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: kBackGroundColor,
                      statusBarIconBrightness: Brightness.dark,
                    ),
                    expandedHeight: getProportionateScreenHeight(56.0),
                    title: ValueListenableBuilder(
                      valueListenable: mainBloc.cartLength,
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
                        valueListenable: mainBloc.informationCart,
                        builder: (context, shoppingCart, child) {
                          if (shoppingCart is Cart) {
                            if (shoppingCart.products!.isEmpty) {
                              return Column(
                                children: const [
                                  Icon(
                                    CommunityMaterialIcons.cart_outline,
                                    size: 85,
                                    color: Colors.black26,
                                  ),
                                  Text(
                                    "Aún no has añadido ningún producto a tu carrito.",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black26,
                                    ),
                                  ),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: shoppingCart.products!.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Divider();
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final product =
                                        shoppingCart.products![index];

                                    if (!product.isFree!) {
                                      return CardItem(product: product);
                                    }

                                    return CardItemFree(
                                      productName: product.name!,
                                      imageUrl: product.mainImage!.src!,
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
                        valueListenable: mainBloc.informationCart,
                        builder: (context, shoppingCart, child) {
                          if (shoppingCart is Cart) {
                            if (shoppingCart.products!.isNotEmpty) {
                              return InfoCartDetail(
                                cart: shoppingCart,
                              );
                            }

                            return const SizedBox.shrink();
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
                        valueListenable: mainBloc.informationCart,
                        builder: (_, shoppingCart, child) {
                          if (shoppingCart is Cart) {
                            if (shoppingCart.products!.isNotEmpty) {
                              return DefaultButton(
                                text: "Ir a pagar",
                                press: () {
                                  if (mainBloc.credentials is! CredentialsAuth) {
                                    mainBloc.countNavigateIterationScreen = 3;
                                    mainBloc.handleAuthAccess(context);

                                    return;
                                  }

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (__) {
                                        return CheckoutInfoScreen.init(context);
                                      },
                                    ),
                                  );
                                },
                              );
                            }

                            return const SizedBox.shrink();
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Te va a encantar",
                            style: Theme.of(context).textTheme.subtitle2,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 5)
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    sliver: PagedSliverMasonryGrid(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      pagingController: cartBloc.pagingController,
                      builderDelegate: PagedChildBuilderDelegate<Product>(
                        itemBuilder: (context, item, index) {
                          return TrendingItemMain(
                            product: item,
                            gradientColors: const [
                              Color(0xFFF28767),
                              Color(0xFFFFA726),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // : const Positioned.fill(
            //     child: Center(
            //       child: LottieAnimation(
            //         source: "assets/lottie/paw.json",
            //       ),
            //     ),
            //   ),
          ),
        ],
      ),
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
      constraints: BoxConstraints(minHeight: getProportionateScreenHeight(135.0)),
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
              child: ExtendedImage.network(
                "$url/${product.mainImage!.src!}",
                fit: BoxFit.fill,
                cache: true,
                height: 100,
                width: 100,
                timeLimit: const Duration(seconds: 10),
                enableMemoryCache: true,
                enableLoadState: false,
              ),
            ),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 135.0),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        children: product.variation!.attributes!
                                            .map((attribute) {
                                              return Text(
                                                "${attribute.name}: ${attribute.value!.label}",
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
                              size: 22.0,
                            ),
                            onTap: () async {
                              final mainBloc =
                                  Provider.of<MainBloc>(context, listen: false);
                              context.loaderOverlay.show();

                              final response =
                                  await mainBloc.deleteItemShoppingCart(
                                variationId:
                                    product.general! == "variable_product"
                                        ? product.variation!.id!
                                        : "",
                                productId: product.id!,
                              );

                              if (response is ResponseApi) {
                                await mainBloc.handleFnShoppingCart();
                                context.loaderOverlay.hide();
                                await GlobalSnackBar.showInfoSnackBarIcon(
                                  context,
                                  response.message,
                                );
                              } else {
                                context.loaderOverlay.hide();
                                GlobalSnackBar.showErrorSnackBarIcon(
                                  context,
                                  "Tuvimos problemas, vuelva a intentarlo más tarde.",
                                );
                              }
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Text(
                              "S/ ${double.parse(product.price!.sale!) * product.quantity!}",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                child: const Icon(Icons.remove_circle_outline),
                                onTap: () async {
                                  context.loaderOverlay.show();
                                  final mainBloc = context.read<MainBloc>();

                                  if (product.quantity! > 0) {
                                    final response =
                                        await mainBloc.changeQuantity(
                                      productId: product.id!,
                                      quantity: product.quantity! - 1,
                                      variationId:
                                          product.general! == "variable_product"
                                              ? product.variation!.id!
                                              : "",
                                    );

                                    if (response is ResponseApi) {
                                      await mainBloc.handleFnShoppingCart(
                                        enableLoader: false,
                                      );

                                      context.loaderOverlay.hide();

                                      GlobalSnackBar.showInfoSnackBarIcon(
                                        context,
                                        response.message,
                                      );
                                    }
                                  }
                                },
                              ),
                              SizedBox(
                                width: 35.0,
                                child: Text(
                                  product.quantity.toString(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                              GestureDetector(
                                child: const Icon(Icons.add_circle_outline),
                                onTap: () async {
                                  context.loaderOverlay.show();
                                  final mainBloc = context.read<MainBloc>();

                                  if (product.quantity! > 0) {
                                    final response =
                                        await mainBloc.changeQuantity(
                                      productId: product.id!,
                                      quantity: product.quantity! + 1,
                                      variationId:
                                          product.general! == "variable_product"
                                              ? product.variation!.id!
                                              : "",
                                    );

                                    if (response is ResponseApi) {
                                      await mainBloc.handleFnShoppingCart(
                                        enableLoader: false,
                                      );

                                      context.loaderOverlay.hide();

                                      GlobalSnackBar.showInfoSnackBarIcon(
                                        context,
                                        response.message,
                                      );
                                    }
                                  }
                                },
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
                            SizedBox(
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
