import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/banners.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/category.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/home_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/home/home_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/search_detail/search_detail_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/search_keyword/search_keyword_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/splash/splash_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/firebase_dynamic_link.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/categories_list.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/header.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/paged_sliver_masonry_grid.dart';

import '../../widget/item_main_product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider<HomeBloc>(
      create: (context) => HomeBloc(
        homeRepositoryInterface: context.read<HomeRepositoryInterface>(),
        hiveRepositoryInterface: context.read<HiveRepositoryInterface>(),
      )..handleInitComponents(),
      builder: (context, child) => const HomeScreen._(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AfterLayoutMixin<HomeScreen> {
  Future<void> loadingScreen(BuildContext context) async {
    // final homeBloc = context.read<HomeBloc>();
    // final mainBloc = context.read<MainBloc>();

    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.decelerate;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return FadeTransition(
            opacity: animation,
            // position: animation.drive(tween),
            child: child,
          );
        },
        pageBuilder: (_, animation1, animation2) => SplashScreen.init(context),
      ),
    );

    DynamicLinksService.initDynamicLinks(context);
  }

  @override
  void initState() {
    final homeBloc = context.read<HomeBloc>();

    homeBloc.init();
    super.initState();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) =>
      loadingScreen(context);

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();

    print("RECARGO HOME SCREEN");
    return RefreshIndicator(
      notificationPredicate: (ScrollNotification scrollNotification) => true,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        homeBloc.reloadPagination = true;
        homeBloc.pagingController.refresh();
      },
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            toolbarHeight: 56.0,
            backgroundColor: kBackGroundColor,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: kPrimaryColor,
              statusBarIconBrightness: Brightness.light,
            ),
            expandedHeight: getProportionateScreenHeight(56.0),
            titleSpacing: 0,
            elevation: 0.0,
            title: Header(
              showLogo: true,
              onSearch: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return SearchKeywordScreen.init(context);
                    },
                  ),
                );
              },
              onField: () {},
            ),
            actions: [
              IconButton(
                onPressed: () {
                  final mainBloc = context.read<MainBloc>();
                  mainBloc.onChangeIndexSelected(
                    index: 1,
                    context: context,
                  );
                },
                icon: const Icon(
                  Icons.shopping_basket_outlined,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: ValueListenableBuilder(
              valueListenable: homeBloc.categoriesList,
              builder: (context, List<MasterCategory> categories, child) {
                return Categories(
                  categories: categories,
                  status: LoadStatus.normal,
                  backgroundColor: kBackGroundColor,
                );
              },
            ),
          ),
          const SliverToBoxAdapter(
            child: BannersSection(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10.0)),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(15.0),
              vertical: getProportionateScreenHeight(5.0),
            ),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Seguro te gusta",
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10.0)),

          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(11.0),
            ),
            sliver: PagedSliverMasonryGrid(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              pagingController: homeBloc.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Product>(
                // firstPageErrorIndicatorBuilder: (context) {
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
                // noItemsFoundIndicatorBuilder: (context) {
                //   return const LottieAnimation(
                //     source: "assets/lottie/shake-a-empty-box.json",
                //   );
                // },
              ),
            ),
          ),

          // SliverPadding(
          //     padding: EdgeInsets.symmetric(
          //       horizontal: getProportionateScreenWidth(11.0),
          //     ),
          //   sliver: PagedSliverGrid(
          //     pagingController: homeBloc.pagingController,
          //     builderDelegate: PagedChildBuilderDelegate<Product>(
          //       itemBuilder: (context, item, index) {
          //         return TrendingItemMain(
          //           product: item,
          //           gradientColors: const [
          //             Color(0xFFF28767),
          //             Color(0xFFFFA726),
          //           ],
          //         );
          //       },
          //     ),
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2,
          //       childAspectRatio: 0.75,
          //       //mainAxisExtent: 99,
          //       crossAxisSpacing: 5,
          //       mainAxisSpacing: 5,
          //     ),
          //   ),
          // ),

          // PagedSliverList<int, Product>(
          //   pagingController: homeBloc.pagingController,
          //   builderDelegate: PagedChildBuilderDelegate<Product>(
          //
          //     itemBuilder: (context, item, index) {
          //       return TrendingItemMain(
          //         product: item,
          //         gradientColors: const [
          //           Color(0xFFF28767),
          //           Color(0xFFFFA726),
          //         ],
          //       );
          //     },
          //   ),
          // ),
          SliverToBoxAdapter(
            child: SizedBox(height: getProportionateScreenHeight(65.0)),
          ),
        ],
      ),
    );
  }
}

