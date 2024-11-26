import 'package:flutter/material.dart';
import 'package:quizzier/domain/entities/formulario.dart';
import 'package:quizzier/infrastructure/data_source/puntuacion_local_data_source.dart';
import 'package:quizzier/infrastructure/data_source/respuestas_usuario_local_data_source.dart';

class ResolverFormularioScreen extends StatefulWidget {
  final Formulario formulario;

  const ResolverFormularioScreen({Key? key, required this.formulario})
      : super(key: key);

  @override
  State<ResolverFormularioScreen> createState() =>
      _ResolverFormularioScreenState();
}

class _ResolverFormularioScreenState extends State<ResolverFormularioScreen> {
  final Map<int, int> _respuestasUsuario = {};
  final Map<int, bool> _respuestasCorrectas = {};
  final RespuestasUsuarioLocalDataSource _respuestasUsuarioLocalDataSource = RespuestasUsuarioLocalDataSource();
  final PuntuacionLocalDataSource _puntuacionLocalDataSource = PuntuacionLocalDataSource();
  bool _yaRespondido = false;

  @override
  void initState() {
    super.initState();
    _cargarRespuestas();
  }

  Future<void> _cargarRespuestas() async {
    final respuestas = await _respuestasUsuarioLocalDataSource.obtenerRespuestasUsuario(widget.formulario.id);
    final respuestasCorrectas = await _respuestasUsuarioLocalDataSource.obtenerRespuestasCorrectas(widget.formulario.id);
    if (respuestas.isNotEmpty) {
      setState(() {
        _respuestasUsuario.addAll(respuestas);
        _respuestasCorrectas.addAll(respuestasCorrectas);
        _yaRespondido = true;  // Si ya hay respuestas, se marca como respondido
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formulario = widget.formulario;

    return Scaffold(
      appBar: AppBar(
        title: Text('Resolver: ${formulario.tema}'),
      ),
      body: ListView.builder(
        itemCount: formulario.preguntas.length,
        itemBuilder: (context, index) {
          final pregunta = formulario.preguntas[index];
          final respuestaCorrecta = _respuestasCorrectas[index] ?? false;
          final colorCard = respuestaCorrecta ? Colors.green : Colors.red;

          return Card(
            color: colorCard, // Cambiar el color de la tarjeta
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pregunta #${index + 1}: ${pregunta.texto}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...pregunta.opciones.asMap().entries.map((entry) {
                    final opcionIndex = entry.key;
                    final opcion = entry.value;

                    return RadioListTile<int>(
                      title: Text(opcion),
                      value: opcionIndex,
                      groupValue: _respuestasUsuario[index],
                      onChanged: _yaRespondido
                          ? null  // Deshabilitar la opción si ya ha respondido
                          : (value) {
                              setState(() {
                                _respuestasUsuario[index] = value!;
                                _respuestasCorrectas[index] = value == pregunta.respuestaCorrecta;
                              });
                            },
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: _yaRespondido
          ? null // Si ya ha respondido, ocultar el botón
          : FloatingActionButton(
              onPressed: _enviarRespuestas,
              child: const Icon(Icons.check),
            ),
    );
  }

  void _enviarRespuestas() async {
    final totalCorrectas = widget.formulario.preguntas.where((pregunta) {
      final index = widget.formulario.preguntas.indexOf(pregunta);
      final respuestaUsuario = _respuestasUsuario[index];
      return respuestaUsuario == pregunta.respuestaCorrecta;
    }).length;

    // Guardar las respuestas del usuario y si fueron correctas
    await _respuestasUsuarioLocalDataSource.guardarRespuestasUsuario(
        widget.formulario.id, _respuestasUsuario, _respuestasCorrectas);

    // Actualizar puntaje global
    await _puntuacionLocalDataSource.actualizarPuntajeGlobal(totalCorrectas * 100);

    // Mostrar resultados y redirigir
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Resultados'),
          content: Text(
              'Respondiste correctamente $totalCorrectas de ${widget.formulario.preguntas.length} preguntas. \n ¡Obtuviste ${totalCorrectas * 100} puntos'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
                Navigator.pushReplacementNamed(context, '/formulario'); // Redirigir
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
