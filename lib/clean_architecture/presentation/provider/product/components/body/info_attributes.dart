import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/components/body/custom_progress_button.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/components/body/info_shipment.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/product_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/dialog_helper.dart';

String cloudFront = Environment.API_DAO;
final DialogHelper _dialogHelper = DialogHelper();

class InfoAttributes extends StatelessWidget {
  const InfoAttributes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productBloc = context.watch<ProductBloc>();
    if (productBloc.isLoadingPage) {
      return const Placeholder();
    } else {
      final product = productBloc.product!;

      if (product.general == "variable_product") {
        return Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                settingModalBottomSheetAttributes(
                  context: context,
                  product: product,
                );
              },
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 15,
                  top: 10,
                  bottom: 0,
                  end: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        product.attributesDescription!,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 15, end: 15),
              child: ValueListenableBuilder(
                valueListenable: productBloc.landingAttributes,
                builder: (context, List<ProductAttribute> value, widget) {
                  return _buildImagesAttributes(
                    attributes: value,
                    context: context,
                    product: product,
                  );
                },
              ),
            ),
            const SizedBox(height: 13),
          ],
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
          child: Row(
            children: <Widget>[
              const Text(
                "Cantidad: ",
              ),
              SizedBox(width: getProportionateScreenWidth(10)),
              SizedBox(
                width: 27,
                child: RawMaterialButton(
                  onPressed: () async {
                    productBloc.onDecrementQuantity();
                  },
                  elevation: 2.0,
                  fillColor: Colors.white,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.remove,
                    size: 15,
                    color: Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: SizedBox(
                  width: 25,
                  child: ValueListenableBuilder(
                    valueListenable: productBloc.quantity,
                    builder: (context, int value, child) {
                      return Text(
                        value.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Colors.blue,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 27,
                child: RawMaterialButton(
                  onPressed: () async {
                    productBloc.onIncrementQuantity();
                  },
                  elevation: 2.0,
                  fillColor: Colors.white,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    color: Colors.black87,
                    size: 15.0,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  _buildImagesAttributes({
    required List<ProductAttribute> attributes,
    required BuildContext context,
    required Product product,
  }) {
    List<Widget> list = [];
    int count = 0;

    for (var element in attributes) {
      if (element.name == "Color") {
        for (var attr in element.terms!) {
          if (count < 4) {
            list.add(
              GestureDetector(
                onTap: () {
                  settingModalBottomSheetAttributes(
                    context: context,
                    product: product,
                  );
                },
                child: SizedBox(
                  width: 77.0,
                  height: 70.0,
                  child: CachedNetworkImage(
                    imageUrl: "$cloudFront/${attr.image?.src}",
                    imageBuilder: (context, imageProvider) => Container(
                      margin: const EdgeInsets.only(right: 7),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: attr.hasBorder!
                            ? Border.all(color: Colors.red, width: 1)
                            : null,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      margin: const EdgeInsets.only(right: 7),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: attr.hasBorder!
                            ? Border.all(color: Colors.red, width: 1)
                            : null,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      margin: const EdgeInsets.only(right: 7),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: attr.hasBorder!
                            ? Border.all(color: Colors.red, width: 2)
                            : null,
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: AssetImage("assets/no-image.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          count++;
        }
      }
    }

    return Row(
      children: <Widget>[
        Row(children: list),
        const SizedBox(width: 5),
        const Text(
          "...",
          style: TextStyle(height: 0, fontSize: 18),
        )
      ],
    );
  }

  Future<void> settingModalBottomSheetAttributes({
    required BuildContext context,
    required Product product,
  }) async {
    return await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      builder: (BuildContext _) {
        return ChangeNotifierProvider<ProductBloc>.value(
          value: Provider.of<ProductBloc>(context, listen: false),
          child: DraggableScrollableSheet(
            initialChildSize: 0.91,
            minChildSize: 0.2,
            maxChildSize: 0.91,
            builder: (__, controller) {
              final productBloc = __.watch<ProductBloc>();

              return SizedBox(
                child: Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.only(top: 70),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            LimitedBox(
                              maxHeight: SizeConfig.screenHeight! * 0.69,
                              child: ValueListenableBuilder(
                                valueListenable: productBloc.modalAttributes,
                                builder: (
                                  context,
                                  List<ProductAttribute> value,
                                  widget,
                                ) {
                                  return _buildAttributesSections(
                                    attributes: value,
                                    product: product,
                                    quantity: productBloc.quantity,
                                    onIncrementQuantity: () {
                                      productBloc.onIncrementQuantity();
                                    },
                                    onDecrementQuantity: () {
                                      productBloc.onDecrementQuantity();
                                    },
                                    onChangeVariation:
                                        (attrKey, attrId, termKey, termId) {
                                      productBloc.onChangeVariation(
                                        attributeKey: attrKey,
                                        attributeId: attrId,
                                        termKey: termKey,
                                        termId: termId,
                                      );
                                    },
                                    onShowDialogShipping: () {
                                      _dialogHelper.showDialogShipping(
                                        context: context,
                                        onSaveShippingAddress:
                                            (_) async {
                                          final mainBloc =
                                              context.read<MainBloc>();
                                          final shippingPrice = await mainBloc
                                              .onSaveShippingAddress(
                                            slug: productBloc.product!.slug!,
                                            quantity:
                                                productBloc.quantity.value,
                                          );

                                          if (shippingPrice is double) {
                                            productBloc.shippingPrice.value =
                                                shippingPrice;

                                            const snackBar = SnackBar(
                                              content: Text(
                                                  'Dirección guardada correctamente'),
                                              backgroundColor:
                                                  kPrimaryBackgroundColor,
                                            );

                                            ScaffoldMessenger.of(_)
                                                .removeCurrentSnackBar();
                                            ScaffoldMessenger.of(_)
                                                .showSnackBar(snackBar);

                                            Navigator.pop(_);
                                          }
                                        },
                                      );
                                    },
                                    context: context,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.0),
                                child: CustomProgressButton(buttonComesFromModal: true),
                              ),

                              /*Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            isLogged(
                                              context: context,
                                              general: product.general,
                                              productId: product.id,
                                              isDialog: true,
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Icon(
                                                MaterialCommunityIcons
                                                    .cart_outline,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "Añadir al carrito",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),*/
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      height: 100.0,
                      width: SizeConfig.screenWidth,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            SizedBox(
                              child: AspectRatio(
                                aspectRatio: 487 / 451,
                                child: ValueListenableBuilder(
                                  valueListenable: productBloc.variation,
                                  builder: (context, Variation value, widget) {
                                    return CachedNetworkImage(
                                      imageUrl:
                                          "$cloudFront/${value.attributes!.first.image!.src!}",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/no-image.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    left: 20,
                                  ),
                                  child: ValueListenableBuilder(
                                      valueListenable: productBloc.salePrice,
                                      builder: (context, value, widget) {
                                        return Text(
                                          "S/ ${parseDouble(value.toString())}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        );
                                      }),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                              child: RawMaterialButton(
                                onPressed: (() {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                }),
                                child: const Icon(
                                  CupertinoIcons.clear,
                                  size: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // _buildShipmentDetails({required BuildContext context}) {
  //   final productBloc = context.read<ProductBloc>();
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Row(
  //         children: <Widget>[
  //           Expanded(
  //             child: Container(
  //               alignment: Alignment.centerLeft,
  //               height: 40,
  //               child: Text(
  //                 "Envio: ${productBloc.shippingPrice == 0 ? "Pago de envío en destino" : productBloc.shippingPrice}",
  //                 style: const TextStyle(fontWeight: FontWeight.w700),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(
  //             child: Icon(
  //               Icons.arrow_forward_ios,
  //               size: 15,
  //               color: Colors.grey,
  //             ),
  //           )
  //         ],
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: const <Widget>[
  //           SizedBox(
  //             width: 16,
  //             child: Icon(
  //               CommunityMaterialIcons.sign_caution,
  //               size: 16,
  //               color: Colors.black,
  //             ),
  //           ),
  //           SizedBox(width: 10),
  //           Text(
  //             "Envio rapido a todo lima metropolitana",
  //             style: TextStyle(
  //               fontWeight: FontWeight.w700,
  //               fontSize: 12,
  //             ),
  //           )
  //         ],
  //       ),
  //       const SizedBox(height: 10),
  //       Row(
  //         children: <Widget>[
  //           const Text("Ubicación: "),
  //           Text(
  //             "ubigeo",
  //             style: const TextStyle(
  //               fontWeight: FontWeight.w700,
  //             ),
  //           ),
  //         ],
  //       )
  //     ],
  //   );
  // }

  lineBreakSliver() {
    return SliverToBoxAdapter(
      child: Container(
        height: 10,
        color: kDividerColor,
      ),
    );
  }

  _buildAttributesSections({
    required BuildContext context,
    required Product product,
    required List<ProductAttribute> attributes,
    required Function(int, String, int, String) onChangeVariation,
    required Function() onDecrementQuantity,
    required Function() onIncrementQuantity,
    required Function() onShowDialogShipping,
    required ValueNotifier quantity,
  }) {
    List<MultiSliver> list = [];

    attributes.forEachIndexed(
      (attributeKey, element) {
        if (element.name == "Color") {
          list.add(
            MultiSliver(
              children: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 30.0,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "${element.name}: ",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          Text(
                            element.checkedName.toString(),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, termKey) {
                        return GestureDetector(
                          onTap: () {
                            onChangeVariation(
                              attributeKey,
                              element.attributeId!,
                              termKey,
                              element.terms![termKey].id!,
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl:
                                "$cloudFront/${element.terms![termKey].image!.src}",
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                border: element.terms![termKey].hasBorder!
                                    ? Border.all(color: Colors.red, width: 1)
                                    : null,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/no-image.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      childCount: element.terms!.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          list.add(
            MultiSliver(
              children: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 30.0,
                      width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "${element.name}: ",
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            "${element.checkedName!.isEmpty ? "Seleccione un item" : element.checkedName}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.6,
                      mainAxisSpacing: 13.0,
                      crossAxisSpacing: 13.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, termKey) {
                        return InkWell(
                          onTap: () {
                            onChangeVariation(
                              attributeKey,
                              element.id!,
                              termKey,
                              element.terms![termKey].id!,
                            );

                            // stateParent(() {});
                            // setState(() {});
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: element.terms![termKey].hasBorder!
                                  ? Border.all(
                                      color: Colors.blueAccent, width: 2)
                                  : null,
                              color: const Color.fromRGBO(247, 247, 247, 1),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Text(
                              element.terms![termKey].label!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: element.terms!.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );

    list.add(
      MultiSliver(
        children: <Widget>[
          SliverPadding(
            padding:
                const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 0),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 70.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Cantidad:",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 27,
                          child: RawMaterialButton(
                            onPressed: () => onDecrementQuantity(),
                            elevation: 2.0,
                            fillColor: Colors.white,
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.remove,
                              size: 20.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 6),
                          child: SizedBox(
                            width: 20,
                            child: ValueListenableBuilder(
                              valueListenable: quantity,
                              builder: (context, value, child) => Text(
                                value.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 27,
                          child: RawMaterialButton(
                            onPressed: () => onIncrementQuantity(),
                            elevation: 2.0,
                            fillColor: Colors.white,
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.add,
                              size: 20.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          lineBreakSliver(),
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            sliver: SliverToBoxAdapter(
              child: InkWell(
                onTap: onShowDialogShipping,
                child: const InfoShipment(),
              ),
            ),
          )
        ],
      ),
    );

    return CustomScrollView(
      slivers: list,
    );
  }

  String parseDouble(String value) {
    final calc = double.parse(value).toStringAsFixed(2);
    return calc.toString();
  }
}
