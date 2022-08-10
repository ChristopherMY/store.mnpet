import 'package:store_mundo_pet/clean_architecture/domain/model/user_information_local.dart';

abstract class LocalRepositoryInterface{
  const LocalRepositoryInterface();

  Future<String?> getToken();

  Future<String?> saveToken(String token);

  Future<void> clearAllData();

}