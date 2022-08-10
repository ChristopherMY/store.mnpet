import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_state_button/progress_button.dart';
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/credentials_auth.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information_local.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/cart_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/local_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/product_repository.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/loadany.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/vimeo_player.dart';

class ProductBloc extends ChangeNotifier {
  final ProductRepositoryInterface productRepositoryInterface;
  final CartRepositoryInterface cartRepositoryInterface;
  final LocalRepositoryInterface localRepositoryInterface;
  final HiveRepositoryInterface hiveRepositoryInterface;

  ProductBloc({
    required this.productRepositoryInterface,
    required this.cartRepositoryInterface,
    required this.localRepositoryInterface,
    required this.hiveRepositoryInterface,
  });

  ValueNotifier<LoadStatus> loadStatus = ValueNotifier(LoadStatus.loading);
  Product? product;

  int initialRange = 1;
  int finalRange = 20;
  int indexPhotoViewer = 0;
  ValueNotifier<int> quantity = ValueNotifier(1);

  ValueNotifier<Variation> variation = ValueNotifier(Variation());
  ValueNotifier<UserInformationLocal> informationLocal =
      ValueNotifier(UserInformationLocal());

  ValueNotifier<List<ProductAttribute>> landingAttributes = ValueNotifier([]);
  ValueNotifier<List<ProductAttribute>> modalAttributes = ValueNotifier([]);

  ValueNotifier<double> shippingPrice = ValueNotifier(0.0);

  ValueNotifier<double> salePrice = ValueNotifier(0.0);
  ValueNotifier<double> regularPrice = ValueNotifier(0.0);

  ValueNotifier<bool> showSwiperPagination = ValueNotifier(false);
  ValueNotifier<ButtonState> stateOnlyCustomIndicatorText =
      ValueNotifier(ButtonState.idle);

  List<Product> productsList = <Product>[];
  List<MainImage> galleryHeaderList = <MainImage>[];

  List<Widget> headerContent = <Widget>[];
  List<Widget> attributesContent = <Widget>[];

  bool isExpanded = false;
  bool isLoadingPage = true;

  //TODO: !important
  bool _disposed = false;
  final SwiperController swiperController = SwiperController();

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  void initProduct({required String slug}) async {
    isLoadingPage = true;
    notifyListeners();

    final response = await productRepositoryInterface.getProductSlug(slug: slug);
    if (response is http.Response) {
      if (response.statusCode == 200) {
        product = productFromMap(response.body);

        if (product!.general != "simple_product") {
          initVariation(product: product!);
          loadVariableComponents(product: product!);
          buildVariationAttributesContent(product: product!);
        } else {
          loadSimpleComponents(product: product!);
        }

        if (product!.galleryVideo!.isEmpty) {
          showSwiperPagination.value = true;
        }

        buildHeaderContent(product: product!);
        isLoadingPage = false;
      } else {
        isLoadingPage = false;
      }
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      isLoadingPage = false;
    }

    notifyListeners();
  }

  void initRelatedProductsPagination({required List<Brand> categories}) async {
    loadStatus.value = LoadStatus.loading;
    notifyListeners();

    final response =
        await productRepositoryInterface.getRelatedProductsPagination(
      categories: categories,
      finalRange: finalRange,
      initialRange: initialRange,
    );

    if (response is http.Response) {
      if (response.statusCode == 200) {
        final products = jsonDecode(response.body) as List;
        if (products.isNotEmpty) {
          productsList.addAll(
            products.map((e) => Product.fromMap(e)).toList().cast(),
          );

          initialRange += 20;
          finalRange += 20;

          loadStatus.value = LoadStatus.normal;
        } else {
          // TODO: Conditional Problem
          loadStatus.value = LoadStatus.completed;
        }
      } else {
        loadStatus.value = LoadStatus.error;
      }
    } else if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      loadStatus.value = LoadStatus.error;
    }

