import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class TokenStorage extends GetxService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';

  late GetStorage _box;

  @override
  void onInit() {
    super.onInit();
    _box = GetStorage();
  }

  // Save tokens after login
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _box.write(_accessTokenKey, accessToken);
    await _box.write(_refreshTokenKey, refreshToken);
  }

  // Save user data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _box.write(_userDataKey, userData);
  }

  // Get access token
  String? getAccessToken() {
    return _box.read(_accessTokenKey);
  }

  // Get refresh token
  String? getRefreshToken() {
    return _box.read(_refreshTokenKey);
  }

  // Get user data
  Map<String, dynamic>? getUserData() {
    return _box.read(_userDataKey);
  }

  // Clear all tokens and user data (logout)
  Future<void> clearAll() async {
    await _box.remove(_accessTokenKey);
    await _box.remove(_refreshTokenKey);
    await _box.remove(_userDataKey);
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return getAccessToken() != null;
  }
}
