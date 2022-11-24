import 'package:flutter/cupertino.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/order_detail.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/model/response_api.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/presentation/util/global_snackbar.dart';

class OrderDetailBloc extends ChangeNotifier {
  final UserRepositoryInterface userRepositoryInterface;

  OrderDetailBloc({
    required this.userRepositoryInterface,
  });

  dynamic orderDetail;

  Map<String, String> headers = {
    "Content-type": "application/json",
    "Custom-Origin": "app",
  };

  Future<void> getOrderDetailById(int paymentId, BuildContext context) async {
    final responseApi =
        await userRepositoryInterface.getOrderDetailById(paymentId: paymentId);

    if (responseApi.data == null) {
      context.loaderOverlay.hide();
      final statusCode = responseApi.error!.statusCode;
      if (statusCode == 400) {
        final response = ResponseApi.fromMap(responseApi.error!.data);
        GlobalSnackBar.showWarningSnackBar(context, response.message);
        return;
      }

      GlobalSnackBar.showWarningSnackBar(
        context,
        "Ups tuvimos un problema, vuelva a intentarlo más tarde.",
      );

      return;
    }

    orderDetail = OrderDetail.fromMap(responseApi.data);
    refreshBloc();
    return;
  }

  void refreshBloc() {
    notifyListeners();
  }
}
