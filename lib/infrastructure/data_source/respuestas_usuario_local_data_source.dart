import 'package:shared_preferences/shared_preferences.dart';

class RespuestasUsuarioLocalDataSource {
  // Guardar las respuestas del usuario y si fueron correctas
  Future<void> guardarRespuestasUsuario(String formularioId, Map<int, int> respuestas, Map<int, bool> respuestasCorrectas) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Guardar respuestas
    final respuestasJson = respuestas.entries.map((entry) {
      return '${entry.key}:${entry.value}';
    }).join(',');
    await prefs.setString('respuestas_$formularioId', respuestasJson);

    // Guardar si las respuestas fueron correctas
    final respuestasCorrectasJson = respuestasCorrectas.entries.map((entry) {
      return '${entry.key}:${entry.value}';
    }).join(',');
    await prefs.setString('respuestas_correctas_$formularioId', respuestasCorrectasJson);
  }

  // Obtener las respuestas del usuario
  Future<Map<int, int>> obtenerRespuestasUsuario(String formularioId) async {
    final prefs = await SharedPreferences.getInstance();
    final respuestasJson = prefs.getString('respuestas_$formularioId');
    if (respuestasJson == null) return {};

    final respuestasMap = <int, int>{};
    final respuestasList = respuestasJson.split(',');
    for (var respuesta in respuestasList) {
      final partes = respuesta.split(':');
      if (partes.length == 2) {
        respuestasMap[int.parse(partes[0])] = int.parse(partes[1]);
      }
    }
    return respuestasMap;
  }

  // Obtener las respuestas correctas (true o false)
  Future<Map<int, bool>> obtenerRespuestasCorrectas(String formularioId) async {
    final prefs = await SharedPreferences.getInstance();
    final respuestasCorrectasJson = prefs.getString('respuestas_correctas_$formularioId');
    if (respuestasCorrectasJson == null) return {};

    final respuestasCorrectasMap = <int, bool>{};
    final respuestasCorrectasList = respuestasCorrectasJson.split(',');
    for (var respuesta in respuestasCorrectasList) {
      final partes = respuesta.split(':');
      if (partes.length == 2) {
        respuestasCorrectasMap[int.parse(partes[0])] = partes[1] == 'true';
      }
    }
    return respuestasCorrectasMap;
  }
}

