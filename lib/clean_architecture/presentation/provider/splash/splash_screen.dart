import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void init(BuildContext context) async {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/presentation/presentation_2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: getProportionateScreenWidth(10),
            top: getProportionateScreenHeight(70),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white38,
                    spreadRadius: 3,
                  )
                ],
              ),
              child: const CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white,
                child: Text(
                  "1",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
