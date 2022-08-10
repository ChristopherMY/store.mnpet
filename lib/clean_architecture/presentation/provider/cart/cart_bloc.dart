import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/loadany.dart';

class CartBloc extends ChangeNotifier{

  bool isCartLoaded = true;
  bool isSessionEnable = true;
  LoadStatus loginState = LoadStatus.normal;
}