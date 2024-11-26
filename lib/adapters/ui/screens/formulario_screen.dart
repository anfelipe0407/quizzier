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

    final nuevoFormulario = await _crearFormulario.call(tema, cantPreguntas);
    setState(() {
      _formularios.add(nuevoFormulario);
    });

    _temaController.clear();
    _cantidadPreguntasController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Formularios',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text("Nuevo formulario"),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _temaController,
                        decoration: const InputDecoration(
                          labelText: 'Tema del formulario',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cantidadPreguntasController,
                        decoration: const InputDecoration(
                          labelText: 'Número de preguntas',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _crearNuevoFormulario,
                        child: const Text('Crear'),
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
                  child: ListTile(
                    title: Text(formulario.tema),
                    subtitle: Text('${formulario.preguntas.length} preguntas'),
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

  // Mostrar el formulario con las preguntas obtenidas
  void _mostrarFormulario(Formulario formulario) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Formulario: ${formulario.tema}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: formulario.preguntas.map((pregunta) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pregunta.texto),
                  ...pregunta.opciones.map((opcion) {
                    return RadioListTile<int>(
                      title: Text(opcion),
                      value: pregunta.opciones.indexOf(opcion),
                      groupValue: pregunta.respuestaCorrecta,
                      onChanged: null, // No permitimos cambiar la respuesta aún
                    );
                  }).toList(),
                ],
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
