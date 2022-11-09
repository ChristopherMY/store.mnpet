import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/local_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/phone/phone_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/dialog_helper.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/global_snackbar.dart';

import '../../widget/button_crud.dart';

class PhonesDetail extends StatelessWidget {
  const PhonesDetail._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PhoneBloc(
        localRepositoryInterface: context.read<LocalRepositoryInterface>(),
        userRepositoryInterface: context.read<UserRepositoryInterface>(),
      ),
      builder: (context, child) => const PhonesDetail._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phoneBloc = context.watch<PhoneBloc>();
    final mainBloc = context.watch<MainBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 135,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 0.0),
              scrollDirection: Axis.horizontal,
              children: List.generate(
                mainBloc.informationUser.phones.length,
                (index) {
                  final Phone phone = mainBloc.informationUser.phones[index];
                  return SizedBox(
                    width: SizeConfig.screenWidth! -
                        SizeConfig.screenWidth! * 0.13,
                    child: Card(
                      color: Colors.white,
                      // margin: const EdgeInsets.all(5.0),
                      elevation: 2,
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Número de teléfono",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!,
                                      ),
                                      Container(
                                        clipBehavior: Clip.hardEdge,
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: phone.phoneDefault!
                                              ? Colors.green
                                              : Colors.white,
                                          border: Border.all(width: 0.5),
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 15.0,
                                          color: phone.phoneDefault!
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text("+51 ${splitNumberJoin(phone.value!)}"),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    phoneBloc.isUpdate = true;
                                    phoneBloc.phone = phone;

                                    await DialogHelper.showPhonesDialog(
                                        context: context);
                                  },
                                  child: const CircleAvatar(
                                    radius: 15.0,
                                    backgroundColor: Colors.black,
                                    child: Icon(
                                      CommunityMaterialIcons.pencil_outline,
                                      size: 18.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                GestureDetector(
                                  onTap: () async {
                                    context.loaderOverlay.show();
                                    final response =
                                        await phoneBloc.onDeletePhone(
                                      phoneId: phone.id!,
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

                                      if (responseUserInformation
                                          is UserInformation) {
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
                                  child: const CircleAvatar(
                                    radius: 15.0,
                                    backgroundColor: Colors.black,
                                    child: Icon(
                                      CommunityMaterialIcons.trash_can_outline,
                                      size: 18.0,
                                      color: Colors.white,
                                    ),
                                  ),
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
          ButtonCrud(
            onTap: () async {
              phoneBloc.isUpdate = false;
              await DialogHelper.showPhonesDialog(context: context);
            },
            titleButton: "Añadir teléfono",
          ),
        ],
      ),
    );
  }
}

class ItemPhone extends StatelessWidget {
  const ItemPhone({Key? key, required this.phone}) : super(key: key);
  final Phone phone;

  @override
  Widget build(BuildContext context) {
    final phoneBloc = context.watch<PhoneBloc>();
    final mainBloc = context.watch<MainBloc>();
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("(+51) ${phone.value}"),
                      const SizedBox(height: 15.0),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                SizedBox(
                  width: 30.0,
                  height: 30.0,
                  child: RoundCheckBox(
                    onTap: (selected) async {
                      context.loaderOverlay.show();
                      phone.phoneDefault = selected;

                      final response = await phoneBloc.onChangeDefaultPhone(
                        phoneId: phone.id!,
                        headers: mainBloc.headers,
                      );

                      if (response is ResponseApi) {
                        final responseUserInformation =
                            await mainBloc.getUserInformation();

                        if (responseUserInformation is UserInformation) {
                          mainBloc.informationUser = responseUserInformation;
                          mainBloc.refreshMainBloc();

                          await GlobalSnackBar.showInfoSnackBarIcon(
                            context,
                            response.message,
                          );

                          context.loaderOverlay.hide();
                          return;
                        }
                      }

                      context.loaderOverlay.hide();
                      await GlobalSnackBar.showWarningSnackBar(
                        context,
                        "Ups, vuelvalo a intentar más tarde",
                      );
                    },
                    isChecked: phone.phoneDefault,
                    uncheckedWidget: const Icon(Icons.close),
                    animationDuration: const Duration(milliseconds: 90),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
