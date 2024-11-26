import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quizzier/domain/entities/objeto.dart';

class JsonObjetosDataSource {
  // Cargar los objetos de la tienda desde el archivo JSON
  Future<List<Objeto>> cargarObjetos() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/objetos.json');
      final List<dynamic> jsonData = json.decode(jsonString);

      return jsonData.map((objetoJson) => Objeto.fromJson(objetoJson)).toList();
    } catch (e) {
      throw Exception('Error al cargar objetos: $e');
    }
  }
}
