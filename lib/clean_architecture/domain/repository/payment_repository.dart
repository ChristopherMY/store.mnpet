import 'package:store_mundo_pet/clean_architecture/domain/model/payment.dart';

abstract class PaymentRepository {

  // List<MercadoPagoDocumentType>
  Future<dynamic> getIdentificationTypes();

  // http.Response
  Future<dynamic> createCardToken({
    required String cvv,
    required String expirationYear,
    required int expirationMonth,
    required String cardNumber,
    required String identificationNumber,
    required String identificationId,
    required String cardHolderName,
  });

  // MercadoPagoPaymentMethodInstallments
  Future<dynamic> getInstallments({
    required String bin,
    required double amount,
  });

  // http.Response
  Future<dynamic> createPayment({
    required String userId,
    required String addressId,
    required double shippingCost,
    required double subTotal,
    required String additionalInfoMessage, // Optional
    required String companyName, // Optional
    required Identification identification,
    required String paymentTypeId,
    // @required String emailCustomer,
    // @required String identificationType,
    // @required String identificationNumber,
    // @required String firstNameCustomer,
    // @required String lastNameCustomer,
    required double transactionAmount,
    required String cardToken,
    required int installments,
    required String paymentMethodId,
    required String issuerId,
  });


}