import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/privacy/privacy_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PrivacyBloc(),
      builder: (_, __) => const PrivacyScreen._(),
    );
  }

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  Widget build(BuildContext context) {
    final privacyBloc = context.watch<PrivacyBloc>();

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: WebView(
                initialUrl:
                    "https://www.mundonegocio.com.pe/politicas-de-privacidad/",
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: privacyBloc.onPageFinished,
              ),
            ),
            if (privacyBloc.isLoading)
              Positioned(
                top: 0,
                width: SizeConfig.screenWidth!,
                child: const LinearProgressIndicator(
                  color: kPrimaryColor,
                  backgroundColor: Colors.black12,
                ),
              ),
            // isLoading ? Center( child: CircularProgressIndicator(),)
            //     : Stack(),
          ],
        ),
      ),
    );
  }
}
