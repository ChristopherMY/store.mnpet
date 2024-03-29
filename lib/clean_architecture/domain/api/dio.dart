import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../helper/http_response.dart';

class AuthenticationAPI {
  final Dio _dio = Dio();
  final Logger _logger = Logger();

  Future<HttpResponse> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final Response response = await _dio.post(
        "https://pro.mundo-negocio.com/api/v1/products/detail/alfombra-para-cocina-2-piezas-yga12-016",
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: {
          "string": "dynamic",
        },
      );

      _logger.i(response.data);
      return HttpResponse.success(response.data);
    } catch (e) {
      _logger.e(e);

      int statusCode = -1;
      String message = "unknown error";
      dynamic data;
      if (e is DioError) {
        message = e.message;

        if (e.response != null) {
          statusCode = e.response!.statusCode!;
          message = e.response!.statusMessage!;
          data = e.response!.data!;
        }
      }

      return HttpResponse.fail(
        statusCode: statusCode,
        message: message,
        data: data,
      );
    }
  }
}
