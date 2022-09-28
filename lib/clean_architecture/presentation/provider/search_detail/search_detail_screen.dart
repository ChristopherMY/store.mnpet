import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/keyword.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/product_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/search_detail/components/search_detail_filter.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/search_detail/search_detail_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/dialog_helper.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/item_main_product.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/item_main_product_grid.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/paged_sliver_masonry_grid.dart';

class SearchDetailScreen extends StatefulWidget {
  const SearchDetailScreen._({
    Key? key,
    this.search,
    this.keywords,
    required this.isSearch,
  }) : super(key: key);

  final String? search;
  final Keyword? keywords;
  final bool isSearch;

  static Widget init({
    required BuildContext context,
    String? search,
    Keyword? keywords,
    required bool isSearch,
  }) {
    return ChangeNotifierProvider<SearchDetailBloc>(
      create: (context) => SearchDetailBloc(
        productRepositoryInterface: context.read<ProductRepositoryInterface>(),
      )
        ..bindingSearch.keywords = isSearch ? [] : [keywords!.slug!]
        ..bindingSearch.search = search!,
      builder: (_, __) => SearchDetailScreen._(
        isSearch: isSearch,
        keywords: keywords,
        search: search,
      ),
    );
  }

  @override
  State<SearchDetailScreen> createState() => _SearchDetailScreenState();
}

class _SearchDetailScreenState extends State<SearchDetailScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

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
          key: _key,
          drawerEnableOpenDragGesture: false,
          backgroundColor: kBackGroundColor,
          body: CustomScrollView(
            scrollDirection: Axis.vertical,
            primary: true,
            slivers: [
              SliverAppBar(
                centerTitle: true,
                backgroundColor: Colors.white,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                ),
                title: Text(
                  widget.isSearch ? widget.search! : widget.keywords!.name!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.search),
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
                          vertical: 9.0,
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
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10.0,
                ),
                sliver: PagedSliverMasonryGrid(
                  crossAxisCount: searchDetailBloc.isGridList ? 2 : 1,
                  pagingController: searchDetailBloc.pagingController,
                  mainAxisSpacing: 3,
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
                  ),
                ),
              ),
              // SliverPadding(
              //   padding: const EdgeInsets.all(15.0),
              //   sliver: SliverToBoxAdapter(
              //     child: Column(
              //       children: [
              //         const SizedBox(
              //           height: 350,
              //           child: LottieAnimation(
              //             source: "assets/lottie/shake-a-empty-box.json",
              //           ),
              //         ),
              //         const SizedBox(height: 20.0),
              //         SizedBox(
              //           width: getProportionateScreenWidth(280),
              //           child: const Text(
              //             "No hay productos que coincidan con tu búsqueda",
              //             style: TextStyle(fontSize: 18.0),
              //             textAlign: TextAlign.center,
              //           ),
              //         ),
              //         const SizedBox(height: 15.0),
              //         const Text("Intenta cambiando algunas opciones"),
              //         const SizedBox(height: 10.0),
              //         // const SubmitButton(
              //         //   title: "Limpiar todos los filtros",
              //         //   act: () => clearFilter(back: false),
              //         // )
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
