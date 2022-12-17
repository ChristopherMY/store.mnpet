import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/category.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/product/product_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/search_detail/search_detail_screen.dart';

class DynamicLinksService {
  // static Future<String> createDynamicLink(String parameter) async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   print(packageInfo.packageName);
  //   String uriPrefix = "https://flutterdevs.page.link";
  //
  //   final DynamicLinkParameters parameters = DynamicLinkParameters(
  //     uriPrefix: uriPrefix,
  //     link: Uri.parse('https://example.com/$parameter'),
  //     androidParameters: AndroidParameters(
  //       packageName: packageInfo.packageName,
  //       minimumVersion: 125,
  //     ),
  //     iosParameters: IOSParameters(
  //       bundleId: packageInfo.packageName,
  //       minimumVersion: packageInfo.version,
  //       appStoreId: '123456789',
  //     ),
  //     googleAnalyticsParameters: GoogleAnalyticsParameters(
  //       campaign: 'example-promo',
  //       medium: 'social',
  //       source: 'orkut',
  //     ),
  //     itunesConnectAnalyticsParameters: ITunesConnectAnalyticsParameters(
  //       providerToken: '123456',
  //       campaignToken: 'example-promo',
  //     ),
  //     socialMetaTagParameters: SocialMetaTagParameters(
  //         title: 'Example of a Dynamic Link',
  //         description: 'This link works whether app is installed or not!',
  //         imageUrl: Uri.parse(
  //             "https://images.pexels.com/photos/3841338/pexels-photo-3841338.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260")),
  //   );
  //
  //   // final Uri dynamicUrl = await parameters.buildUrl();
  //   final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
  //   final Uri shortUrl = shortDynamicLink.shortUrl;
  //   return shortUrl.toString();
  // }

  static void initDynamicLinks(BuildContext context) async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDynamicLink(data, context);

    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData dynamicLinkData) {
      _handleDynamicLink(dynamicLinkData, context);
    }).onError((error) {
      if (kDebugMode) {
        print('onLinkError');
        print(error.message);
      }
    });
  }

  static _handleDynamicLink(
      PendingDynamicLinkData? data, BuildContext context) async {
    if (data == null) {
      return;
    }
    // print("data.utmParameters: ${data.utmParameters}");
    // data.utmParameters.forEach((key, value) {
    //   print("Query $key: $value");
    // });

    final Uri deepLink = data.link;

    // print('Deeplinks uri:${deepLink.path}');
    // print('Deeplinks:${deepLink}');
    // print('userInfo:${deepLink.userInfo}');
    // print('scheme:${deepLink.scheme}');
    // print('port:${deepLink.port}');
    // print('query:${deepLink.query}');
    // print('query name:${deepLink.query.split("=").first}');
    // print('query value:${deepLink.query.split("=").last}');

    final queryParametersAll = deepLink.queryParametersAll;
    // for (final item in queryParams) {
    //   print("Title: ${item.key}, Trailing: ${item.value.join(", ")}");
    // }

    if (queryParametersAll.containsKey("category")) {
      final slug = queryParametersAll["category"]!.first;

      if (slug.isNotEmpty) {
        await Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: SearchDetailScreen.init(
                  context: context,
                  typeFilter: TypeFilter.category,
                  categories: [MasterCategory(slug: slug, name: "Ofertas")],
                  search: "",
                  showBanner: false,
                  imageUrl: "",
                ),
              );
            },
          ),
        );
      }
    }

    if (queryParametersAll.containsKey("product")) {
      final slug = queryParametersAll["product"]!.first;

      if (slug.isNotEmpty) {
        await Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: ProductScreen.init(
                  context: context,
                  code: "code",
                  product: null,
                  slug: slug,
                  fullSource: true,
                ),
              );
            },
          ),
        );
      }
    }

    // print('origin:${deepLink.origin}');
    // print('host:${deepLink.host}');
    // print('fragment:${deepLink.fragment}');
    // print('authority:${deepLink.authority}');
    // print('length pathSegments:${deepLink.pathSegments.length}');

    // if (deepLink.pathSegments.contains('category')) {
    //   var title = deepLink.queryParameters['code'];
    //   if (title != null) {
    //     print("refercode=$title");
    //   }
    // }
  }
}
