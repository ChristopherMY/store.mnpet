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
        border: Border.all(width: 0.5, color: Colors.black12),
      ),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: ProductPrice(),
          ),
          SizedBox(
            height: 45.0,
            width: SizeConfig.screenWidth! * 0.515,
            child: const CustomProgressButton(buttonComesFromModal: false),
          ),
        ],
      ),
    );
  }
}
