import 'package:store_mundo_negocio/clean_architecture/domain/model/user_information.dart';
import '../../helper/http_response.dart';
abstract class UserRepositoryInterface {
  const UserRepositoryInterface();

  // Address
  Future<HttpResponse> getAddressMain();

  // http.response
  Future<HttpResponse> updateUserAddress({
    required Address address,
    required Map<String, String> headers,
  });

  Future<HttpResponse> updateUserInformation({
    required Map<String, dynamic> binding,
    required Map<String, String> headers,
  });

  // http.response
  Future<HttpResponse> createAddress({
    required Address address,
    required Map<String, String> headers,
  });

  // http.response
  Future<HttpResponse> changeMainAddress({
    required String addressId,
    required Map<String, String> headers,
  });

  // http.response
  Future<HttpResponse> deleteUserAddress({
    required String addressId,
    required Map<String, String> headers,
  });

  Future<HttpResponse> createPhone({
    required Phone phone,
    required Map<String, String> headers,
  });

  // http.response
  Future<HttpResponse> updateUserPhone({
    required Phone phone,
    required Map<String, String> headers,
  });

  // http.response
  Future<HttpResponse> changeMainPhone({
    required String phoneId,
    required Map<String, String> headers,
  });

  // http.response
  Future<HttpResponse> deleteUserPhone({
    required String phoneId,
    required Map<String, String> headers,
  });

  // User
  Future<HttpResponse> getInformationUser({required Map<String, String> headers});

  // http.response
  // Future<HttpResponse> pushUserNotificationToken();

  // List<Order>
  Future<HttpResponse> getOrdersById({
    required Map<String, String> headers,
  });

  // List<Order>
  Future<HttpResponse> getOrderDetailById({required int paymentId});

  Future<HttpResponse> changeUserMail({
    required Map<String, String> headers,
    required Map<String, dynamic> bindings
  });

  Future<HttpResponse> changeUserPassword({
    required Map<String, String> headers,
    required Map<String, dynamic> bindings
  });
}
