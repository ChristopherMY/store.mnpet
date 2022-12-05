import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/cart_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/local_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/product_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/general.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/cart/cart_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/product/components/body/bottom_navigation_bar.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/product/components/body/info_attributes.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/product/components/body/info_shipment.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/product/components/body/product_price.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/product/product_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/search_keyword/search_keyword_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/dialog_helper.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/dotted_swiper.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/item_main_product.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/loading_bag_full_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/paged_sliver_masonry_grid.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/shake_transition.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/star_rating.dart';
import 'package:store_mundo_negocio/main.dart';

double heightSupport = 0;

class ProductScreen extends StatefulWidget {
  const ProductScreen._({
    Key? key,
    required this.product,
    required this.code,
  }) : super(key: key);

  final Product product;
  final String code;

  static Widget init(BuildContext context, Product product, String code) {
    return ChangeNotifierProvider<ProductBloc>(
      create: (context) {
        return ProductBloc(
          productRepositoryInterface:
              context.read<ProductRepositoryInterface>(),
          cartRepositoryInterface: context.read<CartRepositoryInterface>(),
          localRepositoryInterface: context.read<LocalRepositoryInterface>(),
          hiveRepositoryInterface: context.read<HiveRepositoryInterface>(),
        );
      },
      child: ProductScreen._(product: product, code: code),
    );
  }

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final productBloc = context.read<ProductBloc>();
      productBloc.initProductState(product: widget.product, context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productBloc = context.watch<ProductBloc>();
    // if (productBloc.isLoadingPage) return const LoadingBagFullScreen();
    // print("Build Product Screen!!");
    return WillPopScope(
      onWillPop: () async {
        productBloc.notifierNavigationBottomBarVisible.value = false;
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
          toolbarHeight: 0,
          elevation: 0,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Hero(
                  tag: "background-${widget.product.id!}-${widget.code}",
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ),
              Material(
                color: kBackGroundColor,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    _BuildAppBar(
                      product: widget.product,
                      code: widget.code,
                    ),
                    if (!productBloc.isLoadingPage) ...[
                      _BuildInformation(
                        product: widget.product,
                      ),
                      _lineBreakSliver(),
                      const BuildDescription(),
                      if (productBloc.product!.galleryDescription!.isNotEmpty)
                        BuildTechnicalBanners(code: widget.code),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "Seguro que te gusta",
                            style: Theme.of(context).textTheme.subtitle2,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10.0,
                        ),
                        sliver: PagedSliverMasonryGrid(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          pagingController: productBloc.pagingController,
                          builderDelegate: PagedChildBuilderDelegate<Product>(
                            // firstPageErrorIndicatorBuilder : (context) {
                            //   return const LottieAnimation(
                            //     source: "assets/lottie/lonely-404.json",
                            //   );
                            // },
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
                    ] else
                      const SliverToBoxAdapter(
                        child: Material(
                          color: Colors.white,
                          child: LoadingBag(isFullScreen: false),
                        ),
                      ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: kBottomNavigationBarHeight),
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: productBloc.notifierNavigationBottomBarVisible,
                child: const CustomBottomNavigationBar(),
                builder: (context, value, child) {
                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    left: 0,
                    right: 0,
                    bottom: value ? 0.0 : -kBottomNavigationBarHeight,
                    height: kToolbarHeight,
                    child: child!,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
    // );
  }

  _lineBreakSliver() {
    return SliverToBoxAdapter(
      child: Container(
        height: 10,
        color: kBackGroundColor,
      ),
    );
  }
}

class _BuildAppBar extends StatelessWidget {
  const _BuildAppBar({Key? key, required this.product, required this.code})
      : super(key: key);

  final Product product;
  final String code;

  @override
  Widget build(BuildContext context) {
    final productBloc = context.read<ProductBloc>();
    final mainBloc = context.read<MainBloc>();

    List<Widget> headerWidget = [];
    List<MainImage> headerImageList =
        [product.mainImage!, ...product.galleryHeader!].unique((x) => x.id);
    if (headerImageList.isNotEmpty) {
      headerWidget.addAll(
        headerImageList.map((image) {
          return Hero(
            tag: "image-${image.id!}-$code",
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider("$cloudFront/${image.src}"),
                ),
              ),
            ),
          );
        }),
      );
    }
    //
    // if (product.galleryVideo!.isNotEmpty) {
    //   // productBloc.loadVimeoVideoConfig(context,
    //   //     galleryVideo: product.galleryVideo!);
    // }

    return SliverAppBar(
      leading: GestureDetector(
        onTap: () {
          productBloc.notifierNavigationBottomBarVisible.value = false;
          Navigator.of(context).pop();
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 7.0),
          child: CircleAvatar(
            maxRadius: 10.0,
            backgroundColor: kBackGroundColor,
            child: Icon(
              Icons.arrow_back,
              size: 20.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      systemOverlayStyle: const SystemUiOverlayStyle(
        // statusBarColor: kBackGroundColor,
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      expandedHeight: getProportionateScreenHeight(392.0),
      floating: false,
      pinned: true,
      snap: false,
      elevation: 0.0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          color: Colors.transparent,
          child: Swiper(
            layout: SwiperLayout.DEFAULT,
            controller: productBloc.swiperController,
            itemCount: headerWidget.length,
            itemBuilder: (_, index) => headerWidget[index],
            autoplay: false,
            duration: 3,
            onIndexChanged: productBloc.onChangedIndex,
            onTap: (index) {
              ///**********
              /// Received code generator from the item main product screen
              ///**********

              return productBloc.onOpenGallery(
                context: context,
                isAppBar: true,
                code: code,
                managerTypePhotoViewer: ManagerTypePhotoViewer.navigation,
              );
            },
            pagination: const SwiperPagination(
              alignment: Alignment.bottomCenter,
              builder: DotCustomSwiperPaginationBuilder(
                color: Colors.grey,
                activeColor: kPrimaryColor,
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return SearchKeywordScreen.init(context);
                },
              ),
            );
          },
          child: const CircleAvatar(
            maxRadius: 20,
            backgroundColor: kBackGroundColor,
            child: Icon(
              CommunityMaterialIcons.magnify,
              size: 25,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 10.0),
        ValueListenableBuilder(
          valueListenable: mainBloc.cartLength,
          builder: (context, int value, child) {
            return Badge(
              position: const BadgePosition(
                top: 3,
                isCenter: false,
                end: 0,
              ),
              badgeContent: Text(
                "$value",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: GestureDetector(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen.init(context),
                    ),
                  )
                },
                child: const CircleAvatar(
                  maxRadius: 20,
                  backgroundColor: kBackGroundColor,
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 10.0),
      ],
    );
  }
}

class BuildNoPromotion extends StatelessWidget {
  const BuildNoPromotion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
      child: ProductPrice(),
    );
  }
}

class BuildInformation extends StatelessWidget {
  const BuildInformation({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final productBloc = context.read<ProductBloc>();
    return Padding(
      padding: const EdgeInsets.only(
        top: 5.0,
        bottom: 15.0,
        left: 15.0,
        right: 15.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            product.name!,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 5.0),
          DefaultTextStyle(
            style: const TextStyle(fontSize: 12.0, color: Colors.black),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                StarRating(
                  rating: product.rating! * 0.05,
                  size: 17.0,
                ),
                const SizedBox(width: 5.0),
                Text("${product.rating! * 0.05}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BuildDescription extends StatelessWidget {
  const BuildDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productBloc = context.read<ProductBloc>();
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 11.0),
            child: Text(
              "Descripción del artículo",
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          if (productBloc.product!.largeDescription != "")
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                bottom: 5.0,
              ),
              child: Column(
                children: [
                  AnimatedCrossFade(
                    firstChild: Text(
                      productBloc.product!.largeDescription!,
                      maxLines: 2,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    secondChild: Text(
                      productBloc.product!.largeDescription!,
                      //textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    crossFadeState: productBloc.isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: kThemeAnimationDuration,
                  ),
                  const SizedBox(height: 8.0),
                  if (productBloc.product!.largeDescription!.length > 108)
                    Center(
                      child: GestureDetector(
                        onTap: () =>
                            productBloc.isExpanded = !productBloc.isExpanded,
                        child: Text(
                          productBloc.isExpanded ? "Ver menos" : "Ver más",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 15),
                  const Divider(
                    color: kBackGroundColor,
                    thickness: 1,
                    height: 1,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class BuildTechnicalBanners extends StatelessWidget {
  const BuildTechnicalBanners({Key? key, required this.code}) : super(key: key);

  final String code;

  @override
  Widget build(BuildContext context) {
    final productBloc = context.read<ProductBloc>();
    // double heightContainer = productBloc.product!.galleryDescription!.fold(
    //     0,
    //     (previousValue, element) =>
    //         element.dimensions!.height! + previousValue);
    //
    // double aspectRatio = productBloc.product!.galleryDescription!.fold(
    //     0,
    //     (previousValue, element) =>
    //         ( element.dimensions!.height!) +
    //         previousValue);

    // print("aspect ratio: $aspectRatio");
    // print("Tamano: ${productBloc.product!.galleryDescription!.length}");

    return SliverToBoxAdapter(
      child: Column(
        children: List.generate(
          productBloc.product!.galleryDescription!.length,
          (index) {
            final gallery = productBloc.product!.galleryDescription![index];
            return GestureDetector(
              onTap: () {
                productBloc.onChangedIndexDescription(index);
                productBloc.onOpenGallery(
                  context: context,
                  isAppBar: false,
                  code: code,
                  managerTypePhotoViewer: ManagerTypePhotoViewer.single,
                );
              },
              child: Hero(
                tag: "image-${gallery.id!}-${code}",
                child: AspectRatio(
                  aspectRatio: gallery.aspectRatio!,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          "$cloudFront/${gallery.src}",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BuildSpecifications extends StatelessWidget {
  const BuildSpecifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productBloc = context.read<ProductBloc>();

    if (productBloc.product!.specifications!.isEmpty) {
      return const SizedBox();
    } else if (productBloc.product!.specifications!.length == 1) {
      if (productBloc.product!.specifications![0].body == "" ||
          productBloc.product!.specifications![0].header == "") {
        return const SizedBox();
      }
    }

    return InkWell(
      onTap: () {
        DialogHelper.settingModalBottomSpecs(
          context: context,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15, bottom: 5, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                height: 40,
                child: Text(
                  "Detalles",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _BuildInformation extends StatelessWidget {
  const _BuildInformation({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Material(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const ShakeTransition(
              duration: Duration(milliseconds: 300),
              offset: 80,
              child: BuildNoPromotion(),
            ),
            ShakeTransition(
              duration: const Duration(milliseconds: 350),
              offset: 80,
              child: BuildInformation(product: product),
            ),
            const Divider(
              color: kBackGroundColor,
              thickness: 1,
              height: 1,
            ),
            const ShakeTransition(
              duration: Duration(milliseconds: 400),
              offset: 80,
              child: InfoAttributes(),
            ),
            const Divider(
              color: kBackGroundColor,
              thickness: 1,
              height: 1,
            ),
            const ShakeTransition(
              duration: Duration(milliseconds: 450),
              offset: 80,
              child: BuildSpecifications(),
            ),
            const Divider(
              color: kBackGroundColor,
              thickness: 10,
              height: 10,
            ),
            const ShakeTransition(
              duration: Duration(milliseconds: 500),
              offset: 80,
              child: InfoShipment(),
            ),
            const Divider(
              color: kBackGroundColor,
              thickness: 10,
              height: 10,
            ),
            ShakeTransition(
              duration: const Duration(milliseconds: 550),
              offset: 80,
              axis: Axis.vertical,
              child: _BuildWhatsapp(description: product.name!),
            )
          ],
        ),
      ),
    );
  }
}

class _BuildWhatsapp extends StatelessWidget {
  const _BuildWhatsapp({Key? key, required this.description}) : super(key: key);

  final String description;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        General.whatsappMessage(
          context: context,
          description: description,
        );
      },
      child: Container(
        height: 70,
        decoration: const BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.3),
          //     spreadRadius: 0.3,
          //     blurRadius: 8.0,
          //   )
          // ],
          color: Color(0xFF22c15e),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: 55,
              height: 55,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/call-center-agent.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "Daniela / Cotizar al por mayor",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "Escríbenos al WhatsApp",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetSize extends StatefulWidget {
  final Widget child;
  final Function onChange;

  const WidgetSize({
    Key? key,
    required this.onChange,
    required this.child,
  }) : super(key: key);

  @override
  State<WidgetSize> createState() => _WidgetSizeState();
}

class _WidgetSizeState extends State<WidgetSize> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  var widgetKey = GlobalKey();
  var oldSize;

  void postFrameCallback(_) {
    var context = widgetKey.currentContext;
    if (context == null) return;

    var newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    widget.onChange(newSize);
  }
}
