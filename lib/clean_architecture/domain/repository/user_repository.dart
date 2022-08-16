import 'package:store_mundo_pet/clean_architecture/domain/model/user_information.dart';

abstract class UserRepositoryInterface {
  const UserRepositoryInterface();

  // Address
  Future<dynamic> getAddressMain();

  // http.response
  Future<dynamic> updateUserAddress({
    required String addressId,
    required Address address,
  });

  // http.response
  Future<dynamic> createAddress({required Address address});

  // http.response
  Future<dynamic> changeMainAddress({required addressId});

  // http.response
  Future<dynamic> deleteUserAddress({required String addressId});

  // User
  Future<dynamic> getInformationUser({required Map<String, String> headers});

  // http.response
  Future<dynamic> pushUserNotificationToken();

  // List<Order>
  Future<dynamic> getOrdersById();

  // List<Order>
  Future<dynamic> getOrderDetailById({required int paymentId});

}
