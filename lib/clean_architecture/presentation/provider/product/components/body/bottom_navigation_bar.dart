import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/components/body/custom_progress_button.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/product/components/body/product_price.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 63,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.black12),
      ),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: ProductPrice(),
          ),
          SizedBox(
            height: 45,
            width: SizeConfig.screenWidth! * 0.515,
            child: const CustomProgressButton(),
          ),

/*
                    Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: const BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Icon(
                              MaterialCommunityIcons.cart_outline,
                              color: Colors.white,
                            ),
                            Text(
                              "Añadir al carrito",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    */
        ],
      ),
    );
  }
}
