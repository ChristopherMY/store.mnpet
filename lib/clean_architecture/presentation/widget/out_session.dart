import 'package:flutter/cupertino.dart';

class OutSession extends StatelessWidget {
  const OutSession({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/no_logging.png",
              height: 175.0,
            ),
            const SizedBox(height: 10.0),
            const Text(
              "Para visualizar su información necesita iniciar sesión con su cuenta.",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
