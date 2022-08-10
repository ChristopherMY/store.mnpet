import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/provider/sign_in/sign_in_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 25,
                  child: RawMaterialButton(
                    onPressed: (() => Navigator.of(context).pop()),
                    child: const Icon(
                      CupertinoIcons.clear,
                      color: Colors.black38,
                    ),
                  ),
                ),
                const SizedBox(height: 35.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        height: 100,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            alignment: FractionalOffset.topCenter,
                            image: AssetImage(
                              "assets/images/mundo-pet.png",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => SignInScreen.init(context),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(23, 195, 178, 1),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Icon(
                                size: 30,
                                CupertinoIcons.mail,
                                color: Colors.white,
                              ),
                              SizedBox(width: 15),
                              Text(
                                "Iniciar sesión con tu email",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
