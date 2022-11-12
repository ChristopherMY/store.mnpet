import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/contact/contact_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContactBloc(),
      builder: (_, __) => const ContactScreen._(),
    );
  }

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    final contactBloc = context.watch<ContactBloc>();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: WebView(
                initialUrl:
                    "https://www.mundonegocio.com.pe/politicas-de-devolucion/",
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: contactBloc.onPageFinished,
              ),
            ),
            if (contactBloc.isLoading)
              Positioned(
                top: 0,
                width: SizeConfig.screenWidth!,
                child: const LinearProgressIndicator(
                  color: kPrimaryColor,
                  backgroundColor: Colors.black12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
