import 'package:collegefied/config/global_variable.dart';
import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/data/services/api_client.dart';
import 'package:collegefied/data/services/api_endpoints.dart';
import 'package:collegefied/data/services/api_exceptions.dart';
import 'package:collegefied/shared/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final ApiClient _apiClient = ApiClient();

  Future<void> register(
    String email,
    String password,
    String username, {
    VoidCallback? onSuccess,
  }) async {
    isLoading.value = true;
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {
          ApiEndpoints.email: email,
          ApiEndpoints.password: password,
          ApiEndpoints.confirmPassword: password,
          ApiEndpoints.username: username,
        },
      );

      final data = response.data;
      final message =
          data['msg'] ?? data['detail'] ?? 'Registration Successful';

      if (response.statusCode == 200) {
        Get.snackbar('Success', message);
        onSuccess?.call();
        Get.toNamed(AppRoutes.otp, arguments: {
          'email': email,
          'password': password,
        });
      } else if (response.statusCode == 400) {
        final usernameError = data['username']
                ?.toString()
                .replaceAll('[', '')
                .replaceAll(']', '') ??
            'Registration error';
        Get.snackbar('Error', usernameError);
      }
    } catch (e) {
      final errorMessage = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    myUserId=0;
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          ApiEndpoints.email: email,
          ApiEndpoints.password: password,
        },
      );

      final data = response.data;

      if (response.statusCode == 200) {
        Get.snackbar("Success", data['msg'] ?? '');
        await SharedPrefs.saveAuthToken(data['token']['access']);
        await SharedPrefs.saveUserId(data['user_id']);
        Get.toNamed(AppRoutes.home);
      } else {
        Get.snackbar("Error", data['detail'] ?? 'Invalid credentials');
      }
    } catch (e) {
      final message =
          e is ApiException ? e.message : 'Unexpected error occurred';
      Get.snackbar('Error', message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String email, String password, String otp) async {
    isLoading.value = true;
    try {
      final response = await _apiClient.post(
        ApiEndpoints.verifyOtp,
        data: {
          ApiEndpoints.email: email,
          ApiEndpoints.password: password,
          ApiEndpoints.otp: otp,
        },
      );

      final data = response.data;
      if (response.statusCode == 200) {
        Get.snackbar('Success', data['msg'] ?? 'OTP Verified');
        Get.toNamed(AppRoutes.resetPassword);
      } else {
        Get.snackbar('Error', data['detail'] ?? 'Invalid OTP');
      }
    } catch (e) {
      final message = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', message);
    } finally {
      isLoading.value = false;
    }
  }
}
