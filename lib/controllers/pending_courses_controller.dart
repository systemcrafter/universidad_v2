// lib/controllers/pending_courses_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Para debugPrint
import 'package:shared_preferences/shared_preferences.dart';
import '../models/materia_model.dart'; // Importa el modelo de Materia

class PendingCoursesController {
  static const String _baseUrl =
      'https://app-iv-ii-main-td0mcu.laravel.cloud/api/pendientes';

  static Future<Map<String, dynamic>> getMaterias() async {
    try {
      // 1. Obtener el token de SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('auth_token');

      if (authToken == null) {
        debugPrint('Error: No hay token de autenticación disponible.');
        return {
          'success': false,
          'message': 'No se ha iniciado sesión. Por favor, inicie sesión.',
        };
      }

      final url = Uri.parse(_baseUrl);
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };

      final body = jsonEncode({
        'estado': 'pendiente',
      });

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey('materias') && data['materias'] is List) {
          final List<dynamic> materiasJson = data['materias'];
          final List<Materia> materias =
              materiasJson.map((json) => Materia.fromJson(json)).toList();

          debugPrint('Materias obtenidas: ${materias.length}');
          return {
            'success': true,
            'materias': materias,
          };
        } else {
          debugPrint(
              'Error: La respuesta no contiene la clave "materias" o no es una lista.');
          return {
            'success': false,
            'message': 'Formato de respuesta de API inválido.',
          };
        }
      } else {
        debugPrint(
            'Error al obtener materias: ${response.statusCode} - ${response.body}');
        return {
          'success': false,
          'message':
              'Error al cargar las materias: ${response.statusCode} - ${response.body}',
        };
      }
    } catch (e) {
      debugPrint('Excepción al obtener materias: $e');
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }
}
