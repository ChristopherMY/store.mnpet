import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class General {
 static whatsappMessage({
    required BuildContext context,
    required String description,
  }) async {
    var whatsapp = "+51963513857";

    var message =
        "Hola Daniela estoy interesado en $description me brindas información por favor";

    var whatsappUrlAndroid =
        "whatsapp://send?phone=$whatsapp&text=$message";

    var whatsappUrlIos = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatsappUrlIos)) {
        await launch(whatsappUrlIos, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Whatsapp no se encuentra instalado")));
      }
    } else {
      // android, web
      if (await canLaunch(whatsappUrlAndroid)) {
        await launch(whatsappUrlAndroid);
      } else {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Whatsapp no se encuentra instalado")));
      }
    }
  }
}
