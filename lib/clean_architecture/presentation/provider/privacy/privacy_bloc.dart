import 'package:flutter/cupertino.dart';

class PrivacyBloc extends ChangeNotifier {
  bool isLoading = true;

  void onPageFinished(String finish) {
    isLoading = !isLoading;
    notifyListeners();
  }
}
