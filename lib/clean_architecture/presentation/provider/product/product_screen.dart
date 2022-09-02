import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:collection/collection.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/general.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/components/body/bottom_navigation_bar.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/components/body/info_attributes.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/components/body/info_shipment.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/components/body/product_price.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/product_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/dotted_swiper.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/item_main_product.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/loadany.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/photoview_wrapper.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/star_rating.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({Key? key}) : super(key: key);

  final General _general = General();
  final _cloudFront = Environment.API_DAO;

  @override
  Widget build(BuildContext context) {
    final productBloc = context.watch<ProductBloc>();
    if (productBloc.isLoadingPage) {
      return const Placeholder();
    } else {
      final product = productBloc.product!;
      final products = productBloc.productsList;
      return Scaffold(
        // key: _scaffoldKey,
        appBar: AppBar(
          // backgroundColor: kPrimaryColor,
          // systemOverlayStyle: const SystemUiOverlayStyle(
          //   statusBarColor: kPrimaryColor,
          //   //statusBarIconBrightness: Brightness.light,
          // ),
          bottomOpacity: 0,
          shadowColor: Colors.transparent,
          toolbarHeight: 0,
        ),
        backgroundColor: Colors.white,
        body: ValueListenableBuilder(
          valueListenable: productBloc.loadStatus,
          builder: (context, LoadStatus value, child) {
            return LoadAny(
              status: value,
              loadingMsg: 'Cargando... ',
              errorMsg: 'Error de carga, haga clic en reintentar ',
              finishMsg:
                  'Seguiremos trabajando para tener los productos que buscas.',
              endLoadMore: false,
              onLoadMore: () async {
                productBloc.handleInitRelatedProductsPagination(
                  categories: product.categories!,
                );
              },
              child: CustomScrollView(
                // controller: _scrollController,
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  _buildAppBar(
                    context: context,
                    headerContent: productBloc.headerContent,
                    showSwiperPagination: productBloc.showSwiperPagination,
                    swiperController: productBloc.swiperController,
                  ),
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
                      ? _buildDescription(
                          product: product,
                          context: context,
                          isExpanded: productBloc.isExpanded,
                        )
                      : const SliverToBoxAdapter(
                          child: SizedBox(),
                        ),
                  _buildProducts(
                    context: context,
                    products: products,
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
            );
          },
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
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

  _buildDescription({
    required Product product,
    required BuildContext context,
    required bool isExpanded,
  }) {
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
          product.largeDescription != ""
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
                          product.largeDescription!,
                          maxLines: 2,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 14),
                        ),
                        secondChild: Text(
                          product.largeDescription!,
                          //textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 14),
                        ),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: kThemeAnimationDuration,
                      ),
                      const SizedBox(height: 8.0),
                      Center(
                        child: product.largeDescription!.length > 108
                            ? GestureDetector(
                                //  onTap: () => _expand(),
                                child: Text(
                                  isExpanded ? "Ver menos" : "Ver más",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ),
                      const SizedBox(height: 15),
                      _lineBreak(),
                    ],
                  ),
                )
              : const SizedBox(),
          _buildTechnicalBanners(
            galleryDescription: product.galleryDescription!,
            context: context,
            product: product,
          ),
        ],
      ),
    );
  }

  void onOpenGallery({
    required BuildContext context,
    required int index,
    required bool isAppBar,
    required ManagerTypePhotoViewer managerTypePhotoViewer,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 600),
        barrierDismissible: false,
        opaque: true,
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) =>
            FadeTransition(opacity: animation, child: child),
        pageBuilder: (_, __, ___) {
          return ChangeNotifierProvider<ProductBloc>.value(
            value: Provider.of<ProductBloc>(context),
            child: GalleryPhotoViewWrapper(
              managerTypePhotoViewer: managerTypePhotoViewer,
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              isAppBar: isAppBar,
              scrollDirection: Axis.horizontal,
            ),
          );
        },
      ),
    );
  }

  _buildTechnicalBanners({
    required List<MainImage> galleryDescription,
    required BuildContext context,
    required Product product,
  }) {
    List<Widget> list = [];
    final productBloc = Provider.of<ProductBloc>(context, listen: false);
    galleryDescription.forEachIndexed(
      (index, element) {
        list.add(
          Padding(
            padding: const EdgeInsets.all(4),
            child: GestureDetector(
              onTap: () {
                productBloc.onChangedIndex(index: index);
                onOpenGallery(
                  context: context,
                  index: index,
                  isAppBar: false,
                  managerTypePhotoViewer: ManagerTypePhotoViewer.single,
                );
              },
              child: Hero(
                tag: element.id!,
                child: AspectRatio(
                  aspectRatio: element.aspectRatio!,
                  child: CachedNetworkImage(
                    imageUrl: "$_cloudFront/${element.src}",
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
                      decoration:
                          const BoxDecoration(shape: BoxShape.rectangle),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/no-image.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    return Column(children: list);
  }

  _buildInfo({required BuildContext context, required Product product}) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          /* _containerPromo(context),*/
          _buildNoPromotion(),
          _buildInformation(product: product),
          _lineBreak(),
          const InfoAttributes(),
          _lineBreak(),
          _buildSpecs(
            specifications: product.specifications!,
            context: context,
          ),
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

  _buildNoPromotion() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
      child: ProductPrice(),
    );
  }

  _buildWhatsapp({required BuildContext context, required String description}) {
    return InkWell(
      onTap: () {
        _general.whatsappMessage(
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

  _buildSpecs({
    required List<Specification> specifications,
    required BuildContext context,
  }) {
    if (specifications.isEmpty) {
      return const SizedBox();
    } else if (specifications.length == 1) {
      if (specifications[0].body == "" || specifications[0].header == "") {
        return const SizedBox();
      }
    }

    return InkWell(
      onTap: (() => _settingModalBottomSpecs(
            context: context,
            specifications: specifications,
          )),
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
            Container(
              alignment: Alignment.centerRight,
              child: const Icon(
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

  _settingModalBottomSpecs({
    required BuildContext context,
    required List<Specification> specifications,
  }) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              color: const Color.fromRGBO(0, 0, 0, 0.001),
              child: DraggableScrollableSheet(
                initialChildSize: 0.94,
                minChildSize: 0.2,
                maxChildSize: 0.94,
                builder: (_, controller) {
                  return Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 05),
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.only(top: 05),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: SizedBox(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: double.infinity,
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  "Detalles del artículo:",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: 16,
                                              child: RawMaterialButton(
                                                onPressed: (() {
                                                  Navigator.pop(context);
                                                }),
                                                child: const Icon(
                                                  CupertinoIcons.clear,
                                                  size: 18,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: double.infinity,
                                        child: Divider(
                                          color: Color(0xE5CBCBCB),
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        child: Column(
                                          children: specifications
                                              .map(
                                                (e) => SizedBox(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child:
                                                                Text(e.header!),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                Text(e.body!),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: double.infinity,
                                                        child: Divider(
                                                          color:
                                                              Color(0xE5CBCBCB),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
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

  _lineBreak() {
    return Container(
      width: double.infinity,
      color: kDividerColor,
      height: 1,
    );
  }

  _buildInformation({required Product product}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
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
          SizedBox(
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 12, color: Colors.black),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  StarRating(
                    rating: product.rating! * 0.05,
                    size: 17,
                  ),
                  const SizedBox(width: 5),
                  Text("${product.rating! * 0.05}"),
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


  _buildProducts({
    required BuildContext context,
    required List<Product> products,
  }) {
    return MultiSliver(
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
                products.length,
                (index) => TrendingItemMain(
                  product: products[index],
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
    );
  }

  _buildAppBar({
    required BuildContext context,
    required List<Widget> headerContent,
    required ValueNotifier<bool> showSwiperPagination,
    required SwiperController swiperController,
  }) {
    return SliverAppBar(
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
      expandedHeight: 393,
      floating: false,
      pinned: true,
      snap: false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Swiper(
          layout: SwiperLayout.DEFAULT,
          controller: swiperController,
          itemCount: headerContent.length,
          itemBuilder: (_, index) => headerContent[index],
          autoplay: false,
          duration: 3,
          onTap: (index) => onOpenGallery(
            context: context,
            index: index,
            isAppBar: true,
            managerTypePhotoViewer: ManagerTypePhotoViewer.navigation,
          ),
          onIndexChanged: (index) {
            final productBloc =
                Provider.of<ProductBloc>(context, listen: false);
            productBloc.onChangedIndex(index: index);
          },
          pagination: const SwiperPagination(
            alignment: Alignment.bottomCenter,
            builder: DotCustomSwiperPaginationBuilder(
              color: Colors.grey,
              activeColor: kPrimaryColor,
            ),
          ),
          itemWidth: 300.0,
          itemHeight: 300.0,
        ),
      ),
      toolbarTextStyle: const TextStyle(fontSize: 10),
      titleTextStyle: const TextStyle(fontSize: 10),
      actions: <Widget>[
        GestureDetector(
          onTap: () => {
            /*Navigator.push(
              context!,
              PageTransition(
                type: PageTransitionType.leftToRightWithFade,
                child: SearchScreen(),
              ),
            )*/
          },
          child: const Icon(
            CommunityMaterialIcons.magnify,
            color: Colors.black,
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(CommunityMaterialIcons.cart_outline),
              color: Colors.black,
              onPressed: () => {
                // Navigator.push(
                //   context!,
                //   PageTransition(
                //     type: PageTransitionType.fade,
                //     child: MainCheckOut(showAppBar: true),
                //   ),
                // )
              },
            ),
            /*  isClicked
                ? Positioned(
                    left: 9,
                    bottom: 13,
                    child: Icon(
                      //Icons.looks_one,
                      Icons.warning_amber_sharp,
                      size: 14,
                      color: Colors.red,
                    ),
                  )
                : SizedBox(),*/
          ],
        ),
      ],
    );
  }
}
