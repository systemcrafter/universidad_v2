//main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/approved_screen.dart';
import 'screens/pending_screen.dart';
import 'screens/courses_screen.dart';
import 'screens/splash_router.dart'; // Nuevo archivo

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universidad',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashRouter(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/courses': (context) => const CoursesScreen(),
        '/approved': (context) => const ApprovedScreen(),
        '/pending': (context) => const PendingCoursesScreen(),
      },
    );
  }
}
