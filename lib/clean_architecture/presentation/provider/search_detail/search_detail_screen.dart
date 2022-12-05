import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/category.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/keyword.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/product_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/search_detail/components/search_detail_filter.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/search_detail/search_detail_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/dialog_helper.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/item_main_product.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/item_main_product_grid.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/lottie_animation.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/marquesinas_effect.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/paged_sliver_masonry_grid.dart';

import '../../widget/shake_transition.dart';

class SearchDetailScreen extends StatefulWidget {
  const SearchDetailScreen._({
    Key? key,
    required this.typeFilter,
    this.search,
    this.keyword,
    this.categories,
    this.showBanner = false,
    this.imageUrl = "",
  }) : super(key: key);

  final String? search;
  final Keyword? keyword;
  final TypeFilter typeFilter;
  final List<MasterCategory>? categories;
  final bool? showBanner;
  final String? imageUrl;

  static Widget init({
    required BuildContext context,
    required TypeFilter typeFilter,
    bool? showBanner = false,
    String? search,
    Keyword? keywords,
    List<MasterCategory>? categories,
    String? imageUrl,
  }) {
    return ChangeNotifierProvider<SearchDetailBloc>(
      create: (context) => SearchDetailBloc(
        productRepositoryInterface: context.read<ProductRepositoryInterface>(),
      )
        ..bindingSearch.keywords =
            typeFilter == TypeFilter.keyword ? [keywords!.slug!] : []
        ..bindingSearch.search = typeFilter == TypeFilter.search ? search! : ""
        ..bindingSearch.categories = (typeFilter == TypeFilter.category
                ? categories!.map((e) => e.slug).toList()
                : [])
            .cast<String>(),
      builder: (_, __) => SearchDetailScreen._(
        typeFilter: typeFilter,
        keyword: keywords,
        search: search,
        categories: categories,
        showBanner: showBanner,
        imageUrl: imageUrl,
      ),
    );
  }

  @override
  State<SearchDetailScreen> createState() => _SearchDetailScreenState();
}

class _SearchDetailScreenState extends State<SearchDetailScreen> {
  @override
  void initState() {
    final searchDetailsBloc = context.read<SearchDetailBloc>();

    searchDetailsBloc.bindingSearchFilter = searchDetailsBloc.bindingSearch;
    searchDetailsBloc.context = context;
    searchDetailsBloc.pagingController.addPageRequestListener((pageKey) async {
      await searchDetailsBloc.searchProductDetails(pageKey);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final searchDetailBloc = context.watch<SearchDetailBloc>();

    return SafeArea(
      child: LoaderOverlay(
        child: Scaffold(
          drawerEnableOpenDragGesture: false,
          backgroundColor: kBackGroundColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                centerTitle: true,
                backgroundColor: Colors.white,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                ),
                title: MarquesinasEffect(
                  titles: widget.typeFilter == TypeFilter.search
                      ? [widget.search!]
                      : widget.typeFilter == TypeFilter.category
                          ? widget.categories!.map((e) => e.name!).toList()
                          : [widget.keyword!.name!],
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_outlined),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                expandedHeight: getProportionateScreenHeight(100),
                automaticallyImplyLeading: false,
                iconTheme: const IconThemeData(
                  color: Colors.black, /*change your color here*/
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
                floating: true,
                pinned: false,
                snap: false,
                flexibleSpace: FlexibleSpaceBar(
                  //collapseMode: CollapseMode.pin,
                  background: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10.0,
                        ),
                        child: SizedBox(
                          height: 32.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return SearchDetailFilter.init(context);
                                      },
                                    ),
                                  );
                                },
                                child: Row(
                                  children: const <Widget>[
                                    Icon(Icons.filter_list),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: Text('Filtro'),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  DialogHelper.showSortOptions(context);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const <Widget>[
                                    Icon(Icons.import_export),
                                    Text("Ordenar"),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: searchDetailBloc.handleChangeGrid,
                                child: Icon(
                                  searchDetailBloc.isGridList
                                      ? Icons.view_module
                                      : Icons.view_list,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (widget.showBanner!)
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(14.0),
                    vertical: getProportionateScreenHeight(15.0),
                  ),
                  sliver: SliverToBoxAdapter(
                    child: ShakeTransition(
                      duration: const Duration(seconds: 1),
                      offset: 50,
                      child: Hero(
                        tag: widget.imageUrl!,
                        child: CachedNetworkImage(
                          imageUrl: widget.imageUrl!,
                        ),
                      ),
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                sliver: SliverAnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: PagedSliverMasonryGrid(
                    key: UniqueKey(),
                    crossAxisCount: searchDetailBloc.isGridList ? 2 : 1,
                    pagingController: searchDetailBloc.pagingController,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    builderDelegate: PagedChildBuilderDelegate<Product>(
                      itemBuilder: (context, item, index) {
                        if (searchDetailBloc.isGridList) {
                          return TrendingItemMain(
                            product: item,
                            gradientColors: const [
                              Color(0xFFF28767),
                              Color(0xFFFFA726),
                            ],
                          );
                        }

                        return TrendingItemMainGrid(
                          product: item,
                          gradientColors: const [
                            Color(0xFFF28767),
                            Color(0xFFFFA726),
                          ],
                        );
                      },
                      noItemsFoundIndicatorBuilder: (context) {
                        return const LottieAnimation(
                          source: "assets/lottie/shake-a-empty-box.json",
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