class BannersSection extends StatefulWidget {
  const BannersSection({Key? key}) : super(key: key);

  @override
  State<BannersSection> createState() => _BannersSectionState();
}

class _BannersSectionState extends State<BannersSection> {
  final CarouselController _controller = CarouselController();
  final String _url = Environment.API_DAO;
  int _current = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();

    return ValueListenableBuilder<List<Banners>>(
      valueListenable: homeBloc.bannersList,
      builder: (context, banners, child) {
        if (banners.isEmpty) return const SizedBox.shrink();

        // double aspectRatio = banners
        //     .map((e) =>
        //         e.banners!.fold(
        //             0,
        //             (previousValue, element) =>
        //                 element.image!.aspectRatio! +
        //                 element.image!.aspectRatio!) /
        //         e.banners!.length)
        //     .first;

        return Column(
          children: banners.map((banner) {
            double aspectRatio = banner.banners!
                .reduce((value, element) =>
                    value.image!.aspectRatio! > element.image!.aspectRatio!
                        ? value
                        : element)
                .image!
                .aspectRatio!;

            return Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(15.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (banner.visibility!.name!) ...[
                    Text(
                      banner.name!,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    SizedBox(height: getProportionateScreenHeight(15.0)),
                  ],
                  if (banner.banners!.isNotEmpty) ...[
                    AspectRatio(
                      aspectRatio: aspectRatio,
                      child: CarouselSlider.builder(
                        carouselController: _controller,
                        options: CarouselOptions(
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          autoPlay: false,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                        itemCount: banner.banners!.length,
                        itemBuilder: (_, index, realIndex) {
                          final bannerDetail = banner.banners![index];
                          return Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(kSizeBorderRounded),
                                  child: Hero(
                                    tag: "$_url/${bannerDetail.image!.src!}",
                                    child: Material(
                                      color: kBackGroundColor,
                                      child: Ink.image(
                                        image: CachedNetworkImageProvider(
                                          "$_url/${bannerDetail.image!.src!}",
                                        ),
                                        fit: BoxFit.fitWidth,
                                        alignment: Alignment.bottomCenter,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (__) {
                                                  return SearchDetailScreen
                                                      .init(
                                                    context: context,
                                                    typeFilter:
                                                        TypeFilter.category,
                                                    categories:
                                                        banner.isContainer!
                                                            ? bannerDetail
                                                                .categories!
                                                            : banner.categories,
                                                    search: "",
                                                    showBanner: true,
                                                    imageUrl:
                                                        "$_url/${bannerDetail.image!.src!}",
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          splashColor:
                                              kBackGroundColor.withOpacity(0.1),
                                          child: banner.visibility!.description!
                                              ? Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                      banner.description!,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // const Positioned(
                              //   left: 10,
                              //   right: 10,
                              //   bottom: 10,
                              //   child: Text(
                              //     "Lorem Ipsum is simply dummy text ",
                              //     textAlign: TextAlign.center,
                              //   ),
                              // ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(15.0)),
                    Align(
                      alignment: Alignment.center,
                      child: AnimatedSmoothIndicator(
                        activeIndex: _current,
                        count: banner.banners!.length,
                        onDotClicked: (entry) {
                          _controller.animateToPage(entry);
                        },
                        effect: const WormEffect(
                          dotHeight: 11.0,
                          dotWidth: 11.0,
                          activeDotColor: Colors.red,
                          paintStyle: PaintingStyle.fill,
                          type: WormType.normal,
                        ),
                      ),
                    )
                  ],
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
