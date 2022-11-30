import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/product/components/body/info_shipment.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/product/product_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/dialog_helper.dart';

String cloudFront = Environment.API_DAO;

class InfoAttributes extends StatelessWidget {
  const InfoAttributes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productBloc = context.watch<ProductBloc>();
    if (productBloc.isLoadingPage.value) {
      return const Placeholder();
    } else {
      final product = productBloc.product!;

      if (product.general == "variable_product") {
        return Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                DialogHelper.settingModalBottomSheetAttributes(
                  context: context,
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
                    productBloc.onDecrementQuantity(context);
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
                    productBloc.onIncrementQuantity(context);
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
                  DialogHelper.settingModalBottomSheetAttributes(
                      context: context);
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
}

class BuildAttributesSections extends StatelessWidget {
  const BuildAttributesSections({
    Key? key,
    required this.onChangeVariation,
    required this.onDecrementQuantity,
    required this.onIncrementQuantity,
    required this.onShowDialogShipping,
  }) : super(key: key);

  final Function(int, String, int, String) onChangeVariation;
  final Function() onDecrementQuantity;
  final Function() onIncrementQuantity;
  final Function() onShowDialogShipping;

  @override
  Widget build(BuildContext context) {
    final productBloc = context.read<ProductBloc>();

    List<MultiSliver> list = [];

    list.addAll(
      productBloc.product!.modalAttributes!
          .mapIndexed(
            (attributeKey, element) {
              if (element.name == "Color") {
                return MultiSliver(
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
                                element.checkedName!,
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
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                    border: element.terms![termKey].hasBorder!
                                        ? Border.all(
                                            color: Colors.red, width: 1)
                                        : null,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
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
                );
              } else {
                return MultiSliver(
                  children: <Widget>[
                    SliverPadding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 15, right: 15),
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
                );
              }
            },
          )
          .toList()
          .cast(),
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
                            onPressed: onDecrementQuantity,
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
                            width: 20.0,
                            child: ValueListenableBuilder(
                              valueListenable: productBloc.quantity,
                              builder: (context, int value, child) => Text(
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
                            onPressed: onIncrementQuantity,
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
          const SliverToBoxAdapter(
            child: Divider(
              thickness: 10,
              height: 10,
              color: kBackGroundColor,
            ),
          ),
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
}
