import 'package:flutter/material.dart';

class ApprovedCourses extends StatelessWidget {
  const ApprovedCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materias Aprobadas'),
        backgroundColor: Color(0xFF27D1C3),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.check_circle, size: 100, color: Color(0xFF27D1C3)),
              SizedBox(height: 20),
              Text(
                'Materias Aprobadas',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
