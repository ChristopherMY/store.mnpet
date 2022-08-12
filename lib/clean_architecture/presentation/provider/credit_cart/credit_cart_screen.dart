import 'package:awesome_card/awesome_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';

class CreditCartScreen extends StatelessWidget {
  const CreditCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis tarjetas"),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: kPrimaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: kPrimaryColor,
      ),
      backgroundColor: kBackGroundColor,
      body: SizedBox(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: 3,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisExtent: 240,
              ),
              itemBuilder: (BuildContext context, int index) {
                return CreditCard(
                  cardNumber: "4557 8049 5667 101",
                  cardExpiry: "10/25",
                  cardHolderName: "Card Holder",
                  cvv: "456",
                  bankName: "Axis Bank",
                  cardType: CardType.masterCard,
                  // showBackSide: false,
                  horizontalMargin: 0,
                  frontBackground: CardBackgrounds.custom(0xFF17C3B2),
                  backBackground: CardBackgrounds.white,
                  //  showShadow: true,
                  textExpDate: 'Exp. Date',
                  textName: 'Name',
                  textExpiry: 'MM/YY',
                  height: 180,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
