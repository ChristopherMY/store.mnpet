import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/local_repository.dart';

import 'package:store_mundo_pet/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/phone/phone_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/dialog_helper.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/global_snackbar.dart';

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Teléfonos: "),
          const SizedBox(width: 5.0),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                for (Phone phone in mainBloc.informationUser!.phones)
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      highlightColor: kPrimaryColor,
                      onTap: () async {
                        phoneBloc.isUpdate = true;
                        phoneBloc.phone = phone;

                        await DialogHelper().showPhonesDialog(context: context);
                      },
                      child: ItemPhone(
                        phone: phone,
                      ),
                    ),
                  ),
                mainBloc.informationUser!.phones.isNotEmpty
                    ? const SizedBox(
                        height: 15.0,
                      )
                    : const SizedBox(),
                GestureDetector(
                  onTap: () async {
                    phoneBloc.isUpdate = false;
                    await DialogHelper().showPhonesDialog(context: context);
                  },
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 25.0,
                        height: 25.0,
                        child: Icon(CupertinoIcons.plus_circle),
                      ),
                      SizedBox(width: 10.0),
                      Text("Añadir teléfono")
                    ],
                  ),
                ),
              ],
            ),
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
