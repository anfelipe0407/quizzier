import 'package:quizzier/domain/entities/usuario.dart';
import 'package:quizzier/domain/repositories/usuario_repository.dart';

class AutenticarUsuario {
  final UsuarioRepository repository;

  AutenticarUsuario({required this.repository});

  Future<Usuario?> call(String nombre, String contrasena) {
    return repository.autenticarUsuario(nombre, contrasena);
  }
}
