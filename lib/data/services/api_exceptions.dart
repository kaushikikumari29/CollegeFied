import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? code;

  ApiException(this.message, [this.code]);

  factory ApiException.fromDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException("Connection timed out");
      case DioExceptionType.sendTimeout:
        return ApiException("Send timeout");
      case DioExceptionType.receiveTimeout:
        return ApiException("Receive timeout");
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ?? 'Something went wrong';
        return ApiException(message, statusCode);
      case DioExceptionType.cancel:
        return ApiException("Request was cancelled");
      default:
        return ApiException("Unexpected error occurred");
    }
  }

  @override
  String toString() => "ApiException: $message (code: $code)";
}
