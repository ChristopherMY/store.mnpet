import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/region_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/phone/phone_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/dialog_helper.dart';

class PhonesDetail extends StatelessWidget {
  const PhonesDetail._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PhoneBloc(
        regionRepositoryInterface: context.read<RegionRepositoryInterface>(),
        userRepositoryInterface: context.read<UserRepositoryInterface>(),
      ),
      builder: (context, child) => const PhonesDetail._(),
    );
  }

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
                      onTap: () async {
                        await DialogHelper().showPhonesDialog(context: context);
                      },
                      child: Container(
                        // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                        width: 25.0,
                        height: 25.0,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Text(
                          "+",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    const Text("Añadir teléfono")
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
