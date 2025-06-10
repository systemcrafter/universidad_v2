import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutController {
  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('auth_token'); // clave correcta
      debugPrint('Token logout: $token');

      await prefs.clear();
      return true;
    } catch (_) {
      return false;
    }
  }
}
