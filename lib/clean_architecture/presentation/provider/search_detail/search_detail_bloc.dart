import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/binding_search.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/filter_product_detail.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/search_product_details.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/sort_option.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/product_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';

class SearchDetailBloc extends ChangeNotifier {
  ProductRepositoryInterface productRepositoryInterface;

  SearchDetailBloc({required this.productRepositoryInterface});

  static const _pageSize = 16;

  final PagingController<int, Product> pagingController =
  PagingController(firstPageKey: 0);
  ValueNotifier<LoadStatus> loadStatus = ValueNotifier(LoadStatus.loading);

  static const _limit = 16;

  ValueNotifier<List<Brand>> category = ValueNotifier(<Brand>[]);
  ValueNotifier<List<Brand>> productTypes = ValueNotifier(<Brand>[]);
  ValueNotifier<List<Brand>> brands = ValueNotifier(<Brand>[]);
  ValueNotifier<List<ProductAttribute>> attributes = ValueNotifier(<ProductAttribute>[]);

  late ProductAttribute attributeSelected;
  int indexProductAttribute = 0;

  ValueNotifier<List<Term>> searchResults = ValueNotifier(<Term>[]);

  TextEditingController searchEditingController = TextEditingController();
  late final BuildContext context;

  bool reloadLoadFilters = true;
  bool isGridList = true;

  BindingSearch bindingSearch = BindingSearch(
    order: "asc",
    brands: <String>[],
    categories: <String>[],
    productTypes: <String>[],
    attributes: <String>[],
    attributesTerm: <String>[],
    min: 0.0,
    max: 500.0,
    firstSearch: false,
    limit: _limit,
    page: 0,
  );

  late BindingSearch bindingSearchFilter;

  late double rangeMin = 0.0;
  late double rangeMax = 500.0;

  ValueNotifier<RangeValues> currentRangeValues =
  ValueNotifier(const RangeValues(0, 100));

  ValueNotifier<List<SortOption>> sort = ValueNotifier(
    <SortOption>[
      SortOption(
        title: "Lo más popular",
        code: "popular",
        isChecked: false,
      ),
      SortOption(
        title: "Lo más nuevo",
        code: "newest",
        isChecked: false,
      ),
      // SortOption(
      //   title: "Lo más buscado",
      //   isChecked: false,
      // ),
      SortOption(
        title: "Precio: menor a mayor",
        code: "asc",
        isChecked: false,
      ),
      SortOption(
        title: "Precio: mayor a menor",
        code: "dsc",
        isChecked: false,
      ),
    ],
  );

  @override
  void dispose() {
    pagingController.dispose();
    searchEditingController.dispose();
    super.dispose();
  }

  void handleChangeOptionSort(int index) {
    List<SortOption> sortList = List.from(sort.value);
    final selected = sortList[index];

    for (int i = 0; i < sortList.length; i++) {
      sortList[i] = sortList[i].copyWith(isChecked: (selected == sortList[i]));
    }

    sort.value = sortList;

    bindingSearchFilter.order = selected.code;
    pagingController.refresh();
  }

  Future<void> searchProductDetails(int page) async {
    bindingSearch.page = page;

    final responseApi =
    await productRepositoryInterface.getSearchProductDetails(
      bindings: bindingSearch.toMap(),
    );

    if (responseApi.data == null) {
      pagingController.error = kNoLoadMoreItems;
    }

    SearchProductDetails details =
    SearchProductDetails.fromMap(responseApi.data);
    final isLastPage = details.docs!.length < _pageSize;

    if (isLastPage) {
      pagingController.appendLastPage(details.docs!);
    } else {
      final nextPageKey = page + 1;
      pagingController.appendPage(details.docs!, nextPageKey);
    }
  }

