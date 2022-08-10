import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/home/home_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/categories_view.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/item_main_product.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/loadany.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.watch<HomeBloc>();

    return Stack(
      children: <Widget>[
        RefreshIndicator(
          notificationPredicate: 1 == 1 ? (_) => true : (_) => false,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async {
            homeBloc.reloadPagination = true;

            homeBloc.products.value = await homeBloc.paginationProducts();
          },
          child: ValueListenableBuilder(
            valueListenable: homeBloc.loadStatus,
            builder: (context, LoadStatus value, child) {
              return LoadAny(
                status: value,
                loadingMsg: 'Cargando... ',
                errorMsg: 'Error de carga, haga clic en reintentar ',
                finishMsg:
                    'Seguiremos trabajando para tener los productos que buscas.',
                endLoadMore: false,
                onLoadMore: () async {
                  List<Product> response = await homeBloc.paginationProducts();
                  final products = homeBloc.products.value;
                  products.addAll(response);

                  homeBloc.products.value = products;
                },
                // onLoadFilters: () {},
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      pinned: true,
                      snap: false,
                      floating: false,
                      toolbarHeight: 56.0,
                      backgroundColor: kPrimaryColor,
                      systemOverlayStyle: const SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        statusBarIconBrightness: Brightness.dark,
                      ),
                      expandedHeight: getProportionateScreenHeight(56.0),
                      titleSpacing: 0,
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 7.0,
                          horizontal: 12.0
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Image.asset(
                                "assets/px-mn-white.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                child: Container(
                                  height: 40,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(18.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 2.5,
                                      right: 2.5,
                                      bottom: 2.5,
                                      left: 8.0,
                                    ),
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            "Buscar....",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                        ),
                                        InkWell(
                                          child: Container(
                                            height: double.infinity,
                                            width: 55.0,
                                            decoration: BoxDecoration(
                                              //color: kPrimaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                                  kPrimaryColor,
                                                  kPrimaryColor
                                                      .withOpacity(.65),
                                                ],
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.search,
                                              color: Colors.white,
                                              size: 26.0,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: const Icon(
                                Icons.shopping_basket_outlined,
                                color: Colors.black45,
                                size: 25.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CategoriesListView(
                        categories: homeBloc.categoriesList,
                        status: LoadStatus.normal,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 10.0),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          "Seguro te gusta",
                          style: Theme.of(context).textTheme.subtitle2,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 10)),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      sliver: SliverToBoxAdapter(
                        child: MasonryGrid(
                          column: 2,
                          staggered: false,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          children: List.generate(
                            homeBloc.products.value.length,
                            (index) => TrendingItemMain(
                              product: homeBloc.products.value[index],
                              gradientColors: const [
                                Color(0xFFF28767),
                                Color(0xFFFFA726),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
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
