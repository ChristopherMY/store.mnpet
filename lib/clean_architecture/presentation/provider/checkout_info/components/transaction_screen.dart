import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/mercado_pago_payment.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';
import 'package:store_mundo_pet/clean_architecture/helper/size_config.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/ticket.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({
    Key? key,
    required this.mercadoPagoPayment,
  }) : super(key: key);

  final MercadoPagoPayment mercadoPagoPayment;

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late ConfettiController _controllerCenter;

  void handleControlConfetti() async {
    Future.delayed(
      const Duration(seconds: 6),
      () {
        _controllerCenter.stop();
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _controllerCenter = ConfettiController()..play();

    handleControlConfetti();
    super.initState();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mercadoPagoPayment = widget.mercadoPagoPayment;

    return Scaffold(
      backgroundColor: kBackGroundColor,
      // appBar: AppBar(
      //   systemOverlayStyle: const SystemUiOverlayStyle(
      //     statusBarColor: kBackGroundColor,
      //     statusBarIconBrightness: Brightness.dark,
      //   ),
      //   toolbarOpacity: 0,
      //   toolbarHeight:  0,
      //   leadingWidth: 0,
      //   titleSpacing: 0,
      // ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/mundo-pet.png",
                      width: getProportionateScreenWidth(220.0),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(30.0),
                    ),
                    Ticket(
                      width: SizeConfig.screenWidth! * 0.8,
                      height: SizeConfig.screenHeight! * 0.64,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 24.0,
                      ),
                      child: TicketData(mercadoPagoPayment: mercadoPagoPayment),
                      // ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(15.0),
                    ),
                    _ButtonIconTicket(
                      onTap: () {
                        // Navigator.of(context).popUntil((route) => false);
                        Navigator.of(context).pop();
                      },
                      icon: Icons.home_outlined,
                      title: "Ir a inicio",
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _controllerCenter,
                  blastDirectionality: BlastDirectionality.explosive,
                  // don't specify a direction, blast randomly
                  shouldLoop: true,
                  // start again as soon as the animation is finished
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ],
                  // manually specify the colors to be used
                  createParticlePath: drawStar, // define a custom shape/path.
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: TextButton(
              //       onPressed: () {
              //         _controllerCenter.play();
              //       },
              //       child: _display('blast\nstars')),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Text _display(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 20),
    );
  }
}

class TicketData extends StatelessWidget {
  const TicketData({
    Key? key,
    required this.mercadoPagoPayment,
  }) : super(key: key);

  final MercadoPagoPayment mercadoPagoPayment;

  String handleParseDatetime(DateTime date) {
    final datetime = DateTime.parse(date.toIso8601String());
    final resolve = "${datetime.day}/${datetime.month}/${datetime.year}";
    return resolve;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120.0,
              height: 25.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(width: 1.0, color: Colors.green),
              ),
              child: const Center(
                child: Text(
                  'Pagado',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
            // Row(
            //   children: const [
            //     Text(
            //       'Procesando',
            //       style: TextStyle(
            //           color: Colors.black, fontWeight: FontWeight.bold),
            //     ),
            //     Padding(
            //       padding: EdgeInsets.only(left: 8.0),
            //       child: Icon(
            //         Icons.local_shipping,
            //         color: kPrimaryColorRed,
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'Comprobante de pago',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                child: ticketDetailsWidget(
                  '# Orden',
                  mercadoPagoPayment.collectorId!,
                  'Fecha',
                  handleParseDatetime(mercadoPagoPayment.dateApproved!),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 12.0, right: 12.0, left: 12.0),
                child: ticketDetailsWidget(
                  'Total ',
                  'S/ ${mercadoPagoPayment.transactionAmount!}',
                  'Correo electrónico',
                  '${mercadoPagoPayment.payer!.email}',
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 12.0, right: 12.0, left: 12.0),
                child: ticketDetailsWidget(
                  'Documento',
                  mercadoPagoPayment.payer!.identificationType!,
                  'N° documento',
                  mercadoPagoPayment.payer!.identificationNumber!,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, right: 12.0, left: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Descripción",
                style: const TextStyle(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  mercadoPagoPayment.description!,
                  style: const TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ),
        const Spacer(),
        Image.asset(
          "assets/mercadopago.png",
          alignment: Alignment.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_sharp),
            Text(
              'Compra verificada por mercado pago',
            ),
          ],
        )
      ],
    );
  }
}

Widget ticketDetailsWidget(
  String firstTitle,
  String firstDesc,
  String secondTitle,
  String secondDesc,
) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      )
    ],
  );
}

class _ButtonIconTicket extends StatelessWidget {
  const _ButtonIconTicket({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final VoidCallback onTap;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(10.0),
          color: kPrimaryColor,
          elevation: 2,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 29.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5.0),
        Text(title)
      ],
    );
  }
}
