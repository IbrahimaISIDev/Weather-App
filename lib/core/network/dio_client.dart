import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';

class DioClient {
  static Dio? _dio;

  static Dio get instance {
    if (_dio != null) return _dio!;

    final apiKey = dotenv.env[AppConstants.apiKeyEnvVar];

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        queryParameters: {
          'appid': apiKey,
          'units': ApiConstants.units,
          'lang': ApiConstants.lang,
        },
      ),
    );

    _dio!.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    return _dio!;
  }
}
