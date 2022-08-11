import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/district.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/province.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/region.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/form_error.dart';

class DialogHelper {
  Future<void> showDialogShipping({
    required BuildContext context,
    required Function(BuildContext, StateSetter) onSaveShippingAddress,
  }) {
    return showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext _) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter stateAlertMain) {
            final mainBloc = Provider.of<MainBloc>(context, listen: true);

            return AlertDialog(
              title: const Text(
                'Calcular envío en otra dirección',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        showDropdownRegions(
                          context: context,
                          onChangeRegion: (index, stateAlertRegion, context) {
                            mainBloc.onChangeRegion(
                              index: index,
                              stateAlertMain: stateAlertMain,
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
                            child: Text(
                              mainBloc.departmentName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
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
                                stateAlertMain: stateAlertMain,
                                stateAlertProvince: stateAlertProvince,
                              );
                              Navigator.of(context).pop();
                            });
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              mainBloc.provinceName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
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
                              stateAlertMain: stateAlertMain,
                              stateAlertDistrict: stateAlertDistrict,
                            );
                            Navigator.of(context).pop();
                          },
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              mainBloc.districtName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
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
                          onTap: () =>
                              onSaveShippingAddress(context, stateAlertMain),
                          child: Container(
                            height: 35,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  kPrimaryColor,
                                  kPrimaryColor,
                                ],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                              boxShadow: [
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
                              "Departamento",
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
}
