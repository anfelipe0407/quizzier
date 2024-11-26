import 'package:shared_preferences/shared_preferences.dart';

class PuntuacionLocalDataSource {
  static const _puntajeKey = 'puntaje_global';

  Future<int> obtenerPuntajeGlobal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_puntajeKey) ?? 0; // Retorna 0 si no existe aún
  }

  Future<void> actualizarPuntajeGlobal(int puntos) async {
    final prefs = await SharedPreferences.getInstance();
    final puntajeActual = await obtenerPuntajeGlobal();
    await prefs.setInt(_puntajeKey, puntajeActual + puntos);
  }
}
