import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<String> download(String fileUrl) async {
    try {
      Directory? output = await getExternalStorageDirectory();
      RegExp pathToDownloads = RegExp(r'.+0\/');
      final outputPath =
          '${pathToDownloads.stringMatch(output!.path).toString()}Download'; // returns /storage/emulated/0/Download
      String url = fileUrl.split('/').last;
      final filePath = '$outputPath/$url';

      var file = File(filePath);

      var dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';

      // Ask for storage permission
      PermissionStatus result;
      // In Android we need to request the storage permission,
      // while in iOS is the photos permission

      if (Platform.isAndroid) {
        result = await Permission.storage.request();
      } else {
        result = await Permission.photos.request();
      }

      if (result.isGranted) {
        await dio.download(
          fileUrl,
          file.path,
          // onReceiveProgress: (received, total) {
          //   int progress = (((received / total) * 100).toInt());
          //   if (logsEnabled) _logger.i(progress);
          //
          //   final String url = file.path;
          //   if (logsEnabled) _logger.i("Url: $url");
          //   print("Path: ${file.path}");
          //   //OpenFile.open(url);
          // },
        );
      }
      // else if (Platform.isIOS || result.isPermanentlyDenied) {
      // } else {}

      return file.path;
    } on DioError catch (e) {
      if (logsEnabled) _logger.e("DioError");
    }

    return "";
  }
}
