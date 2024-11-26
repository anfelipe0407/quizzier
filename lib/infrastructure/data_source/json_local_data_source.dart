import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quizzier/domain/entities/usuario.dart';

class JsonLocalDataSource {
  Future<List<Usuario>> cargarUsuarios() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/usuarios.json');
      final List<dynamic> jsonData = json.decode(jsonString);

      return jsonData
          .map((usuario) => Usuario(
                id: usuario['id'],
                nombre: usuario['nombre'],
                contrasena: usuario['contrasena'],
              ))
          .toList();
    } catch (e) {
      throw Exception('Error al cargar usuarios: $e');
    }
  }
}
