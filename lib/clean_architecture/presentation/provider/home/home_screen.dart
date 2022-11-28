import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/banners.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/category.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/home/home_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/search_detail/search_detail_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/search_keyword/search_keyword_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/categories_list.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/header.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/item_main_product.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/lottie_animation.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/paged_sliver_masonry_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final homeBloc = context.read<HomeBloc>();

    homeBloc.pagingController.addPageRequestListener((pageKey) {
      homeBloc.fetchPage(pageKey);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.watch<HomeBloc>();

    return Stack(
      children: <Widget>[
        RefreshIndicator(
          notificationPredicate: (ScrollNotification scrollNotification) =>
              true,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async {
            homeBloc.reloadPagination = true;
            await Future.sync(
              () => homeBloc.pagingController.refresh(),
            );
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
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 0.0),
                    child: GestureDetector(
                      onTap: () {
                        final mainBloc = context.read<MainBloc>();
                        mainBloc.onChangeIndexSelected(
                            index: 1, context: context);
                      },
                      child: const Icon(
                        Icons.shopping_basket_outlined,
                        color: Colors.black45,
                        size: 25.0,
                      ),
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
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "Seguro te gusta",
                    style: Theme.of(context).textTheme.subtitle2,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 10.0)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                sliver: PagedSliverMasonryGrid(
                  crossAxisCount: 2,
                  pagingController: homeBloc.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Product>(
                    firstPageErrorIndicatorBuilder: (context) {
                      return const LottieAnimation(
                          source: "assets/lottie/lonely-404.json");
                    },
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

        /*requestMail != null && requestMail != true
                  ? Positioned(
                bottom: 0,
                child: AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    height: 50,
                    color: Colors.grey.withOpacity(.25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Recuerde verificar su cuenta, le enviamos un correo electrónico',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          alignment: Alignment.centerRight,
                          onPressed: () {
                            _hiveStorage.save("mail", "mail_confirmed", true);
                            setState(() => _visible = false);
                          },
                          icon: Icon(CupertinoIcons.clear, size: 18),
                        )
                      ],
                    ),
                  ),
                ),
              )
                  : SizedBox(),*/
      ],
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
        return Padding(
          padding: EdgeInsets.all(getProportionateScreenWidth(15.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "Banners",
              //   style: Theme.of(context).textTheme.subtitle2,
              //   textAlign: TextAlign.start,
              // ),
              // SizedBox(height: getProportionateScreenHeight(15.0)),
              AspectRatio(
                aspectRatio: 2.55,
                child: CarouselSlider.builder(
                  carouselController: _controller,
                  options: CarouselOptions(
                    // height: getProportionateScreenHeight(140.0),
                    viewportFraction: 1,
                    initialPage: 0,
                    aspectRatio: 1.0,
                    enableInfiniteScroll: true,
                    autoPlay: false,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                  itemCount: banners[0].images!.length,
                  itemBuilder: (_, index, realIndex) {
                    final banner = banners[0].images![index];
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(kSizeBorderRounded),
                            child: Hero(
                              tag: banner.id!,
                              child: Material(
                                color: kBackGroundColor,
                                child: Ink.image(
                                  image: CachedNetworkImageProvider(
                                      "$_url/${banner.src}"),
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.bottomCenter,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (__) {
                                            return SearchDetailScreen.init(
                                              context: context,
                                              typeFilter: TypeFilter.category,
                                              category: MasterCategory(
                                                name: "pwwpwp",
                                                slug: banners[0].category!.slug,
                                              ),
                                              search: "",
                                              showBanner: true,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    splashColor:
                                        kBackGroundColor.withOpacity(0.1),
                                    // child: const Align(
                                    //   alignment: Alignment.bottomCenter,
                                    //   child: Padding(
                                    //     padding: EdgeInsets.only(bottom: 8.0),
                                    //     child: Text(
                                    //       "Lorem Ipsum is simply dummy text Lorem Ipsum is simply dum=",
                                    //       textAlign: TextAlign.center,
                                    //     ),
                                    //   ),
                                    // ),
                                    child: const SizedBox.shrink(),
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [1, 2, 3, 4].asMap().entries.map((entry) {
              //     return GestureDetector(
              //       onTap: () => _controller.animateToPage(entry.key),
              //       child: Container(
              //         width: 12.0,
              //         height: 12.0,
              //         margin: EdgeInsets.symmetric(
              //           vertical: 8.0,
              //           horizontal: 4.0,
              //         ),
              //         decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: (Theme.of(context).brightness ==
              //                 Brightness.dark
              //                 ? Colors.white
              //                 : Colors.black)
              //                 .withOpacity(
              //                 _current == entry.key ? 0.9 : 0.4)),
              //       ),
              //     );
              //   }).toList(),
              // ),
              SizedBox(height: getProportionateScreenHeight(15.0)),
              Align(
                alignment: Alignment.center,
                child: AnimatedSmoothIndicator(
                  activeIndex: _current,
                  count: 3,
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
          ),
        );
      },
    );
  }
}
