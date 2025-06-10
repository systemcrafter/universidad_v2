//logout_controller.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutController {
  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('auth_token');
      debugPrint('Token logout: $token');

      // Limpieza selectiva: solo elimina el token
      await prefs.remove('auth_token');
      await prefs.remove('user_name');
      debugPrint('Datos borrados correctamente');

      return true;
    } catch (e) {
      debugPrint('Error al hacer logout: $e');
      return false;
    }
  }
}
