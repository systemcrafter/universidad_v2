// LogoutController.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LogoutController {
  static const String _logoutUrl =
      'https://app-iv-ii-main-td0mcu.laravel.cloud/api/logout';

  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        debugPrint('No hay token para revocar.');
        return false;
      }

      final response = await http.post(
        Uri.parse(_logoutUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Limpiar datos locales después de logout exitoso en el servidor
        await prefs.remove('auth_token');
        await prefs.remove('user_name');
        debugPrint('Logout exitoso y token revocado en el backend');
        return true;
      } else {
        debugPrint(
            'Error ${response.statusCode} al revocar el token en backend');
        return false;
      }
    } catch (e) {
      debugPrint('Error en logout: $e');
      return false;
    }
  }
}
