import 'package:store_mundo_pet/clean_architecture/domain/model/vimeo_video_config.dart';

abstract class AuthRepositoryInterface {
  // https.Response
  Future<dynamic> loginVerification({
    required String email,
    required String password,
  });

  // https.Response
  Future<dynamic> createUser({required User user});
}
