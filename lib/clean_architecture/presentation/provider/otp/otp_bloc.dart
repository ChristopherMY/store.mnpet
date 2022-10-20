import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/domain/model/response_forgot_password.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/auth_repository.dart';

class OtpBloc extends ChangeNotifier {
  AuthRepositoryInterface authRepositoryInterface;

  OtpBloc({required this.authRepositoryInterface});

  ValueNotifier<bool> responseError = ValueNotifier(false);

  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  ValueNotifier<int> counter = ValueNotifier(60);
  late Timer timer;

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    timer.cancel();
    responseError.value = false;
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (counter.value == 0) {
          timer.cancel();
          return;
        }

        counter.value = counter.value - 1;
      },
    );
  }

  Future<dynamic> validateOtp({
    required String pin,
    required String userId,
  }) async {
    final response =
        await authRepositoryInterface.validateOtp(otp: pin, userId: userId);

    if (response is String) {
      if (kDebugMode) {
        print(response);
      }

      return false;
    }

    if (response is! http.Response) {
      return false;
    }

    if (response.statusCode == 200) {
      return false;
    }

    final decode = json.decode(response.body);
    return ResponseForgotPassword.fromMap(decode);
  }
}
