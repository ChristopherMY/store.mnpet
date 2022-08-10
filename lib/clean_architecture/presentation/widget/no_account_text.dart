import 'package:flutter/cupertino.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "¿No tienes una cuenta? ",
          style: TextStyle(fontSize: getProportionateScreenHeight(16.0)),
        ),
        GestureDetector(
          //onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
          child: Text(
            "Registrate",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(16.0),
              color: kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
