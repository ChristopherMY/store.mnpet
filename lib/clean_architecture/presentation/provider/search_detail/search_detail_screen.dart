import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/search_detail/search_detail_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/item_main_product.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/loadany.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/lottie_animation.dart';

class SearchDetailScreen extends StatelessWidget {
  const SearchDetailScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider<SearchDetailBloc>(
      create: (context) => SearchDetailBloc(),
      child: SearchDetailScreen.init(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfafafa),
      // endDrawer: new SizedBox(
      //   width: getProportionateScreenWidth(310),
      //   child: new Drawer(
      //     backgroundColor: const Color(0xFFfafafa),
      //     child: new ValueListenableBuilder(
      //       valueListenable: isFilteredLoaded,
      //       builder: (context, bool isReady, child) => isReady
      //           ? new SingleChildScrollView(
      //         physics: const NeverScrollableScrollPhysics(),
      //         child: new Padding(
      //           padding: new EdgeInsets.only(
      //             left: 0,
      //             bottom: 0,
      //             right: 0,
      //             top: getProportionateScreenHeight(65),
      //           ),
      //           child: new ConstrainedBox(
      //             constraints: new BoxConstraints(
      //               minWidth: SizeConfig.screenWidth,
      //               minHeight: getProportionateScreenHeight(
      //                 SizeConfig.screenHeight,
      //               ),
      //             ),
      //             child: new IntrinsicHeight(
      //               child: new Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: <Widget>[
      //                   new SizedBox(
      //                     height: 120,
      //                     child: new Padding(
      //                       padding: const EdgeInsets.only(top: 10),
      //                       child: new Column(
      //                         crossAxisAlignment:
      //                         CrossAxisAlignment.start,
      //                         children: <Widget>[
      //                           new Container(
      //                             height: 20,
      //                             child: const Text(
      //                               "Rango de precios",
      //                               style: const TextStyle(
      //                                 fontSize: 15,
      //                                 fontWeight: FontWeight.w700,
      //                               ),
      //                             ),
      //                             padding:
      //                             const EdgeInsets.only(left: 15),
      //                           ),
      //                           const SizedBox(height: 10),
      //                           new Container(
      //                             height: 80,
      //                             decoration: const BoxDecoration(
      //                               color: Colors.white,
      //                             ),
      //                             child: new Column(
      //                               mainAxisAlignment:
      //                               MainAxisAlignment.center,
      //                               children: <Widget>[
      //                                 new Stack(
      //                                   children: <Widget>[
      //                                     new Padding(
      //                                       padding:
      //                                       const EdgeInsets.only(
      //                                         left: 10,
      //                                         right: 10,
      //                                         bottom: 10,
      //                                       ),
      //                                       child: new DefaultTextStyle(
      //                                         style: const TextStyle(
      //                                           fontWeight:
      //                                           FontWeight.w700,
      //                                           color: Colors.black,
      //                                         ),
      //                                         child: new Row(
      //                                           children: <Widget>[
      //                                             new Expanded(
      //                                               child: new Text(
      //                                                 "S/ $_lowerValue",
      //                                               ),
      //                                             ),
      //                                             new Text(
      //                                                 "S/ $_upperValue"),
      //                                           ],
      //                                         ),
      //                                       ),
      //                                     ),
      //                                     new InkWell(
      //                                       child: new Padding(
      //                                         padding:
      //                                         const EdgeInsets.only(
      //                                             top: 8),
      //                                         child: new FlutterSlider(
      //                                           values: <double>[
      //                                             _lowerValue,
      //                                             _upperValue
      //                                           ],
      //                                           rangeSlider: true,
      //                                           max: defaultMax,
      //                                           min: defaultMin,
      //                                           handlerWidth: 20,
      //                                           handlerHeight: 20,
      //                                           handler:
      //                                           new FlutterSliderHandler(
      //                                             //disabled: true,
      //                                             decoration:
      //                                             const BoxDecoration(
      //                                               color: kPrimaryColor,
      //                                               shape:
      //                                               BoxShape.circle,
      //                                             ),
      //                                             child: SizedBox(),
      //                                           ),
      //                                           rightHandler:
      //                                           FlutterSliderHandler(
      //                                             // disabled: true,
      //                                             decoration:
      //                                             BoxDecoration(
      //                                               color: kPrimaryColor,
      //                                               shape:
      //                                               BoxShape.circle,
      //                                             ),
      //                                             child: SizedBox(),
      //                                           ),
      //                                           handlerAnimation:
      //                                           FlutterSliderHandlerAnimation(
      //                                             scale: 1,
      //                                           ),
      //                                           trackBar:
      //                                           FlutterSliderTrackBar(
      //                                             activeTrackBar:
      //                                             BoxDecoration(
      //                                               color: kPrimaryColor,
      //                                             ),
      //                                           ),
      //                                           tooltip:
      //                                           FlutterSliderTooltip(
      //                                             disabled: false,
      //                                             //  alwaysShowTooltip: false,
      //                                             format: (String value) {
      //                                               return "S/ " + value;
      //                                             },
      //                                           ),
      //                                           onDragCompleted:
      //                                               (handlerIndex,
      //                                               lowerValue,
      //                                               upperValue) {
      //                                             setState(() {});
      //                                           },
      //                                           onDragging: (handlerIndex,
      //                                               lowerValue,
      //                                               upperValue) {
      //                                             _lowerValue =
      //                                                 lowerValue;
      //                                             _upperValue =
      //                                                 upperValue;
      //                                           },
      //                                         ),
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ],
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                   _buildAttributes(
      //                     attributes:
      //                     filterSearchProducts.filters.attribute,
      //                   ),
      //                   filterSearchProducts.filters.categories.length > 0
      //                       ? Container(
      //                     height: 120,
      //                     width: double.infinity,
      //                     padding: EdgeInsets.only(top: 10),
      //                     child: Column(
      //                       crossAxisAlignment:
      //                       CrossAxisAlignment.start,
      //                       children: <Widget>[
      //                         Padding(
      //                           padding: EdgeInsets.only(left: 15),
      //                           child: Container(
      //                             height: 20,
      //                             child: Text(
      //                               "Categorias",
      //                               style: TextStyle(
      //                                 fontSize: 15,
      //                                 fontWeight: FontWeight.w700,
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                         SizedBox(height: 10),
      //                         Container(
      //                           height: 80,
      //                           color: Colors.white,
      //                           width: double.infinity,
      //                           //padding: EdgeInsets.only(left: 15),
      //                           child: SingleChildScrollView(
      //                             scrollDirection: Axis.horizontal,
      //                             child: Row(children: [
      //                               for (int index = 0;
      //                               index <
      //                                   filterSearchProducts
      //                                       .filters
      //                                       .categories
      //                                       .length;
      //                               index++)
      //                                 InkWell(
      //                                   onTap: () {
      //                                     onChangeCheckedCategories(
      //                                       filterCategories:
      //                                       filterSearchProducts
      //                                           .filters
      //                                           .categories,
      //                                       position: index,
      //                                     );
      //                                   },
      //                                   child: Container(
      //                                     margin: EdgeInsets.only(
      //                                         left: 15),
      //                                     constraints:
      //                                     BoxConstraints(
      //                                       maxHeight: 40,
      //                                       minHeight: 40,
      //                                       minWidth: 65,
      //                                     ),
      //                                     decoration: BoxDecoration(
      //                                       border: Border.all(
      //                                         color: filterSearchProducts
      //                                             .filters
      //                                             .categories[
      //                                         index]
      //                                             .checked
      //                                             ? kPrimaryColor
      //                                             : Colors.black54,
      //                                         width: 1,
      //                                       ),
      //                                       borderRadius:
      //                                       BorderRadius
      //                                           .circular(5),
      //                                     ),
      //                                     child: Container(
      //                                       alignment:
      //                                       Alignment.center,
      //                                       width: double.parse(
      //                                           ((filterSearchProducts
      //                                               .filters
      //                                               .categories[
      //                                           index]
      //                                               .name
      //                                               .length) *
      //                                               5)
      //                                               .toString()),
      //                                       decoration:
      //                                       BoxDecoration(
      //                                         borderRadius:
      //                                         BorderRadius
      //                                             .circular(5),
      //                                         color: filterSearchProducts
      //                                             .filters
      //                                             .categories[
      //                                         index]
      //                                             .checked
      //                                             ? kPrimaryColor
      //                                             : Colors.white,
      //                                       ),
      //                                       child: Text(
      //                                         filterSearchProducts
      //                                             .filters
      //                                             .categories[index]
      //                                             .name,
      //                                         textAlign:
      //                                         TextAlign.center,
      //                                         style: TextStyle(
      //                                           fontSize: 12,
      //                                           color: filterSearchProducts
      //                                               .filters
      //                                               .categories[
      //                                           index]
      //                                               .checked
      //                                               ? Colors.white
      //                                               : Colors.black,
      //                                           fontWeight:
      //                                           FontWeight.w700,
      //                                         ),
      //                                       ),
      //                                     ),
      //                                   ),
      //                                 ),
      //                             ]),
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   )
      //                       : SizedBox(),
      //                   filterSearchProducts.filters.productType.length >
      //                       0
      //                       ? InkWell(
      //                     onTap: (() =>
      //                         _showProductsTypesFilter(context)),
      //                     child: Container(
      //                       padding: EdgeInsets.only(
      //                         left: 15,
      //                         bottom: 5,
      //                         right: 15,
      //                         top: 10,
      //                       ),
      //                       child: Row(
      //                         children: [
      //                           Expanded(
      //                             child: Column(
      //                               mainAxisAlignment:
      //                               MainAxisAlignment.center,
      //                               children: [
      //                                 Container(
      //                                   alignment:
      //                                   Alignment.centerLeft,
      //                                   height: 30,
      //                                   child: Text(
      //                                     "Tipo Producto",
      //                                     style: TextStyle(
      //                                         fontSize: 15,
      //                                         fontWeight:
      //                                         FontWeight.w700),
      //                                   ),
      //                                 ),
      //                                 Container(
      //                                   child: Row(
      //                                     children: [
      //                                       Flexible(
      //                                         child: Text(
      //                                           titlesProductsTypes !=
      //                                               "" &&
      //                                               titlesProductsTypes
      //                                                   .isNotEmpty
      //                                               ? titlesProductsTypes
      //                                               : "Seleccione algunos tipos",
      //                                           style: TextStyle(
      //                                             fontSize: 12,
      //                                             color: Colors
      //                                                 .black54,
      //                                           ),
      //                                           maxLines: 2,
      //                                           overflow:
      //                                           TextOverflow
      //                                               .ellipsis,
      //                                         ),
      //                                       )
      //                                     ],
      //                                   ),
      //                                 ),
      //                               ],
      //                             ),
      //                           ),
      //                           Container(
      //                             alignment: Alignment.centerRight,
      //                             child: Icon(
      //                               Icons.arrow_forward_ios,
      //                               size: 15,
      //                               color: Colors.black,
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   )
      //                       : SizedBox(),
      //                   SizedBox(height: 15),
      //                   Container(
      //                     height: 100,
      //                     width: double.infinity,
      //                     color: Colors.white,
      //                     child: Padding(
      //                       padding: EdgeInsets.only(left: 15, right: 15),
      //                       child: Column(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         children: [
      //                           Row(
      //                             children: [
      //                               Expanded(
      //                                 child: InkWell(
      //                                   onTap: () =>
      //                                       Navigator.pop(context),
      //                                   child: Container(
      //                                     alignment: Alignment.center,
      //                                     height: 40,
      //                                     decoration: BoxDecoration(
      //                                       border: Border.all(
      //                                           color: Colors.black),
      //                                       borderRadius:
      //                                       BorderRadius.circular(15),
      //                                       color: Colors.white,
      //                                     ),
      //                                     child: Text("Cancelar"),
      //                                   ),
      //                                 ),
      //                               ),
      //                               SizedBox(width: 10),
      //                               Expanded(
      //                                 child: InkWell(
      //                                   onTap: () {
      //                                     isLoadingMore = true;
      //                                     _page = 1;
      //                                     _products.clear();
      //                                     getLoadMore();
      //                                     getFilters();
      //
      //                                     Navigator.pop(context);
      //                                   },
      //                                   child: Container(
      //                                     alignment: Alignment.center,
      //                                     height: 40,
      //                                     decoration: BoxDecoration(
      //                                         border: Border.all(
      //                                             color: kPrimaryColor),
      //                                         borderRadius:
      //                                         BorderRadius.circular(
      //                                             15),
      //                                         color: kPrimaryColor),
      //                                     child: Text(
      //                                       "Aplicar",
      //                                       style: TextStyle(
      //                                         color: Colors.white,
      //                                       ),
      //                                     ),
      //                                   ),
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                           SizedBox(height: 10),
      //                           GestureDetector(
      //                             onTap: clearFilter,
      //                             child: Text(
      //                               "Filtrar otra vez",
      //                               style: TextStyle(
      //                                 decoration:
      //                                 TextDecoration.underline,
      //                               ),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   )
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ),
      //       )
      //           : SizedBox(),
      //     ),
      //   ),
      // ),
      body: LoadAny(
        onLoadMore: () async {},
        status: LoadStatus.completed,
        loadingMsg: 'Cargando... ',
        errorMsg: 'Error de carga, haga clic en reintentar',
        finishMsg: 'Seguiremos trabajando para tener los productos que buscas',
        endLoadMore: false,
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          primary: true,
          //physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
              ),
              title: Text(
                "widget.title",
                style: TextStyle(
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
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   PageTransition(
                    //     type: PageTransitionType.fade,
                    //     child: SearchScreen(),
                    //   ),
                    // );
                  },
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
                          horizontal: 10.0, vertical: 9.0),
                      child: SizedBox(
                        height: 32.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () {},
                              child: Row(
                                children: const <Widget>[
                                  Icon(Icons.filter_list),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text('Filtro'),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // _showSortOptions(context)
                              },
                              child: Row(
                                children: <Widget>[
                                  const Icon(Icons.import_export),
                                  Container(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Ordenar {selectItem != "
                                      " ? ': selectItem' : ''}",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // pageViewGrid = !pageViewGrid;
                                // setState(() {});
                              },
                              icon: Icon(
                                // pageViewGrid
                                true ? Icons.view_module : Icons.view_list,
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
              padding: const EdgeInsets.all(10.0),
              sliver: SliverToBoxAdapter(
                child: MasonryGrid(
                  // column: pageViewGrid ? 2 : 1,
                  column: 1,
                  staggered: false,
                  crossAxisSpacing: 0,
                  // crossAxisSpacing: pageViewGrid ? 8 : 0,
                  // mainAxisSpacing: pageViewGrid ? 8 : 12,
                  mainAxisSpacing: 12,
                  children: List.generate(
                    8,
                    // _products.length,
                    // (index) => pageViewGrid
                     (index) => true
                        ? TrendingItemMain(
                            product: _products[index],
                            gradientColors: [
                              const Color(0xFFF28767),
                              Colors.orange[400]
                            ],
                          )
                        : TrendingItemMainGrid(
                            product: _products[index],
                            gradientColors: [
                              Color(0xFFF28767),
                              Colors.orange[400]
                            ],
                          ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(15.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 350,
                      child: LottieAnimation(
                        source: "assets/lottie/shake-a-empty-box.json",
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: getProportionateScreenWidth(280),
                      child: const Text(
                        "No hay productos que coincidan con tu búsqueda",
                        style: TextStyle(fontSize: 18.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    const Text("Intenta cambiando algunas opciones"),
                    const SizedBox(height: 10.0),
                    // const SubmitButton(
                    //   title: "Limpiar todos los filtros",
                    //   act: () => clearFilter(back: false),
                    // )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
