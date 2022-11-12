import 'package:flutter/material.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_negocio/clean_architecture/domain/usecase/page.dart';

import '../../../domain/repository/hive_repository.dart';

class AccountBloc extends ChangeNotifier {
  UserRepositoryInterface userRepositoryInterface;
  HiveRepositoryInterface hiveRepositoryInterface;

  AccountBloc({
    required this.userRepositoryInterface,
    required this.hiveRepositoryInterface,
  });

  LoadStatus loadProfileScreen = LoadStatus.loading;
  ValueNotifier<bool> pressed = ValueNotifier(false);



}
