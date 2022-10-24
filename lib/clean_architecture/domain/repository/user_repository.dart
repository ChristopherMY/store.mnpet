import 'package:store_mundo_pet/clean_architecture/domain/model/user_information.dart';

abstract class UserRepositoryInterface {
  const UserRepositoryInterface();

  // Address
  Future<dynamic> getAddressMain();

  // http.response
  Future<dynamic> updateUserAddress({
    required Address address,
    required Map<String, String> headers,
  });

  Future<dynamic> updateUserInformation({
    required Map<String, dynamic> binding,
    required Map<String, String> headers,
  });

  // http.response
  Future<dynamic> createAddress({
    required Address address,
    required Map<String, String> headers,
  });

  // http.response
  Future<dynamic> changeMainAddress({
    required String addressId,
    required Map<String, String> headers,
  });

  // http.response
  Future<dynamic> deleteUserAddress({
    required String addressId,
    required Map<String, String> headers,
  });

  Future<dynamic> createPhone({
    required Phone phone,
    required Map<String, String> headers,
  });

  // http.response
  Future<dynamic> updateUserPhone({
    required Phone phone,
    required Map<String, String> headers,
  });

  // http.response
  Future<dynamic> changeMainPhone({
    required String phoneId,
    required Map<String, String> headers,
  });

  // http.response
  Future<dynamic> deleteUserPhone({
    required String phoneId,
    required Map<String, String> headers,
  });

  // User
  Future<dynamic> getInformationUser({required Map<String, String> headers});

  // http.response
  Future<dynamic> pushUserNotificationToken();

  // List<Order>
  Future<dynamic> getOrdersById({ required Map<String, String> headers,});

  // List<Order>
  Future<dynamic> getOrderDetailById({required int paymentId});
}
