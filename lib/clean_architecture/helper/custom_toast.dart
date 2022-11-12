import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/colors.dart';

class CustomToast {
  late FToast fToast;

  showToastIcon({
    required BuildContext context,
    String type = "error",
    required String message,
  }) {
    fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: type == "error"
            ? CustomColors.RedBackground
            : CustomColors.GreenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(type == "error" ? Icons.warning_amber_rounded : Icons.check),
          const SizedBox(width: 12.0),
          Flexible(child: Text(message)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 4),
    );
  }

  showToast({
    required BuildContext context,
    String type = "error",
    required String message,
  }) {
    fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: type == "error"
            ? CustomColors.RedBackground
            : CustomColors.GreenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 12.0),
          Flexible(child: Text(message)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 4),
    );
  }
}
