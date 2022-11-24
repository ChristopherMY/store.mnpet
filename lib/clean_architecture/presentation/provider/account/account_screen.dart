import 'package:community_material_icon/community_material_icon.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/usecase/page.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/contact/contact_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/order/order_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/privacy/privacy_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/settings/settings_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/sign_up/sign_up_screen.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/copy_right.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/widget/lottie_animation.dart';

import '../shipment/shipment_screen.dart';
import 'account_bloc.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AccountBloc(
        userRepositoryInterface: context.read<UserRepositoryInterface>(),
        hiveRepositoryInterface: context.read<HiveRepositoryInterface>(),
      ),
      builder: (_, __) => const AccountScreen._(),
    );
  }

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _init();
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.watch<MainBloc>();

    return ValueListenableBuilder(
      valueListenable: mainBloc.account,
      builder: (context, Account account, child) {
        return RefreshIndicator(
          notificationPredicate: (_) => account == Account.active,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async {
            if (mainBloc.informationUser is UserInformation) {
              mainBloc.handleLoadUserInformation(context);
            }
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      snap: false,
                      floating: false,
                      toolbarHeight: 56.0,
                      backgroundColor: kBackGroundColor,
                      systemOverlayStyle: const SystemUiOverlayStyle(
                        statusBarColor: kBackGroundColor,
                        statusBarIconBrightness: Brightness.dark,
                      ),
                      expandedHeight: getProportionateScreenHeight(56.0),
                      actions: [
                        if (account == Account.active)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SettingsScreen.init(context),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.settings,
                                color: Colors.black,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: HeaderInformation(
                        accountActive: account == Account.active,
                      ),
                    ),
                    SliverVisibility(
                      visible: account == Account.active,
                      sliver: const SliverPadding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 25.0,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            "Mi perfil",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverVisibility(
                      visible: account == Account.active,
                      sliver: SliverToBoxAdapter(
                        child: TargetOption(
                          title: "Mis Direcciones",
                          subTitle: "Mis direcciones de envío",
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ShipmentScreen(),
                              ),
                            );
                          },
                          icon: Icons.directions,
                        ),
                      ),
                    ),
                    SliverVisibility(
                      visible: account == Account.active,
                      sliver: SliverToBoxAdapter(
                        child: TargetOption(
                          title: "Mis órdenes",
                          subTitle: 'Detalle de órdenes',
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return OrderScreen.init(context);
                                },
                              ),
                            );
                          },
                          icon: Icons.local_shipping_outlined,
                        ),
                      ),
                    ),
                    // SliverVisibility(
                    //   visible: value,
                    //   sliver: SliverToBoxAdapter(
                    //     child: TargetOption(
                    //       title: "Mis Tarjetas",
                    //       subTitle: 'Detalle de tarjetas guardadas',
                    //       onTap: () {
                    //         Navigator.of(context).push(
                    //           MaterialPageRoute(
                    //             builder: (context) => const CreditCartScreen(),
                    //           ),
                    //         );
                    //       },
                    //       icon: Icons.credit_score,
                    //       // Icons.credit_card
                    //     ),
                    //   ),
                    // ),
                    const SliverPadding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 25.0,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          "Ayuda",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: TargetOption(
                        title: "Cambios y devoluciones",
                        subTitle: 'Políticas de cambios y devoluciones',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return ContactScreen.init(context);
                              },
                            ),
                          );
                        },
                        icon: Icons.store_mall_directory_outlined,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: TargetOption(
                        title: "Privacidad",
                        subTitle: 'Terminos y condiciones',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return PrivacyScreen.init(context);
                              },
                            ),
                          );
                        },
                        icon: Icons.question_mark_rounded,
                      ),
                    ),
                    SliverVisibility(
                      visible: account == Account.active,
                      sliver: SliverToBoxAdapter(
                        child: TargetOption(
                          title: "Cerrar sesión",
                          subTitle: "Cerrar sesión en este dispositivo",
                          onTap: mainBloc.signOut,
                          icon: CommunityMaterialIcons.logout,
                        ),
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      fillOverscroll: true,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: getProportionateScreenHeight(25.0),
                          top: getProportionateScreenHeight(25.0),
                        ),
                        child: const CopyRight(),
                      ),
                    ),
                  ],
                ),
              ),
              if (mainBloc.loadingScreenAccount)
                const Positioned.fill(
                  child: Material(
                    color: Colors.black12,
                    child: Center(
                      child: LottieAnimation(
                        source: "assets/lottie/shopping-bag.json",
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _addressesTitle({required int sizeAddresses}) {
    if (sizeAddresses == 1) {
      return "Tienes una dirección registrada";
    }

    if (sizeAddresses > 1) {
      return "Tienes $sizeAddresses registradas";
    }

    return "No tienes direcciones registradas";
  }
}

class HeaderInformation extends StatelessWidget {
  const HeaderInformation({
    Key? key,
    required this.accountActive,
  }) : super(key: key);

  final bool accountActive;

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.watch<MainBloc>();

    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 15.0,
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 70.0,
                  height: 70.0,
                  child: accountActive
                      ? ExtendedImage.network(
                          mainBloc.informationUser.image!.src!,
                          fit: BoxFit.cover,
                          cache: true,
                          timeLimit: const Duration(seconds: 30),
                          enableMemoryCache: true,
                          enableLoadState: false,
                        )
                      // CachedNetworkImage(
                      //         imageUrl:
                      //             mainBloc.informationUser.image!.src.toString(),
                      //         imageBuilder: (context, imageProvider) => Container(
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(35.0),
                      //             image: DecorationImage(
                      //               image: imageProvider,
                      //               fit: BoxFit.cover,
                      //             ),
                      //           ),
                      //         ),
                      //         placeholder: (context, url) => Container(
                      //           decoration: BoxDecoration(
                      //             shape: BoxShape.rectangle,
                      //             borderRadius: BorderRadius.circular(35.0),
                      //           ),
                      //         ),
                      //         errorWidget: (context, url, error) => const Icon(
                      //           // FontAwesomeIcons.circleUser,0
                      //           CupertinoIcons.person_circle,
                      //           // Icons.account_circle_outlined,
                      //           size: 70.0,
                      //           color: kPrimaryColor,
                      //         ),
                      //       )
                      : const Icon(
                          CupertinoIcons.person_circle,
                          size: 70.0,
                          color: kPrimaryColor,
                        ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: accountActive
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${mainBloc.informationUser.name} ${mainBloc.informationUser.lastname}",
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            // const SizedBox(height: 5.0),
                            // Text(
                            //   "# Codigo de referido",
                            //   style: Theme.of(context).textTheme.bodyText2,
                            // ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'No tenemos registro de su cuenta',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              'Accedar para visualizar su información',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                ),
              ],
            ),
            accountActive
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      const SizedBox(height: 17.0),
                      Row(
                        children: [
                          Expanded(
                            child: _GeneralButton(
                              text: "Crear cuenta",
                              onPressed: () {
                                mainBloc.countNavigateIterationScreen = 1;

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SignUpScreen.init(context),
                                  ),
                                );
                              },
                              backgroundColor: Colors.white,
                              primary: kPrimaryColor,
                              fontColor: Colors.black,
                            ),
                            // TextButton(
                            // color: Colors.white,
                            // splashColor: kPrimaryColor,
                            // textColor:
                            //     value ? Colors.white : kPrimaryColor,
                            // shape: RoundedRectangleBorder(
                            //   side: const BorderSide(
                            //       color: kPrimaryColor, width: 1),
                            //   borderRadius: BorderRadius.circular(15.0),
                            // ),
                            // height: 45.0,
                            // onHighlightChanged:
                            //     accountBloc.onHighlightChanged,
                            // onPressed: () {
                            //   Navigator.of(context).push(
                            //     MaterialPageRoute(
                            //       builder: (context) =>
                            //           SignUpScreen.init(context),
                            //     ),
                            //   );
                            // },
                            // child: const Text(
                            //   "Crear cuenta",
                            //   textAlign: TextAlign.center,
                            // ),
                            // ),
                          ),
                          const SizedBox(width: 30.0),
                          Expanded(
                            child: _GeneralButton(
                              text: "Iniciar Sesión",
                              onPressed: () {
                                final mainBloc = context.read<MainBloc>();
                                mainBloc.handleAuthAccess(context);
                              },
                              backgroundColor: kPrimaryColor,
                              primary: Colors.white,
                              fontColor: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class _GeneralButton extends StatelessWidget {
  const _GeneralButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.primary,
    required this.fontColor,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color primary;
  final Color fontColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: primary,
        elevation: 1,
        minimumSize: const Size.fromHeight(45.0),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: fontColor,
        ),
      ),
    );
  }
}

class TargetOption extends StatelessWidget {
  const TargetOption({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30.0,
              ),
              const SizedBox(width: 13.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 7.0),
                    Text(subTitle,
                        style: Theme.of(context).textTheme.bodyText2),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: const Icon(Icons.arrow_forward_ios, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
