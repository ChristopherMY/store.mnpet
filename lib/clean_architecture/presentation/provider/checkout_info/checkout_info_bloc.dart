import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/domain/model/cart.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/credentials_auth.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/credit_card_model.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/mercado_pago_card_token.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/mercado_pago_document_type.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/mercado_pago_payment_method_installments.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/user_information.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/hive_repository.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/payment_repository.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/util/global_snackbar.dart';

class CheckOutInfoBloc extends ChangeNotifier {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  int expirationMonth = 0;
  String expirationYear = "";

  HiveRepositoryInterface hiveRepositoryInterface;
  PaymentRepositoryInterface paymentRepositoryInterface;

  CheckOutInfoBloc({
    required this.hiveRepositoryInterface,
    required this.paymentRepositoryInterface,
  });

  final pageController = PageController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  dynamic documentType;

  dynamic cardToken; // MercadoPagoCardToken
  dynamic creditCardPayment; // MercadoPagoPayment
  dynamic installmentsDetail; // MercadoPagoPaymentMethodInstallments

  Future<dynamic> handlePayment({
    required Cart cartInformation,
    required UserInformation userInformation,
    required BuildContext context,
  }) async {
    if (formKey.currentState!.validate()) {
      if (expiryDate.isEmpty) {
        if (kDebugMode) {
          print("expiryDate IS VOID");
        }

        GlobalSnackBar.showWarningSnackBar(context, "Fecha de expiración vacía");
        return;
      }

      List<String> list = expiryDate.split('/');

      if (list.length != 2) {
        if (kDebugMode) {
          print("COMPLETAR CAMPO FECHA");
        }

        GlobalSnackBar.showWarningSnackBar(
            context, "Ups. Tuvimos un problema, vuelva a intentarlo más tarde");
        return;
      }

      expirationMonth = int.parse(list[0]);
      expirationYear = "20${list[1]}";

      final tokenDetail = await getToken(
        identificationNumber: userInformation.document!.value!,
        userInformation: userInformation,
      );

      // print("TOKEN DETAIL");
      // print(tokenDetail);

      if (tokenDetail is! MercadoPagoCardToken) {
        if (kDebugMode) {
          print("tokenDetail NO PERTENECE A MercadoPagoCardToken");
        }

        GlobalSnackBar.showWarningSnackBar(
            context, "Ups. Tuvimos un problema, vuelva a intentarlo más tarde");
        return;
      }

      await Future.microtask(() async {
        await getInstallments(
          cardToken: cardToken,
          amount: double.parse(cartInformation.total!),
        );
      });

      if (installmentsDetail is! MercadoPagoPaymentMethodInstallments) {
        if (kDebugMode) {
          print(
              "installmentsDetail NO PERTAIN A MercadoPagoPaymentMethodInstallments");
        }

        GlobalSnackBar.showWarningSnackBar(
            context, "Ups. Tuvimos un problema, vuelva a intentarlo más tarde");
        return;
      }

      if (userInformation.addresses!.isEmpty) {
        if (kDebugMode) {
          print("userInformation.addresses! ES AVOID, Length is 0");
        }

        GlobalSnackBar.showWarningSnackBar(
            context, "Registre su dirección de envío para continuar");
        return;
      }

      final existsDefaultAddress = userInformation.addresses!.firstWhereOrNull(
        (element) => element.addressDefault == true,
      );

      if (existsDefaultAddress == null) {
        if (kDebugMode) {
          print("existsDefaultAddress ES NULL, Address no exists");
        }

        GlobalSnackBar.showWarningSnackBar(
            context, "Seleccione una dirección de envío por defecto");
        return;
      }

      Map<String, String> headers = {
        "Content-type": "application/json",
        "Custom-Origin": "app",
      };

      final responseCredentials = await Future.microtask(
        () async {
          return CredentialsAuth.fromMap(
            await hiveRepositoryInterface.read(
                  containerName: "authentication",
                  key: "credentials",
                ) ??
                {
                  "email": "",
                  "email_confirmed": false,
                  "token": "",
                },
          );
        },
      );

      if (responseCredentials.token.isEmpty) {
        if (kDebugMode) {
          print("responseCredentials IS EMPTY");
        }

        GlobalSnackBar.showWarningSnackBar(
            context, "Ups. Tuvimos un problema, vuelva a intentarlo más tarde");

        return;
      }

      headers[HttpHeaders.authorizationHeader] =
          "Bearer ${responseCredentials.token}";

      return await paymentRepositoryInterface.createPayment(
        additionalInfoMessage: "N/A",
        companyName: "N/A",
        cardToken: cardToken.id,
        installments: installmentsDetail.payerCosts!.first.installments!,
        paymentMethodId: installmentsDetail.paymentMethodId!,
        issuerId: installmentsDetail.issuer!.id!,
        headers: headers,
      );
    } else {
      /// TODO: No important;
      print('invalid!');
    }
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    cardNumber = creditCardModel!.cardNumber;
    expiryDate = creditCardModel.expiryDate;
    cardHolderName = creditCardModel.cardHolderName;
    cvvCode = creditCardModel.cvvCode;
    isCvvFocused = creditCardModel.isCvvFocused;

    notifyListeners();
  }

  void getIdentificationTypes() async {
    final response = await paymentRepositoryInterface.getIdentificationTypes();
    if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      return;
    }

