import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';

class CustomSuffixIcon extends StatelessWidget {
  const CustomSuffixIcon({
    Key? key,
    required this.svgIcon,
  }) : super(key: key);

  final String svgIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        getProportionateScreenHeight(10.0),
        getProportionateScreenHeight(10.0),
        getProportionateScreenWidth(10.0),
        getProportionateScreenWidth(5.0),
      ),
      child: SvgPicture.asset(
        svgIcon,
        color: kBlackColor,
        height: getProportionateScreenHeight(15.0),
      ),
    );
  }
}
