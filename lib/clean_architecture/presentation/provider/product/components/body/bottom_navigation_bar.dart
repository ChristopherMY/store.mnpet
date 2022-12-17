import 'package:flutter/material.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/product/components/body/custom_progress_button.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/product/components/body/product_price.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(27),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            blurRadius: 4.1,
            color: Colors.black12,
            offset: Offset(0, 2.1),
            spreadRadius: 2.4,
          )
        ],
      ),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: ProductPrice(),
          ),
          SizedBox(
            height: 45.0,
            width: SizeConfig.screenWidth! * 0.41,
            child: const CustomProgressButton(buttonComesFromModal: false),
          ),
        ],
      ),
    );
  }
}
