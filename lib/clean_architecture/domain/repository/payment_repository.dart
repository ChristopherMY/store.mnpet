import '../../helper/http_response.dart';

abstract class PaymentRepositoryInterface {

  // List<MercadoPagoDocumentType>
  Future<HttpResponse> getIdentificationTypes();

  // http.Response
  Future<HttpResponse> createCardToken({
    required String cvv,
    required String expirationYear,
    required int expirationMonth,
    required String cardNumber,
    required String identificationNumber,
    required String identificationId,
    required String cardHolderName,
  });

  // MercadoPagoPaymentMethodInstallments
  Future<HttpResponse> getInstallments({
    required String bin,
    required double amount,
  });

  // http.Response
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
    // @required String emailCustomer,
    // @required String identificationType,
    // @required String identificationNumber,
    // @required String firstNameCustomer,
    // @required String lastNameCustomer,
    // required double transactionAmount,
  });


}
