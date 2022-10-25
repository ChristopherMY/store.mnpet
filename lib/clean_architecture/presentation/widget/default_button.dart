import 'package:flutter/material.dart';

import '../../helper/constants.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.text,
    required this.press,
    this.color = kPrimaryColor,
    this.colorText = Colors.white,
  }) : super(key: key);
  final String text;
  final VoidCallback press;
  final Color color;
  final Color colorText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: TextButton(
        // shape:
        //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        // color: color,
        style: TextButton.styleFrom(
          primary: Colors.white,
          elevation: 1,
          minimumSize: const Size.fromHeight(50.0),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: press,
        child: Text(
          text,
          style:Theme.of(context).textTheme.bodyText2!.copyWith(color: colorText),
        ),
      ),
    );
  }
}
