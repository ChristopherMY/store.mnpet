import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';

class GlobalSnackBar {
  static showWarningSnackBar(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0.0,
        //behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                message,
                textAlign: TextAlign.justify,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        backgroundColor: kPrimaryBackgroundColor,
        action: SnackBarAction(
          //textColor: const Color(0xFFFAF2FB),
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  static showInfoSnackBarIcon(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0.0,
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
        content: Row(
          children: [
            const SizedBox(width: 15),
            const Icon(
              CupertinoIcons.check_mark,
              size: 16.0,
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                message,
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.apply(color: Colors.black),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ) ,
        backgroundColor: Colors.white,
        action: SnackBarAction(
          //textColor: const Color(0xFFFAF2FB),
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  static showErrorSnackBarIcon(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0.0,
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
        content: Row(
          children: [
            const SizedBox(width: 15),
            const Icon(
              Icons.error_outline,
              size: 16.0,
              color: Colors.red,
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                message,
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.apply(color: Colors.black),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          //textColor: const Color(0xFFFAF2FB),
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  static showNormalSnackBar(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0.0,
        //behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: const Duration(seconds: 5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ) ,
        action: SnackBarAction(
          //textColor: const Color(0xFFFAF2FB),
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }
}
