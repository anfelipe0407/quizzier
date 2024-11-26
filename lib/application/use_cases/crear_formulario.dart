import 'package:quizzier/domain/entities/formulario.dart';
import 'package:quizzier/domain/repositories/formulario_repository.dart';
import 'package:quizzier/infrastructure/api/gemini_api.dart';

class CrearFormulario {
  final FormularioRepository repository;
  final GeminiApi api;

  CrearFormulario({required this.repository, required this.api});

  Future<Formulario> call(String tema, int cantidadPreguntas) async {
    // La API ahora devuelve un formulario completo
    final nuevoFormulario = await api.generarFormulario(tema, cantidadPreguntas);

    // Guardamos el formulario completo en el repositorio
    await repository.guardarFormulario(nuevoFormulario);

    return nuevoFormulario; // Retornamos el formulario generado y guardado
  }
}
