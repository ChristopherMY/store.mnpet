import 'package:flutter/cupertino.dart';

class ContactBloc extends ChangeNotifier {
  bool isLoading = true;

  void onPageFinished(String finish) {
    isLoading = !isLoading;
    notifyListeners();
  }
}
