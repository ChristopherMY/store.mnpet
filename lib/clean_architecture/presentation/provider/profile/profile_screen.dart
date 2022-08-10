import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/profile/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen._({Key? key}) : super(key: key);

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileBloc(
        userRepositoryInterface: context.read<UserRepositoryInterface>(),
        hiveRepositoryInterface: context.read<HiveRepositoryInterface>(),
      ),
      builder: (_, __) => const ProfileScreen._(),
    );
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _init() async {
    // final mainBloc = context.read<MainBloc>();
    // final isLogged = await mainBloc.loadSession();
    // if (isLogged) {
    // } else {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(builder: ((context) => const LoginScreen())),
    //   );
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _init();
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.watch<MainBloc>();
    final profileBloc = context.watch<ProfileBloc>();

    return SafeArea(
      child: SizedBox(
        // height: SizeConfig.screenHeight! * 0.9,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
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
                            child: mainBloc.informationUser is UserInformation
                                ? CachedNetworkImage(
                                    imageUrl: mainBloc
                                        .informationUser.image!.src
                                        .toString(),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(35.0),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(35.0),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      // FontAwesomeIcons.circleUser,0
                                      CupertinoIcons.person_circle,
                                      // Icons.account_circle_outlined,
                                      size: 70.0,
                                      color: kPrimaryColor,
                                    ),
                                  )
                                : const Icon(
                                    CupertinoIcons.person_circle,
                                    size: 70.0,
                                    color: kPrimaryColor,
                                  ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: mainBloc.informationUser is UserInformation
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${mainBloc.informationUser.name} ${mainBloc.informationUser.lastname}",
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        "# Codigo de referido",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                      mainBloc.informationUser is UserInformation
                          ? const SizedBox.shrink()
                          : Column(
                              children: [
                                const SizedBox(height: 17.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ValueListenableBuilder(
                                        valueListenable: profileBloc.pressed,
                                        builder: (context, bool value, child) {
                                          print(bool);
                                          return FlatButton(
                                            color: Colors.white,
                                            splashColor: kPrimaryColor,
                                            textColor: value
                                                ? Colors.white
                                                : kPrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: kPrimaryColor,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            height: 45.0,
                                            onHighlightChanged:
                                                profileBloc.onHighlightChanged,
                                            onPressed: () {
                                              print("Presiono");
                                            },
                                            child: const Text(
                                              "Crear cuenta",
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 30.0),
                                    Expanded(
                                      child: FlatButton(
                                        color: kPrimaryColor,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: kPrimaryColor, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        height: 45.0,
                                        onPressed: () {
                                          mainBloc.requestAccess(context);
                                        },
                                        child: const Text(
                                          "Iniciar sesión",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
                child: Text(
                  "Mi perfil",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _buildTargetOptions(
                title: "Mis direcciones",
                subTitle: mainBloc.informationUser is UserInformation
                    ? _addressesTitle(
                        sizeAddresses:
                            mainBloc.informationUser.addresses!.length)
                    : "Acceda para visualizar sus direcciones",
                onTap: () {},
                icon: Icons.directions,
              ),
              _buildTargetOptions(
                title: "Mis ordenes",
                subTitle: 'Detalle de ordenes',
                onTap: () {},
                icon: Icons.local_shipping_outlined,
              ),
              _buildTargetOptions(
                title: "Privacidad",
                subTitle: 'Terminos y condiciones',
                onTap: () {},
                icon: Icons.question_mark_rounded,
              ),
              _buildTargetOptions(
                title: "Cerrar sesión",
                subTitle: "Cerrar sesión en este dispositivo",
                onTap: mainBloc.signOut,
                icon: CommunityMaterialIcons.logout,
              ),
              SizedBox(height: getProportionateScreenHeight(25.0)),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 45,
                      child: Image.asset(
                        "assets/images/mundo-pet.png",
                      ),
                    ),
                    const Text(
                      "Versión 4.15.1",
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    DefaultTextStyle(
                      style: const TextStyle(fontSize: 13, color: Colors.black),
                      child: Column(
                        children: const [
                          Text("© 2022 - 2022 mundopet.com.pe."),
                          Text("Todos los derechos reservados")
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5.0)
            ],
          ),
        ),
      ),
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

  _buildTargetOptions({
    required String title,
    required String subTitle,
    required VoidCallback onTap,
    required IconData icon,
  }) {
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
                    Text(subTitle),
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
