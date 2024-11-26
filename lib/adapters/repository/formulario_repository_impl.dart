import 'dart:convert';
import 'dart:io';

import 'package:quizzier/domain/entities/formulario.dart';
import 'package:quizzier/domain/repositories/formulario_repository.dart';
import 'package:path_provider/path_provider.dart';

class FormularioRepositoryImpl implements FormularioRepository {
  @override
  Future<void> guardarFormulario(Formulario formulario) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/formularios.json');

    final List<Formulario> formularios = await obtenerFormularios();
    formularios.add(formulario);

    final jsonString = jsonEncode(formularios.map((f) => _toJson(f)).toList());
    await file.writeAsString(jsonString);
  }

  @override
  Future<List<Formulario>> obtenerFormularios() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/formularios.json');

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(jsonString);
        return jsonData.map((f) => _fromJson(f)).toList();
      }
    } catch (_) {
      // Manejo básico de errores
    }

    return [];
  }

  // Convertir Formulario a JSON
  Map<String, dynamic> _toJson(Formulario formulario) {
    return {
      'id': formulario.id,
      'tema': formulario.tema,
      'preguntas': formulario.preguntas.map((p) => {
            'id': p.id,
            'texto': p.texto,
            'opciones': p.opciones,
            'respuestaCorrecta': p.respuestaCorrecta,
          }).toList(),
    };
  }

  // Convertir JSON a Formulario
  Formulario _fromJson(Map<String, dynamic> json) {
    return Formulario(
      id: json['id'],
      tema: json['tema'],
      preguntas: (json['preguntas'] as List<dynamic>)
          .map((p) => Pregunta(
                id: p['id'],
                texto: p['texto'],
                opciones: List<String>.from(p['opciones']),
                respuestaCorrecta: p['respuestaCorrecta'],
              ))
          .toList(),
    );
  }
}
