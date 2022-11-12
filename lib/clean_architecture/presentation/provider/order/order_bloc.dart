import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_mundo_negocio/clean_architecture/domain/model/order.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/user_repository.dart';

class OrderBloc extends ChangeNotifier {
  final UserRepositoryInterface userRepositoryInterface;

  OrderBloc({
    required this.userRepositoryInterface,
  });

  dynamic orders;

  Map<String, String> headers = {
    "Content-type": "application/json",
    "Custom-Origin": "app",
  };

  Future<dynamic> getOrdersDetails() async {
    final response = await userRepositoryInterface.getOrdersById(headers: headers);

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
    // Response List<Order>
    //----------------------

    List<Order> orderList = [];

    for (int i = 0; i < decode.length; i++) {
      orderList.add(Order.fromMap(decode[i]));
    }

    return orderList;
  }

  void refreshBloc() {
    notifyListeners();
  }
}
