import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quizzier/domain/entities/formulario.dart';

class GeminiApi {
  final String apiKey = 'YOUR_API_KEY'; // Reemplaza con tu clave de API

  Future<Formulario> generarFormulario(String tema, int cantidadPreguntas) async {
    try {
      final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=AIzaSyAPclgThCDmuZBmGKUGV30_rUXi0rIUQGQ',
      );

      final headers = {
        'Content-Type': 'application/json',
      };

      final prompt = '''
        Por favor, genera un cuestionario sobre el tema "$tema" en formato JSON. El cuestionario debe incluir:
        - Un campo "id" con un identificador único del cuestionario.
        - Un campo "tema" con el nombre del tema.
        - Un campo "preguntas", que es una lista de preguntas.
        Cada pregunta debe tener:
        - Un campo "id" con un identificador único.
        - Un campo "texto" con el texto de la pregunta.
        - Un campo "opciones", que es una lista de 4 opciones de respuesta.
        - Un campo "respuestaCorrecta" con el índice (de 0 a 3) de la opción correcta.

        El formulario debe contener $cantidadPreguntas preguntas.

        Ejemplo de formato esperado:
        {
          "formulario": {
            "id": "uuid",
            "tema": "tema del cuestionario",
            "preguntas": [
              {
                "id": "uuid",
                "texto": "¿Cuál es la capital de Francia?",
                "opciones": ["Madrid", "París", "Roma", "Berlín"],
                "respuestaCorrecta": 1
              }
            ]
          }
        }

        No le añadas intento de formateo de json ni al principio ni al final. Entregalo como un
        una linea contigua. Ejemplo: {"formulario":{"id":"uuid", "tema":"tema del cuestionario",}} ...etc
      ''';

      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      });

      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('RESPUESTA GEMINI: $data');
        return _parseFormulario(data, tema);
      } else {
        throw Exception(
            'Error al obtener las preguntas de Gemini API: ${response.body}');
      }
    } catch (e, stacktrace) {
      print('Error en generarFormulario: $e');
      print('Stacktrace: $stacktrace');
      rethrow;
    }
  }

  Formulario _parseFormulario(Map<String, dynamic> data, String tema) {
    // Extraemos el contenido del JSON de la respuesta
    final formularioJson = jsonDecode(
      data['candidates'][0]['content']['parts'][0]['text'],
    )['formulario'];

    // Convertimos cada pregunta del JSON en una instancia de Pregunta
    final preguntas = (formularioJson['preguntas'] as List).map((preguntaJson) {
      return Pregunta(
        id: preguntaJson['id'],
        texto: preguntaJson['texto'],
        opciones: List<String>.from(preguntaJson['opciones']),
        respuestaCorrecta: preguntaJson['respuestaCorrecta'],
      );
    }).toList();

    // Retornamos el formulario completo
    return Formulario(
      id: formularioJson['id'],
      tema: formularioJson['tema'],
      preguntas: preguntas,
    );
  }
}
