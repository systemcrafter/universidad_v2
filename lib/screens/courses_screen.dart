// courses_screen.dart
import 'package:flutter/material.dart';
import '../controllers/courses_controller.dart';
import '../models/materia_model.dart'; // Importa tu modelo

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<Materia> _materias = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMaterias();
  }

  Future<void> _fetchMaterias() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await CoursesController.getMaterias();

    if (result['success']) {
      setState(() {
        _materias = result['materias'] as List<Materia>;
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = result['message'] as String;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materias'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : _materias.isEmpty
                  ? const Center(child: Text('No hay materias disponibles.'))
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Código',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Nombre de la Materia',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                        rows: _materias.map<DataRow>((materia) {
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(Text(materia.codigo)),
                              DataCell(Text(materia.nombre)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchMaterias,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
