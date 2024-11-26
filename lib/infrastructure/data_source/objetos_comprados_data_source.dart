import 'package:shared_preferences/shared_preferences.dart';

class ObjetoCompradoDataSource {
  static const _objetosCompradosKey = 'objetos_comprados';

  // Guardar un objeto comprado
  Future<void> guardarObjetoComprado(int id, String nombre) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> objetos = prefs.getStringList(_objetosCompradosKey) ?? [];
    
    // Crear un mapa con id y nombre del objeto
    final objeto = '$id,$nombre'; // id y nombre separados por coma
    objetos.add(objeto);

    await prefs.setStringList(_objetosCompradosKey, objetos);
  }

  // Obtener todos los objetos comprados
  Future<List<Map<String, String>>> obtenerObjetosComprados() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> objetos = prefs.getStringList(_objetosCompradosKey) ?? [];

    return objetos.map((objeto) {
      final parts = objeto.split(',');
      return {'id': parts[0], 'nombre': parts[1]};
    }).toList();
  }

  // Verificar si un objeto ha sido comprado por su id
  Future<bool> esObjetoComprado(int id) async {
    final objetos = await obtenerObjetosComprados();
    return objetos.any((objeto) => objeto['id'] == id.toString());
  }
}
