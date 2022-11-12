import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/cart.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/credentials_auth.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/user_information_local.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/vimeo_video_config.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/cart_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/local_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/product_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/photoview_wrapper.dart';

import '../../../domain/usecase/page.dart';
import '../../widget/vimeo_player.dart';

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

  static int _initialRange = 1;
  static int _finalRange = 20;

  static const _pageSize = 19;

  final PagingController<int, Product> pagingController =
      PagingController(firstPageKey: 0);

  int indexPhotoViewer = 0;
  int indexPhotoViewerDescription = 0;
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

  List<MainImage> galleryHeaderList = <MainImage>[];

  List<Widget> headerContent = <Widget>[];
  List<Widget> attributesContent = <Widget>[];

  bool isExpanded = false;
  bool isLoadingPage = true;

  final SwiperController swiperController = SwiperController();

  Future<void> fetchPagination(int pageKey) async {
    await fetchRelatedProductsPagination(
      categories: product!.categories!,
      pageKey: pageKey,
    );
  }

  void handleInitPagination() {
    pagingController.addPageRequestListener(fetchPagination);
  }

  @override
  void dispose() {
    _initialRange = 1;
    _finalRange = 20;

    pagingController.removePageRequestListener(fetchPagination);
    pagingController.dispose();
    super.dispose();
  }

  Future<void> loadProductDetails({required String slug}) async {
    final response =
        await productRepositoryInterface.getProductSlug(slug: slug);

    if (response is String) {
      if (kDebugMode) {
        print(response);
      }
    }

    if (response is http.Response) {
      if (response.statusCode == 200) {
        product = productFromMap(response.body);

        if (product!.general != "simple_product") {
          handleInitVariation(product: product!);
          handleLoadVariableComponents(product: product!);
          handleBuildVariationAttributesContent(product: product!);
        } else {
          handleLoadSimpleComponents(product: product!);
        }

        handleInitPagination();

        handleBuildHeaderContent(product: product!);
      }
    }
  }

  Future<void> fetchRelatedProductsPagination({
    required List<Brand> categories,
    required int pageKey,
  }) async {
    print("CATEGORIES!!");
    print(categories.first.name);
    print("_finalRange: $_finalRange");
    print("_initialRange: $_initialRange");

    final response =
        await productRepositoryInterface.getRelatedProductsPagination(
      categories: categories,
      finalRange: _finalRange,
      initialRange: _initialRange,
    );

    if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      pagingController.error = response;
    }

    if (response is http.Response) {
      if (response.statusCode == 200) {
        final products = jsonDecode(response.body) as List;
        print("RESPONSE!!!!");
        print(products);

        if (products.isNotEmpty) {
          List<Product> newItems =
              products.map((e) => Product.fromMap(e)).toList().cast();

          _initialRange += 20;
          _finalRange += 20;

          final isLastPage = newItems.length < _pageSize;
          if (isLastPage) {
            pagingController.appendLastPage(newItems);
          } else {
            final nextPageKey = pageKey + newItems.length;
            pagingController.appendPage(newItems, nextPageKey);
          }

          return;
        }

        pagingController.error = "No cargo";
      }
    }
  }

  void handleInitVariation({required Product product}) {
    List<Variation> variations = [...product.variations!];
    int position =
        variations.indexWhere((element) => element.variationDefault == true);

    if (position != -1) {
      /// Here
      variation.value = variations[position];
    } else {
      // TODO: Cuando el producto es variable pero no tiene seleccionado una variacion por defecto.
      variations.first.variationDefault = true;
      variation.value = variations.first;
    }
  }

  void handleLoadVariableComponents({required Product product}) {
    salePrice.value = double.parse(variation.value.price!.sale!);
    regularPrice.value = double.parse(variation.value.price!.regular!);
  }

  void handleLoadSimpleComponents({required Product product}) {
    salePrice.value = double.parse(product.price!.sale!);
    regularPrice.value = double.parse(product.price!.regular!);
  }

  void handleBuildHeaderContent({required Product product}) {
    const cloudFront = Environment.API_DAO;

    if (product.galleryHeader!.isNotEmpty) {
      headerContent.addAll(
        product.galleryHeader!.map(
          (image) => Hero(
            tag: image.id!,
            child: CachedNetworkImage(
              fit: BoxFit.fitHeight,
              imageUrl: "$cloudFront/${image.src}",
              imageBuilder: (context, imageProvider) =>
                  Image(image: imageProvider),
              placeholder: (context, url) => const SizedBox.shrink(),
              errorWidget: (context, url, error) =>
                  Image.asset("assets/no-image.png"),
            ),
          ),
        ),
      );
    }

    galleryHeaderList.add(product.mainImage!);
    galleryHeaderList.addAll(product.galleryHeader!);
  }

  void handleBuildVariationAttributesContent({required Product product}) {
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

    if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      shippingPrice.value = 0.00;
      return;
    }

    if (response is http.Response) {
      if (response.statusCode == 200) {
        shippingPrice.value = double.parse(response.body.replaceAll('"', ""));
        return;
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

    if (response is String) {
      if (kDebugMode) {
        print("Problem on decrement quantity of product");
      }
      shippingPrice.value = 0.00;
      return;
    }

    if (response is http.Response) {
      if (response.statusCode == 200) {
        shippingPrice.value = double.parse(response.body.replaceAll('"', ""));
        return;
      }

      shippingPrice.value = 0.00;
    }
  }

  Future<void> refreshUbigeo({required String slug}) async {
    informationLocal.value = UserInformationLocal.fromMap(
      await hiveRepositoryInterface.read(
              containerName: "shipment", key: "residence") ??
          {
            "department": "Lima",
            "province": "Lima",
            "district": "Miraflores",
            "districtId": "61856a14587c82ef50c1b44b",
            "ubigeo": "Lima - Lima - Miraflores",
          },
    );

    productRepositoryInterface
        .getShipmentPriceCost(
      slug: slug,
      districtId: informationLocal.value.districtId!,
      quantity: quantity.value,
    )
        .then(
      (response) {
        if (response is String) {
          if (kDebugMode) {
            print("Problem on decrement quantity of product");
          }

          shippingPrice.value = 0.00;
          return;
        }

        if (response is http.Response) {
          if (response.statusCode == 200) {
            shippingPrice.value =
                double.parse(response.body.replaceAll('"', ""));
            return;
          }

          shippingPrice.value = 0.00;
        }
      },
    );
  }

  void notify() {
    notifyListeners();
  }

  void onChangedIndexDescription(index) {
    indexPhotoViewerDescription = index;
  }

  void onChangedIndex(index) {
    if (product!.galleryVideo!.isNotEmpty) {
      final length = product!.galleryVideo!.length;

      showSwiperPagination.value = index >= length;

      if (index > 0) {
        indexPhotoViewer = index - 1;
      }

      return;
    }

    showSwiperPagination.value = true;
    indexPhotoViewer = index;
  }

  Future<void> onChangedPhotoPage(int index, bool isAppBar) async {
    print("**************");
    print("indexPhotoViewer: $indexPhotoViewer");
    print("Index: $index");
    print("**************");

    await swiperController.move(index);
    if (isAppBar) {
      indexPhotoViewer = index;
    }

    indexPhotoViewerDescription = index;
    // notifyListeners();
  }

  Future<dynamic> onSaveShoppingCart() async {
    stateOnlyCustomIndicatorText.value = ButtonState.loading;

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Custom-Origin": "app",
    };

    final credentials = CredentialsAuth.fromMap(
      await hiveRepositoryInterface.read(
            containerName: "authentication",
            key: "credentials",
          ) ??
          {"email_confirmed": false},
    );

    /// Si no hay token consedera la accion de trabajar con carrito de compras temporal
    if (credentials.token.isNotEmpty && credentials.token.isNotEmpty) {
      headers[HttpHeaders.authorizationHeader] = "Bearer ${credentials.token}";

      Map<String, dynamic> bindingCart = {
        "product_id": product!.id!,
        "variation_id": variation.value.id,
        "quantity": quantity.value,
      };

      // final response =
      await cartRepositoryInterface.saveShoppingCart(
        cart: bindingCart,
        headers: headers,
      );

      // if (response is String) {
      //   if (kDebugMode) {
      //     print(response);
      //   }
      //
      //   stateOnlyCustomIndicatorText.value = ButtonState.idle;
      //   return false;
      // }
      //
      // if (response is! http.Response) {
      //   stateOnlyCustomIndicatorText.value = ButtonState.idle;
      //   return false;
      // }
      //
      // if (response.statusCode == 200) {
      //   stateOnlyCustomIndicatorText.value = ButtonState.idle;
      //   return false;
      // }

      stateOnlyCustomIndicatorText.value = ButtonState.idle;
      return true;
    }

    String shoppingCartId = await hiveRepositoryInterface.read(
          containerName: "shopping_temporal",
          key: "cartId",
        ) ??
        "";

    Map<String, dynamic> buildCart = {
      "product_id": product!.id!,
      "variation_id": variation.value.id,
      "quantity": quantity.value,
      "cart_id": shoppingCartId,
    };

    final response =
        await cartRepositoryInterface.onSaveShoppingCartTemp(cart: buildCart);

    if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      stateOnlyCustomIndicatorText.value = ButtonState.idle;
      return false;
    }

    if (response is! http.Response) {
      stateOnlyCustomIndicatorText.value = ButtonState.idle;
      return false;
    }

    if (response.statusCode != 200) {
      stateOnlyCustomIndicatorText.value = ButtonState.idle;
      return false;
    }

    final responseApi = cartFromMap(response.body);

    if (responseApi.id!.isNotEmpty) {
      if (shoppingCartId.isEmpty) {
        await hiveRepositoryInterface.save(
          containerName: "shopping_temporal",
          key: "cartId",
          value: responseApi.id,
        );
      }
    }

    stateOnlyCustomIndicatorText.value = ButtonState.idle;
    return true;
  }

  void initProductState({
    required Product product,
  }) async {
    await Future.wait(
      [
        loadVimeoVideoConfig(galleryVideo: product.galleryVideo!),
        loadProductDetails(slug: product.slug!),
        refreshUbigeo(slug: product.slug!),
      ],
    );

    isLoadingPage = false;
    notifyListeners();
  }

  Future<void> loadVimeoVideoConfig({
    required List<GalleryVideo> galleryVideo,
  }) async {
    List<Widget> copyGalleryVideo = List.from(headerContent);

    showSwiperPagination.value = !galleryVideo.isNotEmpty;

    if (galleryVideo.isNotEmpty) {
      await Future.forEach(
        galleryVideo,
        (GalleryVideo videoInformation) async {
          if (videoInformation.src is String &&
              videoInformation.src!.isNotEmpty) {
            var regExp = RegExp(
              r"^((https?):\/\/)?(www.)?vimeo\.com\/([0-9]+).*$",
              caseSensitive: false,
              multiLine: false,
            );

            final match = regExp.firstMatch(videoInformation.src!);
            if (match != null && match.groupCount >= 1) {
              final url = videoInformation.src!.trim();
              var vimeoVideoId = '';
              var videoIdGroup = 4;
              var vimeoMp4Video = '';

              for (var exp in [
                RegExp(r"^((https?):\/\/)?(www.)?vimeo\.com\/([0-9]+).*$"),
              ]) {
                RegExpMatch? match = exp.firstMatch(url);
                if (match != null && match.groupCount >= 1) {
                  vimeoVideoId = match.group(videoIdGroup) ?? '';
                }
              }

              final response = await productRepositoryInterface
                  .vimeoVideoConfigFromUrl(vimeoVideoId: vimeoVideoId);

              if (response is String) {
                if (kDebugMode) {
                  print(response);
                }
              }

              if (response is http.Response) {
                if (response.statusCode == 200) {
                  final decodeResponse = jsonDecode(response.body);
                  final vimeoVideo = VimeoVideoConfig.fromMap(decodeResponse);
                  vimeoMp4Video =
                      vimeoVideo.request?.files?.progressive![0].url ?? '';

                  copyGalleryVideo.add(
                    VimeoVideoPlayer(
                      url: vimeoMp4Video,
                      defaultImage: videoInformation.thumb!,
                    ),
                  );
                }
              }
            }
          }
        },
      );

      if (headerContent.isNotEmpty && copyGalleryVideo.isNotEmpty) {
        headerContent = [...copyGalleryVideo, ...headerContent];
      } else {
        headerContent.addAll(copyGalleryVideo);
      }
    }
  }

  void onOpenGallery({
    required BuildContext context,
    required bool isAppBar,
    required ManagerTypePhotoViewer managerTypePhotoViewer,
  }) {
    if (product!.galleryVideo!.isNotEmpty) {
      final variavle = product!.galleryVideo!.length - 1;

      print(variavle);
      print(indexPhotoViewer);

      if (variavle <= indexPhotoViewer) {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            reverseTransitionDuration: const Duration(milliseconds: 600),
            barrierDismissible: false,
            opaque: true,
            //barrierColor: Colors.white,
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
            pageBuilder: (_, __, ___) {
              return ChangeNotifierProvider<ProductBloc>.value(
                value: Provider.of<ProductBloc>(context),
                child: GalleryPhotoViewWrapper(
                  managerTypePhotoViewer: managerTypePhotoViewer,
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  isAppBar: isAppBar,
                  scrollDirection: Axis.horizontal,
                ),
              );
            },
          ),
        );
      }

      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 600),
        barrierDismissible: false,
        opaque: true,
        //barrierColor: Colors.white,
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return FadeTransition(opacity: animation, child: child);
        },
        pageBuilder: (_, __, ___) {
          return ChangeNotifierProvider<ProductBloc>.value(
            value: Provider.of<ProductBloc>(context),
            child: GalleryPhotoViewWrapper(
              managerTypePhotoViewer: managerTypePhotoViewer,
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              isAppBar: isAppBar,
              scrollDirection: Axis.horizontal,
            ),
          );
        },
      ),
    );
  }
}
