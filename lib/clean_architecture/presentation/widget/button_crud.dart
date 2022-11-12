import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';

class ButtonCrud extends StatelessWidget {
  const ButtonCrud({
    Key? key,
    required this.onTap,
    required this.titleButton,
  }) : super(key: key);

  final VoidCallback onTap;
  final String titleButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth! - SizeConfig.screenWidth! * 0.59,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          elevation: 1,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 9.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(
                    CupertinoIcons.plus,
                    size: 18.0,
                  ),
                  Text(titleButton)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
