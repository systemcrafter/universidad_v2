import 'package:shared_preferences/shared_preferences.dart';

class LogoutController {
  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      return true;
    } catch (_) {
      return false;
    }
  }
}
