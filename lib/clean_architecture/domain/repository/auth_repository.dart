abstract class AuthRepositoryInterface {
  // https.Response
  Future<dynamic> loginVerification({
    required String email,
    required String password,
  });

  // https.Response
  Future<dynamic> createUser({required Map<String, dynamic> user});

  // https.Response
  Future<dynamic> requestPasswordChange({
    required String value,
    required String valueType,
  });

  Future<dynamic> validateOtp({
    required String otp,
    required String userId,
  });

  Future<dynamic> changePassword({
    required String userId,
    required String password,
    required String passwordConfirmation,
  });
}
