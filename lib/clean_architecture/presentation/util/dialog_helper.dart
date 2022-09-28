import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/district.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/product.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/province.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/region.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/sort_option.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/phone/phone_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/components/body/custom_progress_button.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/components/body/info_attributes.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/product_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/search_detail/search_detail_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/shipment/shipment_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/global_snackbar.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/default_button.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/form_error.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/item_button.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/sort_option.dart'
    as sort_option;

class DialogHelper {
  static const String _cloudFront = Environment.API_DAO;

  static Future<void> showDialogShipping({
    required BuildContext context,
    required Function(BuildContext) onSaveShippingAddress,
  }) {
    return showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext _) {
        return ChangeNotifierProvider<MainBloc>.value(
          value: Provider.of<MainBloc>(context, listen: false),
          builder: (context, child) {
            final mainBloc = Provider.of<MainBloc>(context);
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
                              builder: (context, String districtName, child) {
                                return Text(
                                  districtName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                              },
                            ),
                          ),
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
                      child: ValueListenableBuilder(
                        valueListenable: mainBloc.errors,
                        builder: (context, List<String> value, child) {
                          return FormError(errors: value);
                        },
                      ),
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

  static Future<void> showDropdownRegions({
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
                        padding: const EdgeInsets.all(0.0),
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
                                    top: 15.0,
                                    bottom: 15.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text('${regions[index].name}'),
                                      ),
                                      regions[index].checked == true
                                          ? const SizedBox(
                                              height: 15.0,
                                              child: Icon(
                                                CupertinoIcons.checkmark_alt,
                                                color: Colors.blueAccent,
                                                size: 20.0,
                                              ),
                                            )
                                          : const SizedBox.shrink()
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 2.0,
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

  static Future<void> showDropdownProvinces({
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

  static Future<void> showDropdownDistricts({
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
                                              height: 15.0,
                                              child: Icon(
                                                CupertinoIcons.checkmark_alt,
                                                color: Colors.blueAccent,
                                                size: 20.0,
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 2.0,
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

  static Future<void> showAddressDialog({
    required BuildContext context,
  }) {
    return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context_) {
        return ChangeNotifierProvider<ShipmentBloc>.value(
          value: Provider.of<ShipmentBloc>(context, listen: false)
            ..errors.value.clear(),
          child: DraggableScrollableSheet(
            initialChildSize: 0.91,
            minChildSize: 0.20,
            maxChildSize: 0.91,
            builder: (__, controller) {
              final shipmentBloc = Provider.of<ShipmentBloc>(__);
              final mainBloc = Provider.of<MainBloc>(__);
              return Container(
                height: SizeConfig.screenHeight,
                margin: const EdgeInsets.only(top: 50.0),
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10.0, right: 15.0, bottom: 15.0, left: 15.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              shipmentBloc.isUpdate
                                  ? "Actualizar Dirección"
                                  : "Nueva Dirección",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            iconSize: 21.0,
                            icon: const Icon(CupertinoIcons.clear),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(5.0),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Form(
                            key: shipmentBloc.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  initialValue:
                                      shipmentBloc.address.addressName,
                                  onChanged: shipmentBloc.onChangeAddressName,
                                  validator:
                                      shipmentBloc.onValidationAddressName,
                                  style: Theme.of(context).textTheme.bodyText2,
                                  decoration: InputDecoration(
                                    labelText: "Nombre de dirección",
                                    hintText: "Ej. Mi Casa, trabajo etc",
                                    labelStyle: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    hintStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    errorStyle: const TextStyle(height: 0),
                                  ),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(20.0),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tipo de dirección',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                    const SizedBox(height: 5),
                                    InkWell(
                                      onTap: () {
                                        showDropdownAddressType(
                                          addressTypes:
                                              shipmentBloc.addressTypes,
                                          context: context,
                                          changeAddressType: (index) {
                                            shipmentBloc.onChangeAddressTypes(
                                              index: index,
                                            );
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              shipmentBloc
                                                      .address.addressType ??
                                                  "Seleccione un tipo",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_drop_down_outlined,
                                            color: Colors.black,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.black),
                                SizedBox(
                                  height: getProportionateScreenHeight(20.0),
                                ),
                                TextFormField(
                                  initialValue: shipmentBloc.address.direction,
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
                                    hintStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    errorStyle: const TextStyle(height: 0),
                                  ),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(20.0),
                                ),
                                TextFormField(
                                  initialValue: shipmentBloc.address.lotNumber!
                                      .toString(),
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
                                    hintStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    errorStyle: const TextStyle(height: 0),
                                  ),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(20.0),
                                ),
                                TextFormField(
                                  onChanged: shipmentBloc.onChangeDPTO,
                                  initialValue:
                                      shipmentBloc.address.dptoInt.toString(),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                      numberValidatorReg,
                                    ),
                                  ],
                                  style: Theme.of(context).textTheme.bodyText2,
                                  decoration: InputDecoration(
                                    labelText: "Depto. /Int (opcional)",
                                    hintText: "Ingrese su información",
                                    labelStyle: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    hintStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    errorStyle: const TextStyle(height: 0.0),
                                  ),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(20.0),
                                ),
                                TextFormField(
                                  onChanged: (value) =>
                                      shipmentBloc.address.urbanName = value,
                                  initialValue: shipmentBloc.address.urbanName,
                                  style: Theme.of(context).textTheme.bodyText2,
                                  decoration: InputDecoration(
                                    labelText: "Urbanización (opcional)",
                                    hintText: "Ingrese su urbanización",
                                    labelStyle: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    hintStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    errorStyle: const TextStyle(height: 0.0),
                                  ),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(20.0),
                                ),
                                TextFormField(
                                  onChanged: (value) => shipmentBloc
                                      .address.referenceName = value,
                                  initialValue:
                                      shipmentBloc.address.referenceName,
                                  style: Theme.of(context).textTheme.bodyText2,
                                  decoration: InputDecoration(
                                    labelText: "Referencia (opcional)",
                                    hintText: "Ingrese alguna referencia",
                                    labelStyle: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    hintStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    errorStyle: const TextStyle(height: 0.0),
                                  ),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(20.0),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Departamento',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black12.withOpacity(0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    InkWell(
                                      onTap: () async {
                                        await showDropdownRegions(
                                          context: context,
                                          regions: mainBloc.extraRegions,
                                          onChangeRegion: (index,
                                              stateAlertRegion, context) {
                                            shipmentBloc.onChangeRegion(
                                              index: index,
                                              regions: mainBloc.extraRegions,
                                              stateAlertRegion:
                                                  stateAlertRegion,
                                            );

                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              shipmentBloc.address.ubigeo!
                                                      .department ??
                                                  "Seleccione un departamento",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_drop_down_outlined,
                                            color: Colors.black,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.black),
                                SizedBox(
                                  height: getProportionateScreenHeight(20.0),
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
                                          provinces: shipmentBloc.provinces,
                                          onChangeProvince: (index,
                                              stateAlertProvince, context) {
                                            shipmentBloc.onChangeProvince(
                                              index: index,
                                              stateAlertProvince:
                                                  stateAlertProvince,
                                            );
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              shipmentBloc.address.ubigeo!
                                                      .province ??
                                                  "Seleccione una provincia",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_drop_down_outlined,
                                            color: Colors.black,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.black),
                                SizedBox(
                                  height: getProportionateScreenHeight(20.0),
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
                                          districts: shipmentBloc.districts,
                                          onChangeDistrict: (index,
                                              stateAlertDistrict, context) {
                                            shipmentBloc.onChangeDistrict(
                                              index: index,
                                              stateAlertDistrict:
                                                  stateAlertDistrict,
                                            );

                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              shipmentBloc.address.ubigeo!
                                                      .district ??
                                                  "Seleccione un distrito",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_drop_down_outlined,
                                            color: Colors.black,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.black),
                                SizedBox(
                                  height: getProportionateScreenHeight(15.0),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      checkColor: Colors.white,
                                      fillColor:
                                          MaterialStateProperty.resolveWith(
                                        shipmentBloc.getColor,
                                      ),
                                      value:
                                          shipmentBloc.address.addressDefault,
                                      onChanged:
                                          shipmentBloc.onChangeAddressDefault,
                                    ),
                                    Text(
                                      "Usar como dirección predeterminada",
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                                ValueListenableBuilder(
                                  valueListenable: shipmentBloc.errors,
                                  builder:
                                      (context, List<String> value, child) {
                                    return Column(
                                      children: [
                                        value.isNotEmpty
                                            ? SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                  20.0,
                                                ),
                                              )
                                            : const SizedBox(),
                                        FormError(errors: value),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(20.0),
                                ),
                                ItemButton(
                                  title: "Eliminar dirección",
                                  press: () async {
                                    context.loaderOverlay.show();
                                    Navigator.of(context).pop();
                                    final response =
                                        await shipmentBloc.onDeleteAddress(
                                      addressId: shipmentBloc.address.id!,
                                      headers: mainBloc.headers,
                                    );

                                    if (response is ResponseApi) {
                                      shipmentBloc.address = Address(
                                        ubigeo: Ubigeo(),
                                        lotNumber: 1,
                                        dptoInt: 1,
                                        addressDefault: false,
                                      );

                                      final responseUserInformation =
                                          await mainBloc.getUserInformation();

                                      if (responseUserInformation) {
                                        mainBloc.informationUser =
                                            responseUserInformation;

                                        mainBloc.refreshMainBloc();
                                        context.loaderOverlay.hide();
                                        await GlobalSnackBar
                                            .showInfoSnackBarIcon(
                                          context,
                                          response.message,
                                        );

                                        return;
                                      }
                                    }

                                    context.loaderOverlay.hide();
                                    await GlobalSnackBar.showWarningSnackBar(
                                      context,
                                      "Ups, vuelvalo a intentar más tarde",
                                    );

                                    return;
                                  },
                                  icon: Icons.delete_forever_sharp,
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(20.0),
                                ),
                                DefaultButton(
                                  text: "Continuar",
                                  press: () async {
                                    if (shipmentBloc.formKey.currentState!
                                        .validate()) {
                                      shipmentBloc.formKey.currentState!.save();

                                      shipmentBloc.address.ubigeo!.department ==
                                                  "Seleccione un departamento" ||
                                              shipmentBloc.address.ubigeo!
                                                      .department ==
                                                  "Seleccione"
                                          ? shipmentBloc.addError(
                                              error: kDeparmentNullError,
                                            )
                                          : shipmentBloc.removeError(
                                              error: kDeparmentNullError);

                                      shipmentBloc.address.ubigeo!.province ==
                                                  "Seleccione una provincia" ||
                                              shipmentBloc.address.ubigeo!
                                                      .province ==
                                                  "Seleccione"
                                          ? shipmentBloc.addError(
                                              error: kProvinceNullError,
                                            )
                                          : shipmentBloc.removeError(
                                              error: kProvinceNullError,
                                            );

                                      shipmentBloc.address.ubigeo!.district ==
                                                  "Seleccione un distrito" ||
                                              shipmentBloc.address.ubigeo!
                                                      .district ==
                                                  "Seleccione"
                                          ? shipmentBloc.addError(
                                              error: kDistrictNullError,
                                            )
                                          : shipmentBloc.removeError(
                                              error: kDistrictNullError,
                                            );

                                      if (shipmentBloc.errors.value.isEmpty) {
                                        context.loaderOverlay.show();
                                        Navigator.of(context).pop();
                                        final response =
                                            await shipmentBloc.onSave(
                                          headers: mainBloc.headers,
                                        );

                                        if (response is ResponseApi) {
                                          shipmentBloc.address = Address(
                                            ubigeo: Ubigeo(),
                                            lotNumber: 1,
                                            dptoInt: 1,
                                            addressDefault: false,
                                          );

                                          final responseUserInformation =
                                              await mainBloc
                                                  .getUserInformation();

                                          if (responseUserInformation) {
                                            mainBloc.informationUser =
                                                responseUserInformation;
                                            mainBloc.refreshMainBloc();
                                            context.loaderOverlay.hide();

                                            if (response.message == "success") {
                                              return await GlobalSnackBar
                                                  .showInfoSnackBarIcon(
                                                context,
                                                response.message,
                                              );
                                            }

                                            return await GlobalSnackBar
                                                .showErrorSnackBarIcon(
                                              context,
                                              response.message,
                                            );
                                          }
                                        }

                                        context.loaderOverlay.hide();
                                        await GlobalSnackBar
                                            .showWarningSnackBar(
                                          context,
                                          "Ups, vuelvalo a intentar más tarde",
                                        );

                                        return;
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
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
      },
    );
  }

  static Future<void> showPhonesDialog({
    required BuildContext context,
  }) {
    return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context_) {
        return ChangeNotifierProvider<PhoneBloc>.value(
          value: Provider.of<PhoneBloc>(context, listen: false)
            ..errors.value.clear(),
          child: DraggableScrollableSheet(
            initialChildSize: 0.51,
            minChildSize: 0.20,
            maxChildSize: 0.51,
            builder: (__, controller) {
              final phoneBloc = Provider.of<PhoneBloc>(__);
              final mainBloc = Provider.of<MainBloc>(__);
              return Container(
                height: SizeConfig.screenHeight,
                margin: const EdgeInsets.only(top: 50.0),
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10.0, right: 15.0, bottom: 15.0, left: 15.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              phoneBloc.isUpdate
                                  ? "Actualizar Teléfono"
                                  : "Nuevo Teléfono",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            iconSize: 21.0,
                            icon: const Icon(CupertinoIcons.clear),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(5.0),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Form(
                            key: phoneBloc.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  initialValue: phoneBloc.phone.value,
                                  onChanged: phoneBloc.onChangePhoneNumber,
                                  validator: phoneBloc.onValidationPhoneNumber,
                                  style: Theme.of(context).textTheme.bodyText2,
                                  maxLength: 9,
                                  decoration: InputDecoration(
                                    labelText: "Teléfono",
                                    hintText: "Ingresa tu teléfono",
                                    labelStyle: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    hintStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    errorStyle: const TextStyle(height: 0),
                                  ),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(15.0),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      checkColor: Colors.white,
                                      fillColor:
                                          MaterialStateProperty.resolveWith(
                                        phoneBloc.getColor,
                                      ),
                                      value: phoneBloc.phone.phoneDefault,
                                      onChanged: phoneBloc.onChangePhoneDefault,
                                    ),
                                    Text(
                                      "Usar como teléfono predeterminado",
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                                ValueListenableBuilder(
                                  valueListenable: phoneBloc.errors,
                                  builder:
                                      (context, List<String> value, child) {
                                    return Column(
                                      children: [
                                        value.isNotEmpty
                                            ? SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                  20.0,
                                                ),
                                              )
                                            : const SizedBox(),
                                        FormError(errors: value),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(20.0),
                                ),
                                ItemButton(
                                  title: "Eliminar teléfono",
                                  press: () async {
                                    context.loaderOverlay.show();
                                    Navigator.of(context).pop();
                                    final response =
                                        await phoneBloc.onDeletePhone(
                                      phoneId: phoneBloc.phone.id!,
                                      headers: mainBloc.headers,
                                    );

                                    if (response is ResponseApi) {
                                      phoneBloc.phone = Phone(
                                        phoneDefault: false,
                                        type: "phone",
                                        areaCode: "51",
                                      );

                                      final responseUserInformation =
                                          await mainBloc.getUserInformation();

                                      if (responseUserInformation) {
                                        mainBloc.informationUser =
                                            responseUserInformation;
                                        mainBloc.refreshMainBloc();
                                        context.loaderOverlay.hide();

                                        await GlobalSnackBar
                                            .showInfoSnackBarIcon(
                                          context,
                                          response.message,
                                        );

                                        return;
                                      }
                                    }

                                    context.loaderOverlay.hide();
                                    await GlobalSnackBar.showWarningSnackBar(
                                      context,
                                      "Ups, vuelvalo a intentar más tarde",
                                    );

                                    return;
                                  },
                                  icon: Icons.delete_forever_sharp,
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(20.0),
                                ),
                                DefaultButton(
                                  text: "Continuar",
                                  press: () async {
                                    if (phoneBloc.formKey.currentState!
                                        .validate()) {
                                      phoneBloc.formKey.currentState!.save();
                                      if (phoneBloc.errors.value.isEmpty) {
                                        context.loaderOverlay.show();
                                        Navigator.of(context).pop();
                                        final response = await phoneBloc.onSave(
                                          headers: mainBloc.headers,
                                        );

                                        if (response is ResponseApi) {
                                          phoneBloc.phone = Phone(
                                            phoneDefault: false,
                                            type: "phone",
                                            areaCode: "51",
                                          );

                                          final responseUserInformation =
                                              await mainBloc
                                                  .getUserInformation();

                                          if (responseUserInformation) {
                                            mainBloc.informationUser =
                                                responseUserInformation;
                                            mainBloc.refreshMainBloc();
                                            context.loaderOverlay.hide();

                                            if (response.status == "success") {
                                              return await GlobalSnackBar
                                                  .showInfoSnackBarIcon(
                                                context,
                                                response.message,
                                              );
                                            }

                                            return await GlobalSnackBar
                                                .showErrorSnackBarIcon(
                                              context,
                                              response.message,
                                            );
                                          }
                                        }

                                        context.loaderOverlay.hide();
                                        await GlobalSnackBar
                                            .showWarningSnackBar(
                                          context,
                                          "Ups, vuelvalo a intentar más tarde",
                                        );

                                        return;
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
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
      },
    );
  }

  static Future<void> showDropdownAddressType({
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
                          "Tipo de dirección",
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
                              padding: const EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
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

  static Future<void> settingModalBottomSheetAttributes({
    required BuildContext context,
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
                                  BuildContext context,
                                  List<ProductAttribute> value,
                                  child,
                                ) {
                                  return BuildAttributesSections(
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
                                    onShowDialogShipping: () async {
                                      await showDialogShipping(
                                        context: context,
                                        onSaveShippingAddress: (_) async {
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

                                            Navigator.of(_).pop();
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 50.0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.0),
                                child: CustomProgressButton(
                                  buttonComesFromModal: true,
                                ),
                              ),
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
                                          "$_cloudFront/${value.attributes!.first.image!.src!}",
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        );
                                      },
                                      placeholder: (context, url) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        );
                                      },
                                      errorWidget: (context, url, error) {
                                        return Container(
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
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 50.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20.0,
                                    left: 20.0,
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
                              width: 15.0,
                              child: RawMaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(
                                  CupertinoIcons.clear,
                                  size: 18.0,
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

  static Future<void> settingModalBottomSpecs({
    required BuildContext context,
  }) async {
    return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext _) {
        return ChangeNotifierProvider<ProductBloc>.value(
          value: Provider.of<ProductBloc>(context),
          child: DraggableScrollableSheet(
            initialChildSize: 0.94,
            minChildSize: 0.2,
            maxChildSize: 0.94,
            builder: (_, controller) {
              final productBloc = _.watch<ProductBloc>();
              return Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Detalles del artículo: ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 16,
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(
                                      CupertinoIcons.clear,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Divider(color: kDividerColor),
                            SingleChildScrollView(
                              child: Column(
                                children: productBloc.product!.specifications!
                                    .map(
                                      (e) => SizedBox(
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(e.header!),
                                                ),
                                                Expanded(
                                                  child: Text(e.body!),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: double.infinity,
                                              child: Divider(
                                                color: Color(0xE5CBCBCB),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  static Future<void> showSortOptions(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(34.0),
          topRight: Radius.circular(34.0),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (_) {
        return ChangeNotifierProvider<SearchDetailBloc>.value(
          value: Provider.of<SearchDetailBloc>(context),
          builder: (_, __) {
            final searchDetailBloc = context.watch<SearchDetailBloc>();
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: 60.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF979797),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const Text(
                  'Ordenar por',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                ),
                ValueListenableBuilder(
                  valueListenable: searchDetailBloc.sort,
                  builder: (context, List<SortOption> elements, child) {
                    return Column(
                      children: List.generate(
                        elements.length,
                        (index) => sort_option.SortOption(
                          onChange: () {
                            searchDetailBloc.handleChangeOptionSort(index);
                            Navigator.pop(context);
                          },
                          title: elements[index].title!,
                          isChecked: elements[index].isChecked!,
                        ),
                      ).toList().cast(),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
