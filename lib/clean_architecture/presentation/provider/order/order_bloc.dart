import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/order.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/provider/main_bloc.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';

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

  void getOrdersDetails(BuildContext context) async {
    final mainBloc = context.read<MainBloc>();
    final credentialsAuth = await mainBloc.loadCredentialsAuth();

    headers[HttpHeaders.authorizationHeader] =
    "Bearer ${credentialsAuth.token}";

    final responseApi = await userRepositoryInterface.getOrdersById(
        headers: headers);

    if (responseApi.data == null) {
      GlobalSnackBar.showWarningSnackBar(
        context, "Ups tuvimos un problema, vuelva a intentarlo más tarde",);
      return;
    }

    //----------------------
    // Response List<Order>
    //----------------------

    List<Order> orderList = [];

    for (int i = 0; i < responseApi.data.length; i++) {
      orderList.add(Order.fromMap(responseApi.data[i]));
    }

    orders = orderList;
    refreshBloc();
  }

  void refreshBloc() {
    notifyListeners();
  }
}
