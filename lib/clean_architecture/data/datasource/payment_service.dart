import 'dart:io';

import 'package:store_mundo_negocio/clean_architecture/domain/api/environment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/payment.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/payment_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/http.dart';
import '../../helper/http_response.dart';

class PaymentService implements PaymentRepositoryInterface {
  final String _urlMercadoPago = "api.mercadopago.com";
  final _mercadoPagoCredentials = Environment.mercadoPagoCredentials;
  final String _url = Environment.API_DAO;
  final Http _dio = Http(logsEnabled: false);

  // List<MercadoPagoDocumentType>

  @override
  Future<HttpResponse> createCardToken({
    required String cvv,
    required String expirationYear,
    required int expirationMonth,
    required String cardNumber,
    required String identificationNumber,
    required String identificationId,
    required String cardHolderName,
  }) async {
    final url = "https://$_urlMercadoPago/v1/card_tokens";

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

    return await _dio.request(
      url,
      method: "POST",
      data: body,
      headers: headers,
    );
  }

  // http.Response
  @override
  Future<HttpResponse> createPayment({
    required String cardToken,
    required int installments,
    required String paymentMethodId,
    required String issuerId,
    required Map<String, String> headers,
    // required String userId,
    // required String addressId,
    // required double shippingCost,
    // required double subTotal,
    required String companyName, // Optional
    required String additionalInfoMessage, // Optional
    // required Identification identification,
    // required String paymentTypeId,
    // required String emailCustomer,
    // required String identificationType,
    // required String identificationNumber,
    // required String firstNameCustomer,
    // required String lastNameCustomer,
    // required double transactionAmount,
  }) async {
    final url = '$_url/api/v1/checkout/process-payment/app';

    final body = Payment(
      token: cardToken,
      installments: installments,
      paymentMethodId: paymentMethodId,
      issuerId: issuerId,
      // paymentTypeId: paymentTypeId,
      // userId: userId,
      // addressId: addressId,
      // shippingCost: shippingCost,
      // subTotal: subTotal,
      // transactionAmount: transactionAmount,
      // identification: identification,
      companyName: companyName,

      additionalInfoMessage: additionalInfoMessage,

      /// Optional
    );

    return await _dio.request(url, method: "POST", headers: headers, data: body.toMap());
  }

  // List<MercadoPagoDocumentType>
  @override
  Future<HttpResponse> getIdentificationTypes() async {
    final url = "https://$_urlMercadoPago/v1/identification_types?access_token=${_mercadoPagoCredentials.accessToken}";

    return await _dio.request(
      url,
      method: "GET",
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  // MercadoPagoPaymentMethodInstallments
  @override
  Future<HttpResponse> getInstallments({
    required String bin,
    required double amount,
  }) async {
    final url = "https://$_urlMercadoPago/v1/payment_methods/installments?access_token=${_mercadoPagoCredentials.accessToken}&bin=$bin&amount=$amount";
    return await _dio.request(
      url,
      method: "GET",
      headers: {
        "Content-type": "application/json",
        // "access_token": _mercadoPagoCredentials.accessToken,
        // 'bin': bin,
        // 'amount': amount.toString(),
      },
    );
  }
}
