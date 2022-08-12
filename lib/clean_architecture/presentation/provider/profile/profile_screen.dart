import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: kSecondaryBackgroundColor,
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
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Información de envío"),
                    Icon(CupertinoIcons.plus)
                  ],
                ),
              ),
              InformationTarget(
                title: "Nombres: ",
                value: "Christopher jean pierre",
              ),
              InformationTarget(
                title: "Apellidos: ",
                value: "Monzon Yacua",
              ),
              InformationTarget(
                title: "Email:",
                value: "christopher_jean_pierre@outlook.com",
              ),
              SizedBox(
                height: getProportionateScreenHeight(10.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Text("Información de envío"),
              ),
              AddressesDetail(),
              PhonesDetail(),


              SizedBox(height: 15.0),
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
  const AddressesDetail({Key? key}) : super(key: key);

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
            child: Text("Direcciones: "),
          ),
          Expanded(
            flex: 3,
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
                  _buildRowsAddressesDetails(),
                  Row(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "+",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      const Text("Añadir dirección")
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildRowsAddressesDetails() {
    List<Widget> widget = [];
    var trying = [1];

    widget.addAll(
      trying.map(
        (e) => Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mi casa",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text("Mz t, l2, trebol azul, san juan de miraflores"),
                      SizedBox(height: 5),
                      Text("Lima - Lima - San juan de miraflores"),
                      SizedBox(height: 15),
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
            Divider(
              height: 1,
              color: Colors.black26,
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
    return Column(children: widget);
  }
}

class PhonesDetail extends StatelessWidget {
  const PhonesDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text("Teléfonos: "),
          ),
          Expanded(
            flex: 3,
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
                    SizedBox(width: 10),
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
