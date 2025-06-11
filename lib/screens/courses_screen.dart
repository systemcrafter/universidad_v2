import 'package:flutter/material.dart';
import '../controllers/courses_controller.dart';
import '../models/materia_model.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Materia> _allMaterias = [];
  List<Materia> _materias = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMaterias();

    _searchController.addListener(_filterMaterias);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchMaterias() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await CoursesController.getMaterias();

    if (result['success']) {
      final materias = result['materias'] as List<Materia>;
      setState(() {
        _allMaterias = materias;
        _materias = materias;
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = result['message'] as String;
        _isLoading = false;
      });
    }
  }

  void _filterMaterias() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _materias = _allMaterias
          .where((materia) =>
              materia.nombre.toLowerCase().contains(query) ||
              materia.codigo.toLowerCase().contains(query))
          .toList();
    });
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
      appBar: AppBar(title: const Text('Materias')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Buscar materia',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _materias.isEmpty
                          ? const Center(
                              child: Text('No hay materias disponibles.'))
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
                                      onTap: () =>
                                          _showMateriaDialog(context, materia),
                                      child: Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                                style: const TextStyle(
                                                    fontSize: 14),
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
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchMaterias,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
