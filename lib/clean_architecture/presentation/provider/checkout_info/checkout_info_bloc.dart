import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/domain/model/credit_card_model.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/payment_repository.dart';

class CheckOutInfoBloc extends ChangeNotifier {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  int expirationMonth = 0;
  String expirationYear = "";

  PaymentRepository paymentRepository;

  CheckOutInfoBloc({required this.paymentRepository});

  final pageController = PageController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void handlePayment({
    required String identificationNumber,
  }) async {
    if (formKey.currentState!.validate()) {
      if (expiryDate.isNotEmpty) {
        List<String> list = expiryDate.split('/');
        if (list.length == 2) {
          expirationMonth = int.parse(list[0]);
          expirationYear = "20${list[1]}";
        } else {
          print("COMPLETAR CAMPO FECHA");
        }
      }

      await paymentRepository.createCardToken(
        cvv: cvvCode,
        expirationYear: expirationYear,
        expirationMonth: expirationMonth,
        cardNumber: cardNumber,
        identificationNumber: identificationNumber,
        identificationId: identificationId ?? "",
        cardHolderName: cardHolderName,
      );
    } else {
      ///TODO: No important;
      print('invalid!');
    }
  }0

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    cardNumber = creditCardModel!.cardNumber;
    expiryDate = creditCardModel.expiryDate;
    cardHolderName = creditCardModel.cardHolderName;
    cvvCode = creditCardModel.cvvCode;
    isCvvFocused = creditCardModel.isCvvFocused;

    notifyListeners();
  }
}
