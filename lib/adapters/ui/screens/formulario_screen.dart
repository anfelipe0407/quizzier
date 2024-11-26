import 'package:flutter/material.dart';
import 'package:quizzier/adapters/ui/screens/resolver_formulario_screen.dart';
import 'package:quizzier/application/use_cases/crear_formulario.dart';
import 'package:quizzier/domain/entities/formulario.dart';
import 'package:quizzier/adapters/repository/formulario_repository_impl.dart';
import 'package:quizzier/infrastructure/api/gemini_api.dart';
import 'package:quizzier/adapters/ui/widgets/base_screen.dart';  // Importar BaseScreen

class FormularioScreen extends StatefulWidget {
  const FormularioScreen({Key? key}) : super(key: key);

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  late CrearFormulario _crearFormulario;
  List<Formulario> _formularios = [];
  final TextEditingController _temaController = TextEditingController();
  final TextEditingController _cantidadPreguntasController = TextEditingController();
  bool _isLoading = false;  // Estado para manejar la carga

  @override
  void initState() {
    super.initState();
    final repository = FormularioRepositoryImpl();
    final api = GeminiApi();
    _crearFormulario = CrearFormulario(repository: repository, api: api);
    _cargarFormularios();
  }

  Future<void> _cargarFormularios() async {
    final repository = FormularioRepositoryImpl();
    final formularios = await repository.obtenerFormularios();

    setState(() {
      _formularios = formularios;
    });
  }

  Future<void> _crearNuevoFormulario() async {
    final tema = _temaController.text;
    final cantPreguntas = int.tryParse(_cantidadPreguntasController.text);

    if (tema.isEmpty || cantPreguntas == null) {
      return;
    }

    setState(() {
      _isLoading = true;  // Inicia la carga
    });

    try {
      final nuevoFormulario = await _crearFormulario.call(tema, cantPreguntas);
      setState(() {
        _formularios.add(nuevoFormulario);
      });
    } catch (e) {
      // Maneja el error si es necesario
      print("Error al crear formulario: $e");
    } finally {
      setState(() {
        _isLoading = false;  // Detiene la carga
      });
    }

    _temaController.clear();
    _cantidadPreguntasController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Quizzier: Formularios',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Nuevo formulario",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF640D5F), // Violeta
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _temaController,
                        decoration: InputDecoration(
                          labelText: 'Tema del formulario',
                          labelStyle: TextStyle(color: Color(0xFF640D5F)), // Violeta
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFEB5B00)), // Naranja
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cantidadPreguntasController,
                        decoration: InputDecoration(
                          labelText: 'Número de preguntas',
                          labelStyle: TextStyle(color: Color(0xFF640D5F)), // Violeta
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFEB5B00)), // Naranja
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _crearNuevoFormulario,  // Deshabilita el botón mientras carga
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFEB5B00), // Naranja
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text('Crear', style: TextStyle(fontSize: 16)),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _formularios.length,
              itemBuilder: (context, index) {
                final formulario = _formularios[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Color(0xFFF9F9F9), // Color claro para las tarjetas
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Color(0xFFEB5B00)), // Naranja
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      formulario.tema,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF640D5F), // Violeta
                      ),
                    ),
                    subtitle: Text(
                      '${formulario.preguntas.length} preguntas',
                      style: TextStyle(color: Color(0xFFD91656)), // Rojo
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResolverFormularioScreen(
                            formulario: formulario,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