    notifyListeners();
  }

  void initVariation({required Product product}) {
    List<Variation> variations = [...product.variations!];
    int position =
        variations.indexWhere((element) => element.variationDefault == true);

    if (position != -1) {
      variation.value = variations[position];
    } else {
      // TODO: Cuando el producto es variable pero no tiene seleccionado una variacion por defecto.
      variations.first.variationDefault = true;
      variation.value = variations.first;
    }
  }

  void loadVariableComponents({required Product product}) {
    salePrice.value = double.parse(variation.value.price!.sale!);
    regularPrice.value = double.parse(variation.value.price!.regular!);
  }

  void loadSimpleComponents({required Product product}) {
    salePrice.value = double.parse(product.price!.sale!);
    regularPrice.value = double.parse(product.price!.regular!);
  }

  void buildHeaderContent({required Product product}) {
    const cloudFront = Environment.API_DAO;

    if (product.galleryVideo!.isNotEmpty) {
      headerContent.addAll(
        product.galleryVideo!.map(
          (e) => VimeoVideoPlayer(
            url: e.src!,
            defaultImage: e.thumb!,
          ),
        ),
      );

      showSwiperPagination.value = false;
    }

    if (product.galleryHeader!.isNotEmpty) {
      headerContent.addAll(
        product.galleryHeader!.map(
          (image) => Material(
            child: Hero(
              tag: image.id!,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: "$cloudFront/${image.src}",
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      //fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => const SizedBox.shrink(),
                errorWidget: (context, url, error) =>
                    Image.asset("assets/no-image.png"),
              ),
            ),
          ),
        ),
      );
    }

    galleryHeaderList.add(product.mainImage!);
    galleryHeaderList.addAll(product.galleryHeader!);
  }

  void buildVariationAttributesContent({required Product product}) {
    // final imageId = variation!.attributes!
    //     .firstWhere((element) => element.name == "Color")
    //     .image!
    //     .id;

    for (var attr in variation.value.attributes!) {
      final indexOfAttribute = product.modalAttributes!
          .indexWhere((element) => element.attributeId == attr.id);

      if (indexOfAttribute != -1) {
        product.modalAttributes![indexOfAttribute].checkedName = attr.name;
      } else {
        continue;
      }
    }

    for (var coincidence in variation.value.coincidence!) {
      for (var attr in product.attributes!) {
        final indexOfTerm =
            attr.terms!.indexWhere((term) => term.label == coincidence);

        if (indexOfTerm != -1) {
          attr.terms![indexOfTerm].hasBorder = true;
        } else {
          continue;
        }
      }

      for (var attr in product.modalAttributes!) {
        final indexOfTerm =
            attr.terms!.indexWhere((term) => term.label == coincidence);

        if (indexOfTerm != -1) {
          attr.terms![indexOfTerm].hasBorder = true;
        } else {
          continue;
        }
      }
    }

    landingAttributes.value = product.attributes!;
    modalAttributes.value = product.modalAttributes!;
  }

  void onChangeVariation({
    required int attributeKey,
    required String attributeId,
    required int termKey,
    required String termId,
  }) {
    try {
      if (product!.general == "variable_product") {
        final landingList =
            List<ProductAttribute>.from(landingAttributes.value);
        final modalList = List<ProductAttribute>.from(modalAttributes.value);
        var labelColor = "";

        final modal = modalList[attributeKey];
        final landing = landingList[attributeKey];

        modal.checkedName = modal.terms![termKey].label;

        for (var term in modal.terms!) {
          if (term.id == termId) {
            term.hasBorder = true;
            labelColor = term.label!;
          } else {
            term.hasBorder = false;
          }
        }

        for (var term in landing.terms!) {
          if (term.id == termId) {
            term.hasBorder = true;
          } else {
            term.hasBorder = false;
          }
        }

        variation.value = product!.variations!.firstWhere((element) => element
            .coincidence!
            .every((element) => labelColor.contains(element)));

        salePrice.value = double.parse(variation.value.price!.sale!);
        regularPrice.value = double.parse(variation.value.price!.regular!);

        final indexTerm =
            landing.terms!.indexWhere((element) => element.id == termId);

        if (indexTerm > 3) {
          final reserveTerm = landing.terms![indexTerm];
          landing.terms!.removeAt(indexTerm);
          landing.terms!.insert(0, reserveTerm);
        }

        landingAttributes.value = List<ProductAttribute>.from(landingList);
        modalAttributes.value = List<ProductAttribute>.from(modalList);
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void increment() {
    quantity.value++;
  }

  void onIncrementQuantity() async {
    increment();

    final response = await productRepositoryInterface.getShipmentPriceCost(
      slug: product!.slug!,
      districtId: informationLocal.value.districtId!,
      quantity: quantity.value,
    );

    if (response is http.Response) {
      if (response.statusCode == 200) {
        shippingPrice.value = double.parse(response.body.replaceAll('"', ""));
      } else {
        shippingPrice.value = 0.00;
      }
    } else if (response is String) {
      if (kDebugMode) {
        print("Problem on increment quantity of product");
      }

      shippingPrice.value = 0.00;
    }
  }

  void decrement() {
    if (quantity.value > 0) {
      quantity.value--;
    }
  }

  void onDecrementQuantity() async {
    decrement();

    final response = await productRepositoryInterface.getShipmentPriceCost(
      slug: product!.slug!,
      districtId: informationLocal.value.districtId!,
      quantity: quantity.value,
    );

    if (response is http.Response) {
      if (response.statusCode == 200) {
        shippingPrice.value = double.parse(response.body.replaceAll('"', ""));
      } else {
        shippingPrice.value = 0.00;
      }
    } else if (response is String) {
      if (kDebugMode) {
        print("Problem on decrement quantity of product");
      }

      shippingPrice.value = 0.00;
    }
  }

  void refreshUbigeo({required String slug}) async {
    informationLocal.value = UserInformationLocal.fromMap(
        await hiveRepositoryInterface.read(
                containerName: "shipment", key: "residence") ??
            {
              "department": "Lima",
              "province": "Lima",
              "district": "Miraflores",
              "districtId": "61856a14587c82ef50c1b44b",
              "ubigeo": "Lima - Lima - Miraflores",
            });

    productRepositoryInterface
        .getShipmentPriceCost(
      slug: slug,
      districtId: informationLocal.value.districtId!,
      quantity: quantity.value,
    )
        .then(
      (response) {
        if (response is http.Response) {
          if (response.statusCode == 200) {
            shippingPrice.value =
                double.parse(response.body.replaceAll('"', ""));
          } else {
            shippingPrice.value = 0.00;
          }
        } else if (response is String) {
          if (kDebugMode) {
            print("Problem on decrement quantity of product");
          }

          shippingPrice.value = 0.00;
        }
      },
    );
  }

  void notify() {
    notifyListeners();
  }

  void onIndexChanged({
    required int index,
  }) {
    if (product!.galleryVideo!.isNotEmpty) {
      final length = product!.galleryVideo!.length;

      if (index >= length) {
        showSwiperPagination.value = true;
      } else {
        showSwiperPagination.value = false;
      }

      if (index > 0) {
        indexPhotoViewer = index - 1;
      }
    } else {
      showSwiperPagination.value = true;
      indexPhotoViewer = index;
    }
  }

  void onPhotoPageChanged(int index) {
    swiperController.move(index);
    indexPhotoViewer = index;
  }

  Future<dynamic> onAddShoppingCart() async {
    stateOnlyCustomIndicatorText.value = ButtonState.loading;

    final credentials = CredentialsAuth.fromMap(
      await hiveRepositoryInterface.read(
            containerName: "authentication",
            key: "credentials",
          ) ??
          {},
    );

    if (credentials.token.isNotEmpty && credentials.token.isNotEmpty) {
      Map<String, dynamic> buildCart = {
        "product_id": product!.id!,
        "variation_id": variation.value.id,
        "quantity": quantity.value,
        "district_id": informationLocal.value.districtId,
      };

      final response = await cartRepositoryInterface.onSaveShoppingCart(
        cart: buildCart,
        districtId: informationLocal.value.districtId.toString(),
      );

      if (response is http.Response) {
        if (response.statusCode == 200) {
          final responseApi = responseApiFromMap(response.body);
          if (responseApi.status == "success") {
            stateOnlyCustomIndicatorText.value = ButtonState.idle;
            return true;
          }

          stateOnlyCustomIndicatorText.value = ButtonState.idle;
          return false;
        }

        stateOnlyCustomIndicatorText.value = ButtonState.idle;
        return false;
      } else if (response is String) {
        if (kDebugMode) {
          print("Problem on decrement quantity of product");
          print(response);
        }

        stateOnlyCustomIndicatorText.value = ButtonState.idle;
        return false;
      }

      stateOnlyCustomIndicatorText.value = ButtonState.idle;
      return false;
    } else {
      stateOnlyCustomIndicatorText.value = ButtonState.idle;
      return "OutSession";
    }
  }
}
