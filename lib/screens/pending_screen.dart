// pending_courses_screen.dart
import 'package:flutter/material.dart';
import '../controllers/pending_courses_controller.dart';
import '../models/materia_model.dart';

class PendingCoursesScreen extends StatefulWidget {
  const PendingCoursesScreen({super.key});

  @override
  State<PendingCoursesScreen> createState() => _PendingCoursesScreenState();
}

class _PendingCoursesScreenState extends State<PendingCoursesScreen> {
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

    final result = await PendingCoursesController.getMaterias();

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

  void _showMateriaDialog(BuildContext context, Materia materia) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('📘 ${materia.nombre}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Código: ${materia.codigo}'),
            Text('Créditos: ${materia.creditos}'),
            Text('Requisito: ${materia.requisito}'),
            Text('Estado: ${materia.estado}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Materias Pendientes')),
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
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _materias.length,
                      itemBuilder: (context, index) {
                        final materia = _materias[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => _showMateriaDialog(context, materia),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        materia.codigo,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        materia.nombre,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchMaterias,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
