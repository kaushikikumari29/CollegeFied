import 'dart:io';

import 'package:collegefied/data/services/api_endpoints.dart';
import 'package:collegefied/shared/services/shared_pref.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_exceptions.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiEndpoints.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ));

  void _logRequest(String method, String path,
      {Map<String, dynamic>? data}) async {
    if (kDebugMode) {
      print('➡️ [$method] ${_dio.options.baseUrl}$path');
      if (data != null) print('📦 Data: $data');
      final token = await SharedPrefs.getAuthToken();
      print("Auth token ==> $token");
    }
  }

  void _logResponse(Response response) {
    if (kDebugMode) {
      print('✅ [${response.statusCode}] Response: ${response.data}');
    }
  }

  void _logError(DioException e) {
    if (kDebugMode) {
      print('❌ DioError: ${e.message}');
      if (e.response != null) {
        print('❗ Response: ${e.response?.data}');
      }
    }
  }

  Future<Map<String, String>> _buildHeaders() async {
    final token = await SharedPrefs.getAuthToken();
    debugPrint("$token");
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<Response> get(String path) async {
    _logRequest('GET', path);
    try {
      final headers = await _buildHeaders();
      final response = await _dio.get(path, options: Options(headers: headers));
      _logResponse(response);
      return response;
    } on DioException catch (e) {
      _logError(e);
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    _logRequest('POST', path, data: data);
    try {
      final headers = await _buildHeaders();
      final response =
          await _dio.post(path, data: data, options: Options(headers: headers));
      _logResponse(response);
      return response;
    } on DioException catch (e) {
      _logError(e);
      if (e.response != null && e.response!.statusCode == 400) {
        return e.response!;
      }
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> postWithImage(
    String path, {
    Map<String, dynamic>? data,
    List<File>? images, // <--- Accept List<File> now
  }) async {
    _logRequest('POST', path, data: data);
    print("images = $images");
    try {
      final headers = await _buildHeaders();

      dynamic requestData;

      if (images != null && images.isNotEmpty) {
        // Create a list of MultipartFile
        List<MultipartFile> multipartImages = await Future.wait(
          images.map((image) async {
            final fileName = image.path.split('/').last;
            return await MultipartFile.fromFile(
              image.path,
              filename: fileName,
            );
          }),
        );

        requestData = FormData.fromMap({
          ...?data,
          'images': multipartImages, // List<MultipartFile>
        });
      } else {
        requestData = data;
      }

      final response = await _dio.post(
        path,
        data: requestData,
        options: Options(headers: headers),
      );

      _logResponse(response);
      return response;
    } on DioException catch (e) {
      _logError(e);
      if (e.response != null && e.response!.statusCode == 400) {
        return e.response!;
      }
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    _logRequest('PUT', path, data: data);
    try {
      final headers = await _buildHeaders();
      final response =
          await _dio.put(path, data: data, options: Options(headers: headers));
      _logResponse(response);
      return response;
    } on DioException catch (e) {
      _logError(e);
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> patch(String path, {Map<String, dynamic>? data}) async {
    _logRequest('PATCH', path, data: data);
    try {
      final headers = await _buildHeaders();
      final response = await _dio.patch(path,
          data: data, options: Options(headers: headers));
      _logResponse(response);
      return response;
    } on DioException catch (e) {
      _logError(e);
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> delete(String path, {Map<String, dynamic>? data}) async {
    _logRequest('DELETE', path, data: data);
    try {
      final headers = await _buildHeaders();
      final response = await _dio.delete(path,
          data: data, options: Options(headers: headers));
      _logResponse(response);
      return response;
    } on DioException catch (e) {
      _logError(e);
      throw ApiException.fromDioError(e);
    }
  }
}
