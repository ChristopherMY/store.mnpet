import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/payment.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/payment_repository.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';

class PaymentService implements PaymentRepository {
  final String _urlMercadoPago = "api.mercadopago.com";
  final _mercadoPagoCredentials = Environment.mercadoPagoCredentials;
  final _url = Environment.API_DAO;

  // List<MercadoPagoDocumentType>

  @override
  Future<dynamic> createCardToken({
    required String cvv,
    required String expirationYear,
    required int expirationMonth,
    required String cardNumber,
    required String identificationNumber,
    required String identificationId,
    required String cardHolderName,
  }) async {
    try {
      final url = Uri.https(_urlMercadoPago, "/v1/card_tokens");

      final body = {
        "security_code": cvv,
        "expiration_year": expirationYear,
        "expiration_month": expirationMonth,
        "card_number": cardNumber,
        "cardholder": {
          'identification': {
            'number': identificationNumber,
            'type': identificationId
          },
          'name': cardHolderName
        }
      };
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Custom-Origin": "app",
        HttpHeaders.authorizationHeader:
            "Bearer ${_mercadoPagoCredentials.accessToken}"
      };

      return await http.post(url, body: json.encode(body), headers: headers);
    } catch (e) {
      return e.toString();
    }
  }

  // http.Response
  @override
  Future<dynamic> createPayment({
    required String userId,
    required String addressId,
    required double shippingCost,
    required double subTotal,
    required String additionalInfoMessage, // Optional
    required String companyName, // Optional
    required Identification identification,
    required String paymentTypeId,
    // required String emailCustomer,
    // required String identificationType,
    // required String identificationNumber,
    // required String firstNameCustomer,
    // required String lastNameCustomer,
    required double transactionAmount,
    required String cardToken,
    required int installments,
    required String paymentMethodId,
    required String issuerId,
  }) async {
    try {
      final url = Uri.parse('$_url/api/v1/paidmarket/process_payment');

      final body = Payment(
        transactionAmount: transactionAmount,
        installments: installments,
        paymentMethodId: paymentMethodId,
        token: cardToken,
        issuerId: issuerId,
        //paymentTypeId: paymentTypeId,
        userId: userId,
        addressId: addressId,
        shippingCost: shippingCost,
        subTotal: subTotal,
        identification: identification,
        additionalInfoMessage: additionalInfoMessage,
        // Optional
        companyName: companyName, // Optional
      );

      String bodyParams = paymentToMap(body);

      return await http.post(url, headers: headers, body: bodyParams);

      /*
            responsePayment = responsePaymentFromMap(res.body);
            print("Status: ${res.statusCode}");
            print(res.body);

            if (res.statusCode == 401) {
              print("PROBLEMAS AL REALIZAR EL PAGO ERROR CODE: ${res.statusCode}");
            }
      */

    } catch (e) {
      return e.toString();
    }
  }

  // List<MercadoPagoDocumentType>
  @override
  Future<dynamic> getIdentificationTypes() async {
    try {
      final url = Uri.https(
        _urlMercadoPago,
        "/v1/identification_types",
        {
          'access_token': _mercadoPagoCredentials.accessToken,
        },
      );

      return await http.get(url, headers: headers);
    } catch (e) {
      return e.toString();
    }
  }

  // MercadoPagoPaymentMethodInstallments
  @override
  Future<dynamic> getInstallments({
    required String bin,
    required double amount,
  }) async {
    try {
      final url = Uri.https(
        _urlMercadoPago,
        "/v1/payment_methods/installments",
        {
          'access_token': _mercadoPagoCredentials.accessToken,
          'bin': bin,
          'amount': amount.toString(),
        },
      );

      return await http.get(url, headers: headers);
    } catch (e) {
      return e.toString();
    }
  }
}
