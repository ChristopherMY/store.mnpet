import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/shipment/shipment_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/dialog_helper.dart';

class ShipmentScreen extends StatelessWidget {
  const ShipmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Text("Información de envío"),
              ),
              AddressesDetail.init(context),
              const PhonesDetail(),
              const SizedBox(height: 15.0),
            ],
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
      create: (context) => ShipmentBloc(),
      builder: (context, child) => const AddressesDetail._(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Text("Direcciones: "),
          ),
          const SizedBox(width: 5.0),
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: () {
                // _showModalBottomSheetAddress(
                //   context: context,
                //   userId: "",
                //   address: Address(
                //     addressName: "",
                //     addressType: "Seleccione un tipo de dirección",
                //     department: "Seleccione un departamento",
                //     departmentId: null,
                //     direction: "",
                //     districtId: null,
                //     id: null,
                //     district: "Seleccione un distrito",
                //     province: "Seleccione una provincia",
                //     dptoInt: 0,
                //     lastname: "",
                //     lotNumber: 0,
                //     main: false,
                //     name: "",
                //     phoneNumber: "",
                //     phoneNumberOptional: "",
                //     provinceId: null,
                //     referenceName: "",
                //     urbanName: "",
                //   ),
                //   isAdd: true,
                // );
              },
              child: Column(
                children: [
                  for (Address address in mainBloc.informationUser!.addresses)
                    ItemAddress(
                      addressType: address.addressType!,
                      direction: address.direction!,
                      ubigeo:
                          "${address.ubigeo!.department!} - ${address.ubigeo!.province!} - ${address.ubigeo!.district!}",
                    ),
                  GestureDetector(
                    onTap: () async {
                      final DialogHelper dialogHelper = DialogHelper();
                      await dialogHelper.showAddressDialog(
                        context: context,
                        address: Address(),
                        isAdd: true,
                      );
                    },
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 25.0,
                          height: 25.0,
                          child: Icon(CupertinoIcons.plus_circle),
                        ),
                        SizedBox(width: 10.0),
                        Text("Añadir dirección")
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PhonesDetail extends StatelessWidget {
  const PhonesDetail({Key? key}) : super(key: key);

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
          const Expanded(
            child: Text("Teléfonos: "),
          ),
          const SizedBox(width: 5.0),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                _buildRowsPhonesDetails(),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        print("Clicked");
                      },
                      child: Container(
                        // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "+",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Text("Añadir teléfono")
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildRowsPhonesDetails() {
    List<Widget> widget = [];
    var trying = [1];

    widget.addAll(
      trying.map(
        (e) => new Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("(+51) 953 234 644"),
              SizedBox(height: 15),
              Divider(
                height: 1,
                color: Colors.black26,
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
    return Column(children: widget);
  }
}

class ItemAddress extends StatelessWidget {
  const ItemAddress({
    Key? key,
    required this.addressType,
    required this.direction,
    required this.ubigeo,
  }) : super(key: key);

  final String addressType;
  final String direction;
  final String ubigeo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    addressType,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    direction,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    ubigeo,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            SizedBox(
              width: 30,
              height: 30,
              child: RoundCheckBox(
                onTap: (selected) {},
                uncheckedWidget: Icon(Icons.close),
                animationDuration: Duration(
                  milliseconds: 90,
                ),
              ),
            ),
          ],
        ),
        const Divider(
          height: 1,
          color: Colors.black26,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
