import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../helper/http_response.dart';

class Http {
  final Dio _dio = Dio();
  final Logger _logger = Logger();
  bool logsEnabled;

  Http({
    required this.logsEnabled,
  });

  Future<HttpResponse> request(
    String path, {
    String method = "GET",
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    try {
      final Response response = await _dio.request(
        path,
        options: Options(
          method: method,
          headers: headers,
        ),
        queryParameters: queryParameters,
        data: data,
      );

      if (logsEnabled) _logger.i(response.data);
      return HttpResponse.success(response.data);
    } catch (e) {
      if (logsEnabled) _logger.e(e);

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
