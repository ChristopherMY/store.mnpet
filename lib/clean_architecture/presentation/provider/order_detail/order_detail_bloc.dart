import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/order.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/order_detail.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/user_repository.dart';
import 'package:http/http.dart' as http;

class OrderDetailBloc extends ChangeNotifier{

  final UserRepositoryInterface userRepositoryInterface;

  OrderDetailBloc({
    required this.userRepositoryInterface,
  });


  dynamic orderDetail;


  Map<String, String> headers = {
    "Content-type": "application/json",
    "Custom-Origin": "app",
  };


  Future<dynamic> getOrderDetailById(int paymentId) async {
    final response = await userRepositoryInterface.getOrderDetailById(paymentId: paymentId);

    if (response is String) {
      return null;
    }

    if (response is! http.Response) {
      return null;
    }

    if (response.statusCode != 200) {
      return null;
    }

    final decode = json.decode(response.body);

    //----------------------
    // Response OrderDetail
    //----------------------

    return OrderDetail.fromMap(decode);
  }

  void refreshBloc() {
    notifyListeners();
  }

}