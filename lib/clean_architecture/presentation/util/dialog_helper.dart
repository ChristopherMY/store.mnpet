import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/district.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/province.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/region.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/shipment/shipment_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/default_button.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/form_error.dart';

import '../../domain/model/user_information.dart';

class DialogHelper {
  Future<void> showDialogShipping({
    required BuildContext context,
    required Function(BuildContext) onSaveShippingAddress,
  }) {
    return showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext _) {
        // Mongo Payground

        return ChangeNotifierProvider<MainBloc>.value(
          value: Provider.of<MainBloc>(context, listen: false),
          builder: (context, child) {
            final mainBloc = Provider.of<MainBloc>(context, listen: true);
            return AlertDialog(
              title: const Text(
                'Calcular envío en otra dirección',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
              ),
              content: SingleChildScrollView(
                padding: const EdgeInsets.all(0.0),
                child: ListBody(
                  children: <Widget>[
                    Text(
                      'Departamento',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.black12.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    InkWell(
                      onTap: () {
                        showDropdownRegions(
                          context: context,
                          onChangeRegion: (index, stateAlertRegion, context) {
                            mainBloc.onChangeRegion(
                              index: index,
                              stateAlertRegion: stateAlertRegion,
                            );

                            Navigator.of(context).pop();
                          },
                          regions: mainBloc.regions,
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ValueListenableBuilder(
                              valueListenable: mainBloc.departmentName,
                              builder: (context, String value, child) {
                                return Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                              },
                            ),
                          ),
                          const Icon(
                            //Ionicons.ios_arrow_dropdown,
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const Divider(color: Colors.black),
                    Text(
                      'Provincia',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.black12.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        showDropdownProvinces(
                          context: context,
                          provinces: mainBloc.provinces,
                          onChangeProvince: (
                            index,
                            stateAlertProvince,
                            context,
                          ) {
                            mainBloc.onChangeProvince(
                              index: index,
                              stateAlertProvince: stateAlertProvince,
                            );
                            Navigator.of(context).pop();
                          },
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ValueListenableBuilder(
                              valueListenable: mainBloc.provinceName,
                              builder: (context, String value, child) {
                                return Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                              },
                            ),
                          ),
                          const Icon(
                            //Ionicons.ios_arrow_dropdown,
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const Divider(color: Colors.black),
                    Text(
                      'Distrito',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.black12.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        showDropdownDistricts(
                          context: context,
                          districts: mainBloc.districts,
                          onChangeDistrict:
                              (index, stateAlertDistrict, context) {
                            mainBloc.onChangeDistrict(
                              index: index,
                              stateAlertDistrict: stateAlertDistrict,
                            );
                            Navigator.of(context).pop();
                          },
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: ValueListenableBuilder(
                            valueListenable: mainBloc.districtName,
                            builder: (context, String value, child) {
                              return Text(
                                value,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              );
                            },
                          )),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const Divider(color: Colors.black),
                    const SizedBox(height: 10),
                    DefaultTextStyle(
                      style: const TextStyle(color: Colors.red, fontSize: 15),
                      child: FormError(errors: mainBloc.errors),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 0),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 100,
                          height: 35,
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            border:
                                Border.all(width: 1.0, color: Colors.black26),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Cancelar",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => onSaveShippingAddress(context),
                          child: Container(
                            height: 35.0,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: <Color>[
                                  kPrimaryColor,
                                  kPrimaryColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 3.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(0.0, 0.0),
                                )
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "Guardar",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        );
      },
      animationType: DialogTransitionType.slideFromBottom,
      curve: Curves.easeOutCubic,
      /*duration: Duration(seconds: 1),*/
    );
  }

  Future<void> showDropdownRegions({
    required BuildContext context,
    required List<Region> regions,
    required Function(int, StateSetter, BuildContext) onChangeRegion,
  }) async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext _) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter state) {
            return Container(
              height: 270.0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              CupertinoIcons.clear,
                              color: Colors.black45,
                              size: 16.0,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          const Expanded(
                            child: Text(
                              "Departamento",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      height: 2.0,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: regions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              onChangeRegion(index, state, _);
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text('${regions[index].name}'),
                                      ),
                                      regions[index].checked == true
                                          ? const SizedBox(
                                              height: 15,
                                              child: Icon(
                                                CupertinoIcons.checkmark_alt,
                                                color: Colors.blueAccent,
                                                size: 20,
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 2,
                                  color: Colors.black,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> showDropdownProvinces({
    required BuildContext context,
    required List<Province> provinces,
    required Function(int, StateSetter, BuildContext) onChangeProvince,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter stateAlertProvince) {
            return Container(
              height: 270,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              CupertinoIcons.clear,
                              color: Colors.black45,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "Provincia",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      height: 2,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: provinces.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              onChangeProvince(
                                  index, stateAlertProvince, context);
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text('${provinces[index].name}'),
                                      ),
                                      provinces[index].checked == true
                                          ? const SizedBox(
                                              height: 15,
                                              child: Icon(
                                                CupertinoIcons.checkmark_alt,
                                                color: Colors.blueAccent,
                                                size: 20,
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 2,
                                  color: Colors.black,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> showDropdownDistricts({
    required BuildContext context,
    required List<District> districts,
    required Function(int, StateSetter, BuildContext) onChangeDistrict,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter stateAlertDistrict) {
            return Container(
              height: 270,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              CupertinoIcons.clear,
                              color: Colors.black45,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "Distritos",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      height: 2,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: districts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              onChangeDistrict(
                                  index, stateAlertDistrict, context);
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text('${districts[index].name}'),
                                      ),
                                      districts[index].checked == true
                                          ? const SizedBox(
                                              height: 15,
                                              child: Icon(
                                                CupertinoIcons.checkmark_alt,
                                                color: Colors.blueAccent,
                                                size: 20,
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 2,
                                  color: Colors.black,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> showAddressDialog({
    required BuildContext context,
    required Address address,
    required bool isAdd,
  }) {
    return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext _) {
        return ChangeNotifierProvider<ShipmentBloc>.value(
          value: Provider.of<ShipmentBloc>(context, listen: false),
          child: DraggableScrollableSheet(
            initialChildSize: 0.91,
            minChildSize: 0.20,
            maxChildSize: 0.91,
            builder: (__, controller) {
              final shipmentBloc = __.watch<ShipmentBloc>();
              final mainBloc = __.watch<MainBloc>();
              return Container(
                height: SizeConfig.screenHeight,
                margin: const EdgeInsets.only(top: 50.0),
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(18.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: shipmentBloc.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  "Nueva Direccion",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: 33.0,
                                height: 33.0,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(CupertinoIcons.clear),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(15.0),
                          ),
                          TextFormField(
                            controller: shipmentBloc.addressNameController,
                            initialValue: address.addressName,
                            onChanged: shipmentBloc.onChangeAddressName,
                            validator: shipmentBloc.onValidationAddressName,
                            style: Theme.of(context).textTheme.bodyText2,
                            decoration: InputDecoration(
                              labelText: "Nombre de dirección",
                              hintText: "Ej. Mi Casa, trabajo etc",
                              labelStyle: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                              hintStyle: Theme.of(context).textTheme.bodyText2,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              errorStyle: const TextStyle(height: 0),
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(30.0),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tipo de dirección',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              const SizedBox(height: 5),
                              InkWell(
                                onTap: () => showDropdownAddressType(
                                  addressTypes: shipmentBloc.addressTypes,
                                  context: context,
                                  changeAddressType: (index) {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "address.addressType!",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      CommunityMaterialIcons
                                          .arrow_down_drop_circle,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.black),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          TextFormField(
                            initialValue: address.direction,
                            onChanged: shipmentBloc.onChangeDirection,
                            validator: shipmentBloc.onValidationDirection,
                            style: Theme.of(context).textTheme.bodyText2,
                            decoration: InputDecoration(
                              labelText: "Dirección",
                              hintText: "Ingresa tu dirección",
                              labelStyle: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                              hintStyle: Theme.of(context).textTheme.bodyText2,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              errorStyle: const TextStyle(height: 0),
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),
                          TextFormField(
                            initialValue: address.lotNumber.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  numberValidatorReg),
                            ],
                            onChanged: shipmentBloc.onChangeLotNumber,
                            validator: shipmentBloc.onValidationLotNumber,
                            style: Theme.of(context).textTheme.bodyText2,
                            decoration: InputDecoration(
                              labelText: "Nro/Lote",
                              hintText: "Ingresa tu numero de lote",
                              labelStyle: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                              hintStyle: Theme.of(context).textTheme.bodyText2,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              errorStyle: const TextStyle(height: 0),
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),
                          TextFormField(
                            onChanged: (value) =>
                                address.dptoInt = int.parse(value),
                            initialValue: address.dptoInt.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  numberValidatorReg),
                            ],
                            style: Theme.of(context).textTheme.bodyText2,
                            decoration: InputDecoration(
                              labelText: "Depto. /Int (opcional)",
                              hintText: "Ingrese su información",
                              labelStyle: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                              hintStyle: Theme.of(context).textTheme.bodyText2,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              errorStyle: const TextStyle(height: 0),
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),
                          TextFormField(
                            onChanged: (value) => address.urbanName = value,
                            initialValue: address.urbanName,
                            style: Theme.of(context).textTheme.bodyText2,
                            decoration: InputDecoration(
                              labelText: "Urbanización (opcional)",
                              hintText: "Ingrese su urbanización",
                              labelStyle: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                              hintStyle: Theme.of(context).textTheme.bodyText2,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              errorStyle: const TextStyle(height: 0),
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),
                          TextFormField(
                            onChanged: (value) => address.referenceName = value,
                            initialValue: address.referenceName,
                            style: Theme.of(context).textTheme.bodyText2,
                            decoration: InputDecoration(
                              labelText: "Referencia (opcional)",
                              hintText: "Ingrese alguna referencia",
                              labelStyle: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                              hintStyle: Theme.of(context).textTheme.bodyText2,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              errorStyle: const TextStyle(height: 0),
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Departamento',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black12.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              InkWell(
                                onTap: () async {
                                  await showDropdownRegions(
                                    context: context,
                                    regions: mainBloc.regions,
                                    onChangeRegion:
                                        (index, stateAlertRegion, context) {
                                      mainBloc.onChangeRegion(
                                        index: index,
                                        stateAlertRegion: stateAlertRegion,
                                      );

                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: ValueListenableBuilder(
                                        valueListenable:
                                            mainBloc.departmentName,
                                        builder:
                                            (context, String value, child) {
                                          return Text(
                                            value,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const Icon(
                                      CommunityMaterialIcons.arrow_down_box,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.black),
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Provincia',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black12.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              InkWell(
                                onTap: () async {
                                  await showDropdownProvinces(
                                    context: context,
                                    provinces: mainBloc.provinces,
                                    onChangeProvince:
                                        (index, stateAlertProvince, context) {
                                      mainBloc.onChangeProvince(
                                        index: index,
                                        stateAlertProvince: stateAlertProvince,
                                      );
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "address.province",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      CommunityMaterialIcons.arrow_down_box,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.black),
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Distrito',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black12.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              InkWell(
                                onTap: () async {
                                  await showDropdownDistricts(
                                    context: context,
                                    districts: mainBloc.districts,
                                    onChangeDistrict:
                                        (index, state, context) {},
                                  );
                                },
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "address.district",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      CommunityMaterialIcons.arrow_down_box,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.black),
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),
                          // _buildCheckboxFormField(
                          //   setStateParent: setStateParent,
                          //   address: address,
                          // ),
                          // FormError(errors: errors),
                          SizedBox(
                            height: getProportionateScreenHeight(40),
                          ),
                          DefaultButton(
                            text: "Continuar",
                            press: () {
                              // fnSubmit(
                              //   state: setStateParent,
                              //   userId: userId,
                              //   address: address,
                              //   context: context,
                              //   isAdd: isAdd,
                              // );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

Future<void> showDropdownAddressType({
  required List<Map<String, dynamic>> addressTypes,
  required BuildContext context,
  required Function(int) changeAddressType,
}) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 270.0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        CupertinoIcons.clear,
                        color: Colors.black45,
                        size: 16.0,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    const Expanded(
                      child: Text(
                        "Departamento",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                height: 2,
                color: Colors.black,
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  padding: const EdgeInsets.all(0.0),
                  itemCount: addressTypes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        changeAddressType(index);
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, bottom: 15.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(addressTypes[index]["name"]),
                                ),
                                if (addressTypes[index]["checked"])
                                  const Icon(
                                    CupertinoIcons.checkmark_alt,
                                    color: Colors.blueAccent,
                                    size: 20,
                                  )
                                else
                                  const SizedBox.shrink()
                              ],
                            ),
                          ),
                          const Divider(
                            height: 2,
                            color: Colors.black,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
