import 'package:collegefied/config/global_variable.dart';
import 'package:collegefied/data/services/api_client.dart';
import 'package:collegefied/data/services/api_endpoints.dart';
import 'package:collegefied/data/services/api_exceptions.dart';
import 'package:collegefied/shared/services/shared_pref.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final isLoading = false.obs;
  final profileData = {}.obs;
  final ApiClient _apiClient = ApiClient();

  Future<void> fetchProfileData() async {
    isLoading.value = true;
    final userId = await SharedPrefs.getUserId();
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.profile}/$userId',
      );
      print("response= $response");

      if (response.statusCode == 200) {
        profileData.value = response.data;
        myUserId=profileData['user'];
      } else {
        Get.snackbar('Error', 'Failed to fetch profile');
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', msg);
    } finally {
      isLoading.value = false;
    }
  }


Future<void> updateProfileData(Map<String, dynamic> updatedData) async {
    isLoading.value = true;
    final userId = await SharedPrefs.getUserId();
    try {
      final response = await _apiClient.patch(
        '${ApiEndpoints.profile}$userId/',
        data: updatedData,
      );
      print("update response = $response");

      if (response.statusCode == 200) {
        profileData.value = response.data;
        Get.snackbar('Success', 'Profile updated successfully');
      } else {
        Get.snackbar('Error', 'Failed to update profile');
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', msg);
    } finally {
      isLoading.value = false;
    }
  }



}
