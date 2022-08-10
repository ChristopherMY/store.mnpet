import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/domain/repository/user_repository.dart';
import 'package:store_mundo_pet/clean_architecture/presentation/widget/loadany.dart';

import '../../../domain/repository/hive_repository.dart';

class ProfileBloc extends ChangeNotifier {
  UserRepositoryInterface userRepositoryInterface;
  HiveRepositoryInterface hiveRepositoryInterface;

  ProfileBloc({
    required this.userRepositoryInterface,
    required this.hiveRepositoryInterface,
  });

  LoadStatus loadProfileScreen = LoadStatus.loading;
  ValueNotifier<bool> pressed = ValueNotifier(false);

  void onHighlightChanged(bool press) {
    pressed.value = press;
  }
}
