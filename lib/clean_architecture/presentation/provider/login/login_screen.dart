import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/authentication.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/sign_in/sign_in_screen.dart';
import 'package:store_mundo_negocio/main.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignInAccount? _currentUser;
  String _contactText = '';

  @override
  void initState() {
    super.initState();

  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });

    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );

    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });

      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }

    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;

    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }

    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => googleSignIn.disconnect();

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      print(user);
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          Text(_contactText),
          ElevatedButton(
            onPressed: _handleSignOut,
            child: const Text('SIGN OUT'),
          ),
          ElevatedButton(
            child: const Text('REFRESH'),
            onPressed: () => _handleGetContact(user),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          ElevatedButton(
            onPressed: () async {
              final user = await Authentication.signInWithGoogle(context: context);
              Logger logger= Logger();
              logger.i(user);
            },
            child: const Text('SIGN IN'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: kBackGroundColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: kBackGroundColor,
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: CircleAvatar(
              backgroundColor: Colors.black12,
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 20.0,
              ),
            ),
          ),
        ),
        leadingWidth: 50.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 55.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 35.0),
              Image.asset(
                "assets/images/logo-mn.png",
                height: getProportionateScreenHeight(120.0),
              ),
              const SizedBox(height: 20),
              _ButtonLogin(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => SignInScreen.init(context),
                    ),
                  );
                },
                isIcon: false,
                iconSize: 25,
                icon: CupertinoIcons.mail,
                assetPath: "assets/icons/Mail.svg",
                title: "Iniciar sesion con gmail",
                color: Colors.black87,
              ),
              const SizedBox(height: 20),
              _ButtonLogin(
                onTap: () async {},
                iconSize: 30,
                isIcon: false,
                icon: CupertinoIcons.mail,
                assetPath: "assets/icons/google-icon.svg",
                title: "Iniciar sesion con gmail",
              ),
              const SizedBox(height: 20),
              _ButtonLogin(
                onTap: () {
                  ///
                },
                iconSize: 30,
                isIcon: false,
                icon: CupertinoIcons.mail,
                assetPath: "assets/icons/facebook-2.svg",
                title: "Iniciar sesion con facebook",
              ),
              _buildBody()
            ],
          ),
        ),
      ),
    );
  }
}

class _ButtonLogin extends StatelessWidget {
  const _ButtonLogin({
    Key? key,
    required this.onTap,
    required this.isIcon,
    this.icon,
    this.assetPath,
    required this.title,
    required this.iconSize,
    this.color = null,
  }) : super(key: key);

  final VoidCallback onTap;
  final bool isIcon;
  final IconData? icon;
  final String? assetPath;
  final String title;
  final double iconSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: const MaterialStatePropertyAll<Color>(kPrimaryColor),
        // elevation: MaterialStatePropertyAll<double>(4)
        // splashFactory:  InkSparkle.splashFactory
        shadowColor: const MaterialStatePropertyAll<Color>(Colors.black38),
        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 25.0)),
        fixedSize:
            const MaterialStatePropertyAll<Size>(Size(double.infinity, 50)),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: getProportionateScreenWidth(30),
            child: !isIcon
                ? SvgPicture.asset(
                    assetPath!,
                    height: iconSize,
                    color: color,
                  )
                : Icon(
                    size: iconSize,
                    icon,
                    color: color,
                  ),
          ),
          const SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
