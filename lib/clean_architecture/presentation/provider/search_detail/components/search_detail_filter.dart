import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/search_detail/components/search_detail_filter_categories_section.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/search_detail/components/search_detail_filter_find_attributes.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/search_detail/components/search_detail_filter_section.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/search_detail/search_detail_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/lottie_animation.dart';

class SearchDetailFilter extends StatelessWidget {
  const SearchDetailFilter._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<SearchDetailBloc>(context, listen: false)
        ..filterProductDetails(),
      builder: (context, __) => const SearchDetailFilter._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchDetailBloc = context.read<SearchDetailBloc>();
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: searchDetailBloc.loadStatus,
        builder: (_, LoadStatus loadStatus, __) {
          return Scaffold(
            backgroundColor: kBackGroundColor,
            appBar: AppBar(
              leading: const BackButton(color: Colors.black),
              backgroundColor: Colors.white,
              title: const Text(
                "Filtros",
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              centerTitle: false,
              actions: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: AbsorbPointer(
                      absorbing: loadStatus != LoadStatus.normal,
                      child: Material(
                        borderRadius: BorderRadius.circular(25.0),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          onTap: searchDetailBloc.handleResetFilter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 20.0,
                            ),
                            child: Text(
                              "Reestablecer",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: const BodySearchDetailFilter(),
            bottomNavigationBar: BottomSheetFilter(
              child: Row(
                children: [
                  Expanded(
                    child: AbsorbPointer(
                      absorbing: loadStatus != LoadStatus.normal,
                      child: DefaultButtonAction(
                        title: "Descartar",
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: getProportionateScreenWidth(10.0)),
                  Expanded(
                    child: AbsorbPointer(
                      absorbing: loadStatus != LoadStatus.normal,
                      child: DefaultButtonAction(
                        title: "Aplicar filtros",
                        color: kPrimaryColor,
                        onPressed: searchDetailBloc.onApplyFilters,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BodySearchDetailFilter extends StatelessWidget {
  const BodySearchDetailFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchDetailBloc = context.watch<SearchDetailBloc>();
    return SingleChildScrollView(
      child: ValueListenableBuilder(
        valueListenable: searchDetailBloc.loadStatus,
        builder: (context, LoadStatus loadStatus, child) {
          if (loadStatus == LoadStatus.normal) {
            return Column(
              children: [
                SearchDetailFilterSection(
                  title: "Rango de precio",
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                    child: ValueListenableBuilder(
                      valueListenable: searchDetailBloc.currentRangeValues,
                      builder: (_, RangeValues currentRangeValues, __) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "S/ ${currentRangeValues.start.toStringAsFixed(0)}",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    "S/ ${currentRangeValues.end.toStringAsFixed(0)}",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                            ),
                            RangeSlider(
                              values: currentRangeValues,
                              activeColor: kPrimaryColor,
                              inactiveColor: Colors.grey,
                              max: searchDetailBloc.rangeMax,
                              // divisions: 9,
                              labels: RangeLabels(
                                currentRangeValues.start.round().toString(),
                                currentRangeValues.end.round().toString(),
                              ),
                              onChanged: (RangeValues values) {
                                searchDetailBloc.currentRangeValues.value =
                                    values;
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SearchDetailFilterSection(
                  title: "Categorias",
                  child: SearchDetailFilterCategoriesSection(
                    valueListenable: searchDetailBloc.category,
                    onTap: (int index) {
                      searchDetailBloc.handleChangeCategories(index);
                    },
                  ),
                ),
                SearchDetailFilterSection(
                  title: "Tipo de producto",
                  child: SearchDetailFilterCategoriesSection(
                    valueListenable: searchDetailBloc.productTypes,
                    onTap: (int index) {
                      searchDetailBloc.handleChangeProductTypes(index);
                    },
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: searchDetailBloc.attributes,
                  builder: (_, List<ProductAttribute> attributes, __) {
                    return Column(
                      children: List.generate(
                        attributes.length,
                        (index) {
                          final attribute = attributes[index];

                          final termsString = attribute.termsSelected!
                              .map((e) => e.label)
                              .join(" - ");

                          return SearchDetailFilterSection(
                            title: attribute.name!,
                            hasOptionHeader: true,
                            defaultBackground: kBackGroundColor,
                            onTap: () {
                              searchDetailBloc.attributeSelected = attribute;
                              searchDetailBloc.searchResults.value = attribute.terms!;
                              searchDetailBloc.indexProductAttribute = index;
                              // Esto no deberia de trabajar de esa manera

                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 200),
                                  transitionsBuilder: (
                                    BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    Widget child,
                                  ) {
                                    const begin = Offset(0.0, 1.0);
                                    const end = Offset.zero;
                                    final tween = Tween(begin: begin, end: end);
                                    final offsetAnimation = animation.drive(tween);
                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                  pageBuilder: (_, __, ___) {
                                    return SearchDetailFilterFindAttributes
                                        .init(context);
                                  },
                                ),
                              );
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        termsString.isEmpty
                                            ? "No tenemos seleccionado ningún ${attribute.name}"
                                            : termsString,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                 SizedBox(height: SizeConfig.screenHeight! * 0.03),
              ],
            );
          }

          return SizedBox(
            height: SizeConfig.screenHeight! - SizeConfig.screenHeight! * 0.15,
            child: const Align(
              alignment: Alignment.center,
              child: LottieAnimation(
                source: "assets/lottie/paw.json",
              ),
            ),
          );
        },
      ),
    );
  }
}

class DefaultButtonAction extends StatelessWidget {
  const DefaultButtonAction({
    Key? key,
    required this.title,
    required this.onPressed,
    this.color = Colors.white,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
        fixedSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 80.0)),
        elevation: MaterialStateProperty.all<double>(2),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}

class BottomSheetFilter extends StatelessWidget {
  const BottomSheetFilter({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(70.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3.0,
            spreadRadius: 1,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: child,
      ),
    );
  }
}
