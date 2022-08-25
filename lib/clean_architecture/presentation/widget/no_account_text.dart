import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/sign_up/sign_up_screen.dart';

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
          style: Theme.of(context).textTheme.bodyText2,
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => SignUpScreen.init(context)),
          ),
          child: Text(
            "Registrate",
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
