// user_controller.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserController {
  static const String _baseUrl =
      'https://app-iv-ii-main-td0mcu.laravel.cloud/api/user';

  static Future<Map<String, dynamic>> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'Token no disponible. Inicia sesión nuevamente.',
        };
      }

      final url = Uri.parse(_baseUrl);
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data);

        return {
          'success': true,
          'user': user,
        };
      } else {
        return {
          'success': false,
          'message': 'Error (${response.statusCode}) al obtener usuario.',
        };
      }
    } catch (e) {
      debugPrint('Error en getUser: $e');
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> updateUser({
    required String name,
    required String email,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'Token no disponible.',
        };
      }

      final url = Uri.parse(_baseUrl);
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = jsonEncode({
        'name': name,
        'email': email,
      });

      // final response = await http.put(url, headers: headers, body: body);
      final response = await http.patch(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updatedUser = User.fromJson(data);
        await prefs.setString('user_name', updatedUser.name);

        return {
          'success': true,
          'user': updatedUser,
        };
      } else {
        return {
          'success': false,
          'message': 'Error (${response.statusCode}) al actualizar usuario.',
        };
      }
    } catch (e) {
      debugPrint('Error en updateUser: $e');
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }
}
