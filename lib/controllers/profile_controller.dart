//profile_controller.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserController {
  static const String _editUrl =
      'https://app-iv-ii-main-td0mcu.laravel.cloud/api/edit';

  static Future<Map<String, dynamic>> updateUser({
    required String name,
    required String email,
    required String password,
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

      final url = Uri.parse(_editUrl);
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey('user')) {
          final updatedUser = User.fromJson(data['user']);

          await prefs.setString('user_name', updatedUser.name ?? '');
          await prefs.setString('user_email', updatedUser.email ?? '');

          return {
            'success': true,
            'user': updatedUser,
          };
        } else {
          return {
            'success': false,
            'message': 'Respuesta inesperada del servidor.',
          };
        }
      } else {
        debugPrint('Error ${response.statusCode}: ${response.body}');
        return {
          'success': false,
          'message':
              'Error (${response.statusCode}) al actualizar usuario: ${response.body}',
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
