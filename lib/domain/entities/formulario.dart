import 'package:uuid/uuid.dart';

class Formulario {
  final String id;
  final String tema;
  final List<Pregunta> preguntas;

  Formulario({
    required this.id,
    required this.tema,
    required this.preguntas,
  });
}

class Pregunta {
  final String id;
  final String texto;
  final List<String> opciones;
  final int respuestaCorrecta;

  Pregunta({
    required this.id,
    required this.texto,
    required this.opciones,
    required this.respuestaCorrecta,
  });
}

// Helper para crear IDs únicos
String generarUUID() => const Uuid().v4();
