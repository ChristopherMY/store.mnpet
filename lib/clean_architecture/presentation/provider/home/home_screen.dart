import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/category.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/home/home_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
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
              const SliverToBoxAdapter(
                child: SizedBox(height: 10.0),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 10.0,
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
                  horizontal: 8.0,
                  vertical: 10.0,
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
  final _pageController = PageController(
    viewportFraction: 0.8,
    initialPage: 1,
  );
  double _currentPage = 0.0;

  void _listener() {
    setState(() {
      _currentPage = _pageController.page!;
    });
  }

  @override
  void initState() {
    _pageController.addListener(_listener);

    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_listener);
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: CarouselSlider.builder(
        options: CarouselOptions(
          height: 150,
          viewportFraction: 0.70,
          initialPage: 0,
          aspectRatio: 1.0,
          enableInfiniteScroll: true,
          autoPlay: true,
          enlargeCenterPage: true,
        ),
        itemCount: 1,
        itemBuilder: (context, index, realIndex) {
          return Image.network(
              "https://via.placeholder.com/668x360?text=Visit+Blogging.com+Now%20C/O%20https://placeholder.com/",
              fit: BoxFit.fitWidth);
        },
      ),
    );
  }
}
