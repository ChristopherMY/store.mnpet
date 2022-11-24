
import '../../helper/http_response.dart';
abstract class AuthRepositoryInterface {
  // https.Response
  Future<HttpResponse> loginVerification({
    required String email,
    required String password,
  });

  // https.Response
  Future<HttpResponse> createUser({required Map<String, dynamic> data});

  // https.Response
  Future<HttpResponse> requestPasswordChange({
    required String value,
    required String valueType,
  });

  Future<HttpResponse> validateOtp({
    required String otp,
    required String userId,
  });

  Future<HttpResponse> changePassword({
    required String userId,
    required String password,
    required String passwordConfirmation,
  });
}
