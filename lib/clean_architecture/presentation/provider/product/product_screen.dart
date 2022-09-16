import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/cart_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/local_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/product_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/general.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/cart/cart_screen.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/components/body/bottom_navigation_bar.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/components/body/info_attributes.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/components/body/info_shipment.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/components/body/product_price.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/product_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/dialog_helper.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/dotted_swiper.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/item_main_product.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/paged_sliver_masonry_grid.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/photoview_wrapper.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/star_rating.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context, Product product) {
    return ChangeNotifierProvider(
      create: (context) {
        return ProductBloc(
          productRepositoryInterface:
              context.read<ProductRepositoryInterface>(),
          cartRepositoryInterface: context.read<CartRepositoryInterface>(),
          localRepositoryInterface: context.read<LocalRepositoryInterface>(),
          hiveRepositoryInterface: context.read<HiveRepositoryInterface>(),
        )
          ..isLoadingPage = true
          ..loadVimeoVideoConfig(galleryVideo: product.galleryVideo!)
          ..handleInitProduct(slug: product.slug!)
          ..handleRefreshUbigeo(
            slug: product.slug!,
          );
      },
      builder: (context, child) => const ProductScreen._(),
    );
  }

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    final productBloc = context.read<ProductBloc>();
    productBloc.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productBloc = context.watch<ProductBloc>();
    if (productBloc.isLoadingPage) {
      return const Placeholder();
    } else {
      final product = productBloc.product!;
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.screenHeight! - 87,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    const BuildAppBar(),
                    //const CustomAppBar(),
                    _buildInfo(context: context, product: product),
                    /*
                            _lineBreakSliver(),
                            _buildRatings(context: _scaffoldKey.currentContext, product: product),
                            _lineBreakSliver(),
                            _buildComments(context: _scaffoldKey.currentContext),
                          */
                    _lineBreakSliver(),
                    product.galleryDescription!.isNotEmpty ||
                            product.galleryDescription!.isNotEmpty
                        ? const BuildDescription()
                        : const SliverToBoxAdapter(
                            child: SizedBox(),
                          ),
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
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      sliver: PagedSliverMasonryGrid(
                        crossAxisCount: 2,
                        pagingController: productBloc.pagingController,
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
                    /*
                            SliverVisibility(
                              visible: _show,
                              sliver: SliverPersistentHeader(
                                delegate: DelegateTabHeader(
                                  TabBar(
                                    isScrollable: true,
                                    controller: _tabController,
                                    tabs: [
                                      Tab(child: Text("Qué es")),
                                      Tab(child: Text("Descripción")),
                                      Tab(child: Text("Valoraciones")),
                                      /*Tab(child: Text("Recomendados")),*/
                                      Tab(child: Text("Recomendados"))
                                    ],
                                    labelColor: Colors.redAccent,
                                    indicatorColor: Colors.red,
                                    unselectedLabelColor: Colors.black,
                                  ),
                                ),
                                floating: false,
                                pinned: true,
                              ),
                            ),
                        */
                  ],
                ),
              ),
              const CustomBottomNavigationBar()
            ],
          ),
        ),
      );
    }
  }

  _lineBreakSliver() {
    return SliverToBoxAdapter(
      child: Container(
        height: 10,
        color: kDividerColor,
      ),
    );
  }

  _buildInfo({required BuildContext context, required Product product}) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          /* _containerPromo(context),*/
          const BuildNoPromotion(),
          const BuildInformation(),
          const Divider(
            color: kDividerColor,
            thickness: 1,
          ),
          const InfoAttributes(),
          const Divider(
            color: kDividerColor,
            thickness: 1,
          ),
          const BuildSpecifications(),
          _lineBreakLarge(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
            child: InfoShipment(),
          ),
          _lineBreakLarge(),
          _buildWhatsapp(context: context, description: product.name!),
        ],
      ),
    );
  }

  _buildWhatsapp({required BuildContext context, required String description}) {
    return InkWell(
      onTap: () {
        General.whatsappMessage(
          context: context,
          description: description,
        );
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 0.3,
              blurRadius: 8.0,
            )
          ],
          color: const Color(0xFF22c15e),
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

  _lineBreakLarge() {
    return Container(
      width: double.infinity,
      color: kDividerColor,
      child: const Divider(
        height: 10,
        color: kDividerColor,
      ),
    );
  }
}

