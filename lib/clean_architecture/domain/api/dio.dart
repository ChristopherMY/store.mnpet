import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class AuthenticationAPI {
  final Dio _dio = Dio();
  final Logger _logger = Logger();

  Future<void> register({
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
    } catch (e) {
      _logger.e(e);
    }
  }
}
