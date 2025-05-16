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

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', message);
        onSuccess?.call();
        Get.toNamed(AppRoutes.otp, arguments: {
          'email': email,
          'password': password,
          'fromResetPassword':false,
        });
      } else if (response.statusCode == 400) {
        final errorMessage = data['detail'] ??
            data['username']
                ?.toString()
                .replaceAll('[', '')
                .replaceAll(']', '') ??
            'Registration error';

        Get.snackbar('Error', errorMessage);
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
    myUserId = 0;
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
        // Check if 'errors' key exists and has relevant messages
        if (data['erors'] != null &&
            data['erors']['non_field_errors'] != null) {
          Get.snackbar("Error", data['erors']['non_field_errors'][0]);
        } else {
          Get.snackbar("Success", data['msg'] ?? '');
          await SharedPrefs.saveAuthToken(data['token']['access']);
          await SharedPrefs.saveUserId(data['user_id']);
          Get.offAllNamed(AppRoutes.home);
        }
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

  Future<void> verifyOtp(String email, String otp) async {
    isLoading.value = true;
    try {
      final response = await _apiClient.post(
        ApiEndpoints.verifyOtp,
        data: {
          ApiEndpoints.email: email,
          ApiEndpoints.otp: otp,
        },
      );

      final data = response.data;
      if (response.statusCode == 200) {
        Get.snackbar('Success', data['msg'] ?? 'OTP Verified');
        Get.toNamed(AppRoutes.login);
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

   Future<void> forgotPassword(String email) async {
    isLoading.value = true;
    try {
      final response = await _apiClient.post(
        ApiEndpoints.forgotPasswordEmailRequest,
        data: {
          ApiEndpoints.email: email,
          
        },
      );

      final data = response.data;
      if (response.statusCode == 200) {
        Get.snackbar('Success', data['msg'] ?? 'OTP Sent On your email id');
        Get.toNamed(AppRoutes.otp,
        arguments: {
          'email':email,
          'fromResetPassword':true,
        }
        );
      } else {
        Get.snackbar('Error', data['detail'] ?? 'Request Failed');
      }
    } catch (e) {
      final message = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email, String password, String cPass, String otp) async {
    isLoading.value = true;
    try {
      final response = await _apiClient.post(
        ApiEndpoints.resetPassword,
        data: {
          ApiEndpoints.email: email,
          ApiEndpoints.password: password,
          ApiEndpoints.confirmPassword:cPass,
          ApiEndpoints.otp: otp,
        },
      );

      final data = response.data;
      if (response.statusCode == 200) {
        Get.snackbar('Success', data['msg'] ?? 'OTP Verified');
        Get.toNamed(AppRoutes.login);
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
