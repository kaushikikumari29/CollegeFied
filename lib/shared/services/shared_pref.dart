import 'package:collegefied/config/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const _authTokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _isProfileCompleteKey = 'is_profile_complete';

  // Save token
  static Future<void> saveAuthToken(String token) async {
    await _prefs.setString(_authTokenKey, token);
  }

  // Get token
  static String? getAuthToken() {
    return _prefs.getString(_authTokenKey);
  }

  // Remove token (Logout)
  static Future<void> clearAuthToken() async {
    await _prefs.remove(_authTokenKey);
  }

  // Save userId
  static Future<void> saveUserId(int userId) async {
    await _prefs.setInt(_userIdKey, userId);
  }

  // Get userId
  static int? getUserId() {
    return _prefs.getInt(_userIdKey);
  }

  // Remove userId (Logout)
  static Future<void> clearUserId() async {
    await _prefs.remove(_userIdKey);
  }

  // Profile Completion
  static Future<void> saveProfileComplete(bool isComplete) async {
    await _prefs.setBool(_isProfileCompleteKey, isComplete);
  }

  static bool get isProfileComplete {
    return _prefs.getBool(_isProfileCompleteKey) ?? false;
  }

  static logout() async {
    await clearAuthToken();
    await clearUserId();
    await saveProfileComplete(false);
    await _prefs.clear();
    Get.offAllNamed(AppRoutes.welcome);
  }
}
