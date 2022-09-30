import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/cart/cart_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/checkout_info/checkout_info_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/default_button.dart';

class CheckoutInfoScreen extends StatefulWidget {
  const CheckoutInfoScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider<CartBloc>.value(
      value: context.read<CartBloc>(),
      child: ChangeNotifierProvider<CheckOutInfoBloc>(
        create: (context) => CheckOutInfoBloc(),
        builder: (_, __) => const CheckoutInfoScreen._(),
      ),
    );
    ;
  }

  @override
  State<CheckoutInfoScreen> createState() => _CheckoutInfoScreenState();
}

class _CheckoutInfoScreenState extends State<CheckoutInfoScreen> {
  bool hasTe = false;
  final pageController = PageController();

  final colors = [
    Colors.grey.shade300,
    Colors.grey.shade300,
  ];

  @override
  Widget build(BuildContext context) {
    final cartBloc = context.read<CartBloc>();
    final mainBloc = context.read<MainBloc>();
    final checkoutInfoBloc = context.read<CheckOutInfoBloc>();

    final pages = List.generate(
      2,
      (index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.grey.shade300,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mis direcciónes",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "* Se debe de mantener un registro como principal",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 190,
              child: Padding(
                padding: const EdgeInsets.only(left: 7.0),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    3,
                    (index) {
                      return SizedBox(
                        width: SizeConfig.screenWidth! -
                            SizeConfig.screenWidth! * 0.087,
                        child: Card(
                          color: Colors.white,
                          margin: const EdgeInsets.all(5.0),
                          elevation: 2,
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
                                    Text("Jhon Doe"),
                                    const CircleAvatar(
                                      radius: 12.0,
                                      backgroundColor: Colors.green,
                                      child: Icon(
                                        Icons.check,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                Text("NEw yourk, UAS"),
                                const SizedBox(height: 5.0),
                                Expanded(
                                  child: Text("MacDolans Disney Landia"),
                                ),
                                Row(
                                  children: [
                                    const Spacer(),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
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
                                          onTap: () {

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
            SizedBox(
              width: SizeConfig.screenWidth! - SizeConfig.screenWidth! * 0.55,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Material(
                  color: kBackGroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () async {},
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: const [
                          SizedBox(
                            width: 25.0,
                            height: 25.0,
                            child: Icon(
                              CupertinoIcons.plus,
                              size: 18,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Text("Añadir dirección")
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: kBackGroundColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: kBackGroundColor,
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: CircleAvatar(
              backgroundColor: Colors.black12,
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 20.0,
              ),
            ),
          ),
        ),
        centerTitle: false,
        title: Text(
          "Orden",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        leadingWidth: 50.0,
      ),
      backgroundColor: kBackGroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight! -
                          SizeConfig.screenHeight! * 0.29,
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: pages.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index) {
                          return pages[index % pages.length];
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: SmoothPageIndicator(
                        controller: pageController,
                        count: pages.length,
                        onDotClicked: (index) async {
                          print("index: $index");
                          await pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn,
                          );
                        },
                        effect: CustomizableEffect(
                          activeDotDecoration: DotDecoration(
                            width: 32.0,
                            height: 12.0,
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          dotDecoration: DotDecoration(
                            width: 24.0,
                            height: 12.0,
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(16.0),
                            verticalOffset: 0,
                          ),
                          spacing: 20.0,
                          inActiveColorOverride: (i) => colors[i],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              width: SizeConfig.screenWidth!,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    hasTe = !hasTe;
                  });
                },
                child: Container(
                  color: kPrimaryColor,
                  child: Column(
                    children: [
                      AnimatedCrossFade(
                        firstChild: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 15.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "S/ 3.499.99",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        secondChild: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 1),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 15.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "S/ 3.499.99",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 15.0,
                              ),
                              child: Column(
                                children: [
                                  RowDetailPriceInfo(
                                    title: "Subtotal",
                                    price: 3499.99,
                                    fontSize: 12,
                                    verticalPadding: 5.0,
                                  ),
                                  _divider(),
                                  RowDetailPriceInfo(
                                    title: "Envío",
                                    price: 43.00,
                                    fontSize: 12,
                                    verticalPadding: 5.0,
                                  ),
                                  _divider(),
                                  RowDetailPriceInfo(
                                    title: "Total",
                                    price: 3542.00,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    verticalPadding: 5.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        crossFadeState: hasTe
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: kThemeAnimationDuration,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: SizeConfig.screenHeight! - SizeConfig.screenHeight! * 0.923,
        decoration: const BoxDecoration(
          color: kPrimaryColor,
          border: Border(
            top: BorderSide(width: 1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: DefaultButton(
            text: 'Continuar',
            color: Colors.white,
            colorText: Colors.black,
            press: () => Future.value(
              pageController.animateToPage(
                pageController.page!.toInt() + 1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeIn,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _divider() {
    return const Divider(
      thickness: 1.5,
      color: kBackGroundColor,
    );
  }
}

// ValueListenableBuilder(
// valueListenable: mainBloc.informationCart,
// builder: (context, shoppingCart, child) {
// if (shoppingCart is Cart) {
// if (shoppingCart.products!.isNotEmpty) {
// return InfoCartDetail(
// cart: shoppingCart,
// );
// }
//
// return const SizedBox.shrink();
// }
//
// return const SizedBox.shrink();
// },
// ),

class RowDetailPriceInfo extends StatelessWidget {
  const RowDetailPriceInfo({
    Key? key,
    required this.title,
    required this.price,
    this.fontWeight = FontWeight.w400,
    required this.fontSize,
    required this.verticalPadding,
  }) : super(key: key);

  final String title;
  final double price;
  final FontWeight fontWeight;
  final double fontSize;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: verticalPadding),
      child: DefaultTextStyle(
        style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text("S/ $price"),
          ],
        ),
      ),
    );
  }
}
