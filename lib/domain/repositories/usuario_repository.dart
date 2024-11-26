import 'package:quizzier/domain/entities/usuario.dart';

abstract class UsuarioRepository {
  Future<Usuario?> autenticarUsuario(String nombre, String contrasena);
}
