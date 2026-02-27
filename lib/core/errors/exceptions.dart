import 'package:dio/dio.dart';

abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException([super.message = 'Erreur de connexion réseau']);
}

class ServerException extends AppException {
  ServerException([super.message = 'Erreur serveur interne']);
}

class ApiException extends AppException {
  ApiException(super.message, [super.code]);
  
  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Le délai de connexion a expiré');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) return ApiException('Clé API invalide', '401');
        if (statusCode == 404) return ApiException('Ville non trouvée', '404');
        return ApiException('Erreur API ($statusCode)');
      default:
        return ApiException('Une erreur inattendue est survenue');
    }
  }
}

class LocationException extends AppException {
  LocationException([super.message = 'Erreur de géolocalisation']);
}
