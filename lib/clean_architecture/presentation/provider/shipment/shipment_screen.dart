import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/local_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/phone/phone_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/shipment/shipment_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/dialog_helper.dart';

import '../../widget/button_crud.dart';

class ShipmentScreen extends StatelessWidget {
  const ShipmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: kBackGroundColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          bottomOpacity: 0.0,
          elevation: 0.0,
          title: const Text(
            "Dirección de envio",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 20.0,
                  ),
                  child: Text(
                    "Información de envío",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                AddressesDetail.init(context),
                PhonesDetail.init(context),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InformationTarget extends StatelessWidget {
  const InformationTarget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.black38),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddressesDetail extends StatelessWidget {
  const AddressesDetail._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ShipmentBloc(
        localRepositoryInterface: context.read<LocalRepositoryInterface>(),
        userRepositoryInterface: context.read<UserRepositoryInterface>(),
      ),
      builder: (context, child) => const AddressesDetail._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.watch<MainBloc>();
    final shipmentBloc = context.watch<ShipmentBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 190,
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(0),
                children: List.generate(
                  mainBloc.informationUser!.addresses.length,
                  (index) {
                    final address = mainBloc.informationUser!.addresses[index]!;
                    return SizedBox(
                      width: SizeConfig.screenWidth! -
                          SizeConfig.screenWidth! * 0.13,
                      child: Card(
                        color: Colors.white,
                        // margin: const EdgeInsets.all(5.0),
                        elevation: 1,
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(address.addressType!),
                                  Container(
                                    clipBehavior: Clip.hardEdge,
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: address!.addressDefault!
                                          ? Colors.green
                                          : Colors.white,
                                      border: Border.all(width: 0.5),
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      size: 15.0,
                                      color: address!.addressDefault!
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                "${address.ubigeo!.department} - ${address.ubigeo!.province} - ${address.ubigeo!.district}",
                              ),
                              const SizedBox(height: 5.0),
                              Expanded(
                                child: Text(address.direction!),
                              ),
                              Row(
                                children: [
                                  const Spacer(),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          shipmentBloc.isUpdate = true;
                                          shipmentBloc.address = address;

                                          await DialogHelper.showAddressDialog(
                                              context: context);
                                        },
                                        child: const CircleAvatar(
                                          radius: 15.0,
                                          backgroundColor: Colors.black,
                                          child: Icon(
                                            CommunityMaterialIcons
                                                .pencil_outline,
                                            size: 18.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      GestureDetector(
                                        onTap: () {
                                          shipmentBloc.onDeleteAddress(
                                            context,
                                            addressId: address.id!,
                                            headers: mainBloc.headers,
                                          );
                                        },
                                        child: const CircleAvatar(
                                          radius: 15.0,
                                          backgroundColor: Colors.black,
                                          child: Icon(
                                            CommunityMaterialIcons
                                                .trash_can_outline,
                                            size: 18.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          ButtonCrud(
            onTap: () async {
              shipmentBloc.isUpdate = false;
              //*****************************
              // Reset Selectors Pickers
              //*****************************

              for (var type in shipmentBloc.addressTypes) {
                type['checked'] = false;
              }

              for (final region in mainBloc.extraRegions) {
                region.checked = false;
              }

              for (final district in mainBloc.districts) {
                district.checked = false;
              }

              for (final province in mainBloc.provinces) {
                province.checked = false;
              }

              //*****************************
              // Reset address
              //*****************************

              shipmentBloc.address = Address(
                ubigeo: Ubigeo(
                  department: "Seleccione un departamento",
                  province: "Seleccione una provincia",
                  district: "Seleccione un distrito",
                ),
                addressType: "Seleccione un tipo",
                lotNumber: 1,
                dptoInt: 1,
                addressDefault: false,
              );

              await DialogHelper.showAddressDialog(context: context);
            },
            titleButton: "Añadir dirección",
          ),
        ],
      ),
    );
  }
}

// class ItemAddress extends StatelessWidget {
//   const ItemAddress({
//     Key? key,
//     required this.address,
//   }) : super(key: key);
//
//   final Address address;
//
//   @override
//   Widget build(BuildContext context) {
//     final shipmentBloc = Provider.of<ShipmentBloc>(context);
//     final mainBloc = Provider.of<MainBloc>(context);
//
//     return Container(
//       decoration: const BoxDecoration(
//           border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         address.addressType!,
//                         style: Theme.of(context).textTheme.bodyText1,
//                       ),
//                       const SizedBox(height: 5.0),
//                       Text(
//                         address.direction!,
//                         style: Theme.of(context).textTheme.bodyText2,
//                       ),
//                       const SizedBox(height: 5.0),
//                       Text(
//                         "${address.ubigeo!.department} - ${address.ubigeo!.province} - ${address.ubigeo!.district}",
//                         style: Theme.of(context).textTheme.bodyText2,
//                       ),
//                       const SizedBox(height: 15.0),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 8.0),
//                 SizedBox(
//                   width: 30.0,
//                   height: 30.0,
//                   child: RoundCheckBox(
//                     onTap: (selected) async {
//                       context.loaderOverlay.show();
//                       address.addressDefault = selected;
//
//                       final response =
//                           await shipmentBloc.onChangeDefaultAddress(
//                         addressId: address.id!,
//                         headers: mainBloc.headers,
//                       );
//
//                       if (response is ResponseApi) {
//                         final responseUserInformation =
//                             await mainBloc.getUserInformation();
//
//                         if (responseUserInformation is UserInformation) {
//                           mainBloc.informationUser = responseUserInformation;
//                           mainBloc.refreshMainBloc();
//
//                           await GlobalSnackBar.showInfoSnackBarIcon(
//                             context,
//                             response.message,
//                           );
//
//                           context.loaderOverlay.hide();
//                           return;
//                         }
//                       }
//
//                       context.loaderOverlay.hide();
//                       await GlobalSnackBar.showWarningSnackBar(
//                         context,
//                         "Ups, vuelvalo a intentar más tarde",
//                       );
//                     },
//                     isChecked: address.addressDefault,
//                     uncheckedWidget: const Icon(Icons.close),
//                     animationDuration: const Duration(milliseconds: 90),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
