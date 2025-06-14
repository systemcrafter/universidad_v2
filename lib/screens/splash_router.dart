import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRouter extends StatelessWidget {
  const SplashRouter({super.key});

  Future<String> _getStartRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return (token != null && token.isNotEmpty) ? '/home' : '/login';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getStartRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, snapshot.data!);
          });
          return const SizedBox.shrink(); // pantalla en blanco momentánea
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