  Future<void> filterProductDetails() async {
    if (!reloadLoadFilters) {
      return;
    }

    loadStatus.value = LoadStatus.loading;

    final responseApi =
    await productRepositoryInterface.getFiltersProductDetails(
      bindings: bindingSearchFilter.toMap(),
    );

    if (responseApi.data == null) {
      loadStatus.value = LoadStatus.error;
      pagingController.error = kNoLoadMoreItems;
      return;
    }

    final filterResponse = FilterProductDetail.fromMap(responseApi.data);

    rangeMin = filterResponse.priceRange!.priceRangeDefault!.min!;
    rangeMax = filterResponse.priceRange!.priceRangeDefault!.max!;

    category.value = List.from(filterResponse.categories!);
    productTypes.value = List.from(filterResponse.productTypes!);
    brands.value = List.from(filterResponse.brands!);
    attributes.value = List.from(filterResponse.attributes!);

    currentRangeValues.value = RangeValues(rangeMin, rangeMax);

    reloadLoadFilters = false;
    loadStatus.value = LoadStatus.normal;
  }

  void handleChangeCategories(int index) {
    List<Brand> categoryList = List.from(category.value);
    final selected = categoryList[index];
    for (int i = 0; i < categoryList.length; i++) {
      categoryList[i] =
          categoryList[i].copyWith(checked: (selected == categoryList[i]));
    }

    category.value = categoryList;
  }

  void handleChangeProductTypes(int index) {
    List<Brand> productTypesList = List.from(productTypes.value);
    final selected = productTypesList[index];
    productTypesList[index] =
        selected.copyWith(checked: selected.checked == false);

    productTypes.value = productTypesList;
  }

  void onChangeSearchAttr(String? text) {
    final lowerText = text!.toLowerCase();
    List<Term> values = List.from(searchResults.value);
    values.clear();

    if (text.isEmpty || text == "") {
      searchResults.value = attributeSelected.terms!;
      return;
    }

    for (Term term in attributeSelected.terms!) {
      if (term.label!.toLowerCase().contains(lowerText)) {
        values.add(term);
      } else {
        continue;
      }
    }

    searchResults.value = values;
  }

  void onSubmittedSearchAttr(String? value) {}

  void onApplyFilters() async {
    final existsAttributes = attributes.value.isNotEmpty;
    if (existsAttributes) {
      bindingSearch.attributesTerm = attributes.value
          .map(
            (e) => e.termsSelected!.map((e) => e.slug!).toList(),
      )
          .toList()
          .cast()
          .first;
    }

    bindingSearch.categories = category.value
        .where((element) => element.checked == true)
        .map((e) => e.slug!)
        .toList();

    bindingSearch.productTypes = productTypes.value
        .where((element) => element.checked == true)
        .map((e) => e.slug!)
        .toList();

    bindingSearch.min = currentRangeValues.value.start;
    bindingSearch.max = currentRangeValues.value.end;

    pagingController.refresh();
    Navigator.of(context).pop();
  }

  void onClearSearchAttr() {
    searchEditingController.clear();

    searchResults.value = attributeSelected.terms!;
  }

  void onChangeCheckBoxTerm(int index, bool? isChecked) {
    List<Term> terms = List.from(searchResults.value);

    List<Term> termsSelectedList = List.from(attributeSelected.termsSelected!);
    final indexTermSelected = termsSelectedList.indexOf(terms[index]);

    if (indexTermSelected != -1) {
      termsSelectedList.removeAt(indexTermSelected);
    } else {
      termsSelectedList.add(terms[index]);
    }

    List<ProductAttribute> attributesList = List.from(attributes.value);
    attributesList[indexProductAttribute].termsSelected = termsSelectedList;
    attributes.value = attributesList;

    terms[index].checked = isChecked ?? false;
    searchResults.value = terms;
  }

  void handleResetFilter() async {
    reloadLoadFilters = true;
    await filterProductDetails();
  }

  void handleChangeGrid() async {
    isGridList = !isGridList;
    notifyListeners();
  }
}
