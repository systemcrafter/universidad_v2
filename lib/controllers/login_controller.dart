// login_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class LoginController {
  static const String _baseUrl =
      'https://app-iv-ii-main-td0mcu.laravel.cloud/api/login';

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse(_baseUrl);
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        'email': email,
        'password': password,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['accessToken'];
        final userData = data['user'];
        final user = User.fromJson(userData);

        debugPrint('Token login: $token');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_name', user.name ?? '');
        await prefs.setString('user_email', user.email ?? '');

        return {
          'success': true,
          'token': token,
          'user': user,
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Credenciales incorrectas',
        };
      } else {
        return {
          'success': false,
          'message': 'Error inesperado (${response.statusCode})',
        };
      }
    } catch (e) {
      debugPrint('Error en login: $e');
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }
}