class BuildAppBar extends StatelessWidget {
  const BuildAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productBloc = context.read<ProductBloc>();
    final mainBloc = context.read<MainBloc>();
    return SliverAppBar(
      // iconTheme: const IconThemeData(
      //   color: Colors.black,
      // ).copyWith(color: Colors.white),
      leading: const Padding(
        padding: EdgeInsets.symmetric(vertical: 7.0),
        child: CircleAvatar(
          maxRadius: 10,
          backgroundColor: kBackGroundColor,
          child: Icon(
            Icons.add_a_photo,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: kBackGroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      expandedHeight: 393,
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
            itemCount: productBloc.headerContent.length,
            itemBuilder: (_, index) => productBloc.headerContent[index],
            autoplay: false,
            duration: 3,
            onTap: (index) => productBloc.onOpenGallery(
              context: context,
              isAppBar: true,
              managerTypePhotoViewer: ManagerTypePhotoViewer.navigation,
            ),
            onIndexChanged: (index) {
              productBloc.onChangedIndex(index: index);
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
          onTap: () => {
            /*
            Navigator.push(
              context!,
              PageTransition(
                type: PageTransitionType.leftToRightWithFade,
                child: SearchScreen(),
              ),
            )
            */
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
        SizedBox(width: 10.0),
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CircleAvatar(
              maxRadius: 20,
              backgroundColor: kBackGroundColor,
              child: IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                color: Colors.black,
                iconSize: 20,
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen.init(context),
                    ),
                  )
                },
              ),
            ),
            Positioned(
              top: 6.0,
              right: 6.0,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: ValueListenableBuilder(
                  valueListenable: mainBloc.cartLength,
                  builder: (context, int value, child) {
                    return Text(
                      "$value",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
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
  const BuildInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productBloc = context.read<ProductBloc>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            productBloc.product!.name!,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 5.0),
          SizedBox(
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 12, color: Colors.black),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  StarRating(
                    rating: productBloc.product!.rating! * 0.05,
                    size: 17,
                  ),
                  const SizedBox(width: 5),
                  Text("${productBloc.product!.rating! * 0.05}"),
                  /*
                        Container(
                          height: 15,
                          width: 10,
                          child: VerticalDivider(
                              color: Colors.black, thickness: 1),
                        ),
                        Text(
                            "${this.widget.product.totalPurchased} Vendidos"),
                         */
                ],
              ),
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
          // widget.product.galleryDescription.length > 0
          //     ? SizedBox(height: 8)
          //     : SizedBox(),
          productBloc.product!.largeDescription != ""
              ? Padding(
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
                      Center(
                        child:
                            productBloc.product!.largeDescription!.length > 108
                                ? GestureDetector(
                                    //  onTap: () => _expand(),
                                    child: Text(
                                      productBloc.isExpanded
                                          ? "Ver menos"
                                          : "Ver más",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                      ),
                      const SizedBox(height: 15),
                      const Divider(
                        color: kDividerColor,
                        thickness: 1,
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          const BuildTechnicalBanners()
        ],
      ),
    );
  }
}

class BuildTechnicalBanners extends StatelessWidget {
  const BuildTechnicalBanners({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productBloc = context.read<ProductBloc>();
    const cloudFront = Environment.API_DAO;

    return Column(
      children: List.generate(
        productBloc.product!.galleryDescription!.length,
        (index) {
          final product = productBloc.product!.galleryDescription![index];
          return GestureDetector(
            onTap: () {
              productBloc.onChangedIndex(index: index);
              productBloc.onOpenGallery(
                context: context,
                isAppBar: false,
                managerTypePhotoViewer: ManagerTypePhotoViewer.single,
              );
            },
            child: Hero(
              tag: product.id!,
              child: AspectRatio(
                aspectRatio: product.aspectRatio!,
                child: CachedNetworkImage(
                  imageUrl: "$cloudFront/${product.src}",
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    decoration: const BoxDecoration(shape: BoxShape.rectangle),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/no-image.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
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
        DialogHelper().settingModalBottomSpecs(
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
