import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/credentials_auth.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/user_information_local.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/vimeo_video_config.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/cart_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/local_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/product_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';
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

  final ValueNotifier<bool> notifierNavigationBottomBarVisible =
      ValueNotifier(false);
  ValueNotifier<bool> showSwiperPagination = ValueNotifier(false);
  ValueNotifier<ButtonState> stateOnlyCustomIndicatorText =
      ValueNotifier(ButtonState.idle);

  List<MainImage> galleryHeaderList = <MainImage>[];

  List<Widget> headerContent = <Widget>[];
  List<Widget> attributesContent = <Widget>[];
  ValueNotifier<bool> isExpanded = ValueNotifier(false);
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
    swiperController.dispose();
    super.dispose();
  }

  Future<Product> handleLoadProductDetails(
    BuildContext context, {
    required String slug,
  }) async {
    final responseApi =
        await productRepositoryInterface.getProductSlug(slug: slug);

    if (responseApi.data == null) {
      final statusCode = responseApi.error!.statusCode;

      if (statusCode == -1) {
        GlobalSnackBar.showWarningSnackBar(context, kNoInternet);
        Navigator.of(context).pop();
        throw Exception(kNoInternet);
      }

      if (statusCode == 400) {
        final response = ResponseApi.fromMap(responseApi.error!.data);
        GlobalSnackBar.showWarningSnackBar(context, response.message);
        Navigator.of(context).pop();
        throw Exception(response.message);
      }



      GlobalSnackBar.showWarningSnackBar(context, kOtherProblem);
      Navigator.of(context).pop();
      throw Exception(kOtherProblem);
    }

    return Product.fromMap(responseApi.data);
  }

  Future<void> fetchRelatedProductsPagination({
    required List<Brand> categories,
    required int pageKey,
  }) async {
    final responseApi =
        await productRepositoryInterface.getRelatedProductsPagination(
      categories: categories,
      finalRange: _finalRange,
      initialRange: _initialRange,
    );

    if (responseApi.data == null) {
      pagingController.error = kNoLoadMoreItems;
      return;
    }

    final products = (responseApi.data as List);

    if (products.isNotEmpty) {
      List<Product> newItems =
          products.map((e) => Product.fromMap(e)).toList().cast();

      _initialRange += 20;
      _finalRange += 20;

      newItems.removeWhere((element) => element.id! == product!.id!);
      //newItems.removeWhere((element) => element.mainImage!.id! == product!.mainImage!.id);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }

      return;
    }

    pagingController.error = kNoLoadMoreItems;
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
    const String cloudFront = Environment.API_DAO;

    if (product.galleryHeader!.isNotEmpty) {
      headerContent.addAll(
        product.galleryHeader!.map(
          (image) => Hero(
            tag: "image-${image.id!}",
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider("$cloudFront/${image.src}"),
                ),
              ),
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

  void onIncrementQuantity(BuildContext context) async {
    increment();

    final responseApi = await productRepositoryInterface.getShipmentPriceCost(
      slug: product!.slug!,
      districtId: informationLocal.value.districtId!,
      quantity: quantity.value,
    );

    if (responseApi.data == null) {
      shippingPrice.value = 0.00;

      GlobalSnackBar.showWarningSnackBar(context, kOtherProblem);
    }

    final price = responseApi.data;
    shippingPrice.value = double.parse(price.replaceAll('"', ""));
  }

  void decrement() {
    if (quantity.value > 0) {
      quantity.value--;
    }
  }

  void onDecrementQuantity(BuildContext context) async {
    decrement();

    final responseApi = await productRepositoryInterface.getShipmentPriceCost(
      slug: product!.slug!,
      districtId: informationLocal.value.districtId!,
      quantity: quantity.value,
    );

    if (responseApi.data == null) {
      shippingPrice.value = 0.00;

      GlobalSnackBar.showWarningSnackBar(context, kOtherProblem);
    }

    final price = responseApi.data;

    shippingPrice.value = double.parse(price.replaceAll('"', ""));
  }

  Future<String> refreshUbigeo(
    BuildContext context, {
    required String slug,
    required int quantity,
  }) async {
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

    final responseApi = await productRepositoryInterface.getShipmentPriceCost(
      slug: slug,
      districtId: informationLocal.value.districtId!,
      quantity: quantity,
    );

    if (responseApi.data == null) {
      GlobalSnackBar.showWarningSnackBar(context, kOtherProblem);
      return "0.0";
    }

    return responseApi.data;
  }

  void notify() {
    notifyListeners();
  }

  void onChangedIndexDescription(index) {
    indexPhotoViewerDescription = index;
  }

  void onChangedIndex(index) {
    indexPhotoViewer = index;
  }

  Future<void> onChangedPhotoPage(int index, bool isAppBar) async {
    await swiperController.move(index);
    if (isAppBar) {
      indexPhotoViewer = index;
    }

    indexPhotoViewerDescription = index;
  }

  void onSaveShoppingCart(BuildContext context) async {
    final mainBloc = context.read<MainBloc>();

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

      final responseApi = await cartRepositoryInterface.saveShoppingCart(
        cart: bindingCart,
        headers: headers,
      );

      if (responseApi.data == null) {
        stateOnlyCustomIndicatorText.value = ButtonState.idle;

        final statusCode = responseApi.error!.statusCode;
        if (statusCode >= 400) {
          if (statusCode == 400) {
            final response = ResponseApi.fromMap(responseApi.data);

            GlobalSnackBar.showErrorSnackBarIcon(
              context,
              response.message,
            );
            return;
          }
        }

        GlobalSnackBar.showErrorSnackBarIcon(
          context,
          'Ups tuvimos un problema. Vuelva a intentarlo más tarde',
        );

        return;
      }

      mainBloc.handleShoppingCart(context);
      stateOnlyCustomIndicatorText.value = ButtonState.idle;
      return;
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

    final responseApi =
        await cartRepositoryInterface.onSaveShoppingCartTemp(cart: buildCart);

    stateOnlyCustomIndicatorText.value = ButtonState.idle;

    if (responseApi.data == null) {
      final statusCode = responseApi.error!.statusCode;
      if (statusCode >= 400) {
        if (statusCode == 400) {
          final response = ResponseApi.fromMap(responseApi.data);
          GlobalSnackBar.showErrorSnackBarIcon(
            context,
            response.message,
          );

          return;
        }
      }

      GlobalSnackBar.showErrorSnackBarIcon(
        context,
        'Ups tuvimos un problema. Vuelva a intentarlo más tarde',
      );

      return;
    }

    mainBloc.handleShoppingCart(context);
    return;
  }

  void initProductState(
    BuildContext context, {
    required String slug,
    required bool showProduct,
  }) async {
    if (!showProduct) {
      handleInitPagination();
    }

    final waits = await Future.wait(
      [
        handleLoadProductDetails(context, slug: slug),
        refreshUbigeo(
          context,
          slug: slug,
          quantity: quantity.value,
        ),
      ],
    );

    waits.forEachIndexed(
      (index, element) {
        switch (index) {
          case 0:
            {
              final productJson = (element as Product);
              product = productJson;
              if (element.general != "simple_product") {
                handleInitVariation(product: productJson);
                handleLoadVariableComponents(product: productJson);
                handleBuildVariationAttributesContent(product: productJson);
              } else {
                handleLoadSimpleComponents(product: productJson);
              }

              ///*********************
              /// Considera el inicio de la app, si solicita mostrar un producto iniciara el trabajo en orden de peticiones
              ///*********************

              if (showProduct) {
                print("fullsouce producto bloc");
                handleBuildHeaderContent(product: product!);
                loadVimeoVideoConfig(
                  context,
                  product: product!,
                );
                handleInitPagination();
              }
            }
            break;
          case 1:
            {
              final price = (element as String);
              shippingPrice.value = double.parse(price.replaceAll('"', ""));
            }
        }
      },
    );

    isLoadingPage = false;
    notifierNavigationBottomBarVisible.value = true;

    notifyListeners();
  }

  Future<void> loadVimeoVideoConfig(
    BuildContext context, {
    required Product product,
  }) async {
    List<Widget> copyGalleryVideo = List.from([]);
    List<Widget> copyGalleryHeader = List.from(headerContent);

    showSwiperPagination.value = !product.galleryVideo!.isNotEmpty;

    if (product.galleryVideo!.isNotEmpty) {
      await Future.forEach(
        product.galleryVideo!,
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

              final responseApi = await productRepositoryInterface
                  .vimeoVideoConfigFromUrl(vimeoVideoId: vimeoVideoId);

              if (responseApi.data == null) {
                GlobalSnackBar.showWarningSnackBar(context, kOtherProblem);
                return;
              }

              final vimeoVideo = VimeoVideoConfig.fromMap(responseApi.data);
              vimeoMp4Video =
                  vimeoVideo.request?.files?.progressive![0].url ?? '';

              copyGalleryVideo.add(
                VimeoVideoPlayer(
                  url: vimeoMp4Video,
                  //  defaultImage: videoInformation.thumb!,
                  defaultImage: product.mainImage!.src!,
                ),
              );
            }
          }
        },
      );

      // if (headerContent.isNotEmpty && copyGalleryVideo.isNotEmpty) {
      //   headerContent = [...copyGalleryVideo, ...headerContent];
      // } else {
      //   headerContent.clear();
      //   headerContent.addAll(copyGalleryVideo);
      // }
      // headerContent.clear();
      print("copyGalleryHeader: ${copyGalleryHeader.length}");
      print("headerContent: ${headerContent.length}");
      print("copyGalleryVideo: ${copyGalleryVideo.length}");

      headerContent = [...copyGalleryVideo, ...copyGalleryHeader];
      notifyListeners();
      // swiperController.next(animation: true);
    }
  }

  void onOpenGallery({
    required BuildContext context,
    required bool isAppBar,
    required ManagerTypePhotoViewer managerTypePhotoViewer,
    required String code,
  }) async {
    await Navigator.of(context).push(
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
              code: code,
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