    if (response is! http.Response) {
      if (kDebugMode) {
        print("response NO PERTENECE A http.Response");
      }

      return;
    }

    if (response.statusCode != 200) {
      if (kDebugMode) {
        print("response.statusCode  NO TIENE CODIGO 200");
      }

      return;
    }

    final identificationTypes = json.decode(response.body) as List;
    if (identificationTypes.isEmpty) {
      if (kDebugMode) {
        print("identificationTypes IS EMPTY");
      }

      return;
    }

    final result = MercadoPagoDocumentType.fromJsonList(identificationTypes);
    documentType = result.documentTypeList.first;

    print(result.documentTypeList.first.toJson());
  }

  Future<dynamic> getToken({
    required String identificationNumber,
    required UserInformation userInformation,
  }) async {
    if (documentType is! MercadoPagoDocumentType) {
      if (kDebugMode) {
        print("documentType NO PERTENECE A MercadoPagoDocumentType");
      }

      return;
    }

    final response = await paymentRepositoryInterface.createCardToken(
      cvv: cvvCode,
      expirationYear: expirationYear,
      expirationMonth: expirationMonth,
      cardNumber: cardNumber.replaceAll(' ', '').trim(),
      identificationNumber: identificationNumber,
      identificationId: documentType.id,
      cardHolderName: "${userInformation.name!.trim()} ${userInformation.lastname!.trim()}",
    );

    if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      return;
    }

    if (response is! http.Response) {
      if (kDebugMode) {
        print("response NO PERTENECE A  http.Response");
      }

      return;
    }

    if (response.statusCode != 201) {
      if (kDebugMode) {
        print("response.statusCode IS NOT 201");
      }

      return;
    }

    final decode = json.decode(response.body);
    return cardToken = MercadoPagoCardToken.fromJsonMap(decode);
  }

  Future<void> getInstallments({
    required MercadoPagoCardToken cardToken,
    required double amount,
  }) async {
    final response = await paymentRepositoryInterface.getInstallments(
      bin: cardToken.firstSixDigits!,
      amount: amount,
    );

    if (response is! http.Response) {
      if (kDebugMode) {
        print("Problema en la respuesta");
      }

      return;
    }

    if (response.statusCode != 200) {
      if (kDebugMode) {
        print("response.statusCode IS NOT 200");
      }

      return;
    }

    final decode = json.decode(response.body);

    final result = MercadoPagoPaymentMethodInstallments.fromJsonList(decode);
    installmentsDetail = result.installmentList!.first;
  }

  String badRequestProcess(dynamic data) {
    Map<String, String> paymentErrorCodeMap = {
      '3034': 'Informacion de la tarjeta invalida',
      '3032': 'Tamaño de código de seguridad invalido',
      '205': 'Ingresa el número de tu tarjeta',
      '208': 'Digita un mes de expiración',
      '209': 'Digita un año de expiración',
      '212': 'Ingresa tu documento',
      '213': 'Ingresa tu documento',
      '214': 'Ingresa tu documento',
      '220': 'Ingresa tu banco emisor',
      '221': 'Ingresa el nombre y apellido',
      '224': 'Ingresa el código de seguridad',
      'E301': 'Hay algo mal en el número. Vuelve a ingresarlo.',
      'E302': 'Revisa el código de seguridad',
      '316': 'Ingresa un nombre válido',
      '322': 'Revisa tu documento',
      '323': 'Revisa tu documento',
      '324': 'Revisa tu documento',
      '325': 'Revisa la fecha',
      '326': 'Revisa la fecha',
    };
    print('CODIGO ERROR ${data['error']['cause'][0]['code']}');

    if (paymentErrorCodeMap
        .containsKey('${data['error']['cause'][0]['code']}')) {
      return paymentErrorCodeMap['${data['error']['cause'][0]['code']}']!;
    }

    return 'No pudimos procesar tu pago';

    // final snackBar =  SnackBar(
    //   content:  Text(errorMessage!),
    //   action:  SnackBarAction(
    //     label: 'OK',
    //     onPressed: () {},
    //   ),
    // );
    //
    // ScaffoldMessenger.of(context).removeCurrentSnackBar();
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String badTokenProcess({
    required String status,
    required MercadoPagoPaymentMethodInstallments installments,
  }) {
    Map<String, String> badTokenErrorCodeMap = {
      '106': 'No puedes realizar pagos a usuarios de otros paises.',
      //'109':'${installments.paymentMethodId} no procesa pagos en $installmentsNumber cuotas',
      '126': 'No pudimos procesar tu pago.',
      '129':
          '${installments.paymentMethodId} no procesa pagos del monto seleccionado.',
      '145': 'No pudimos procesar tu pago',
      '150': 'No puedes realizar pagos',
      '151': 'No puedes realizar pagos',
      '160': 'No pudimos procesar tu pago',
      '204':
          '${installments.paymentMethodId} no está disponible en este momento.',
      '801':
          'Realizaste un pago similar hace instantes. Intenta nuevamente en unos minutos',
    };

    if (badTokenErrorCodeMap.containsKey(status.toString())) {
      return badTokenErrorCodeMap[status]!;
    }

    return 'No pudimos procesar tu pago';

    // final snackBar = new SnackBar(
    //   content: new Text(errorMessage),
    //   action: new SnackBarAction(
    //     label: 'Ok',
    //     onPressed: () {},
    //   ),
    // );

    // ScaffoldMessenger.of(context).removeCurrentSnackBar();
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
