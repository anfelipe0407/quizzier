import 'package:quizzier/domain/entities/usuario.dart';
import 'package:quizzier/domain/repositories/usuario_repository.dart';
import 'package:quizzier/infrastructure/data_source/json_local_data_source.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final JsonLocalDataSource dataSource;

  UsuarioRepositoryImpl({required this.dataSource});

  @override
  Future<Usuario?> autenticarUsuario(String nombre, String contrasena) async {
    final usuarios = await dataSource.cargarUsuarios();

    // Encuentra el usuario o devuelve null si no existe
    for (var usuario in usuarios) {
      if (usuario.nombre == nombre && usuario.contrasena == contrasena) {
        return usuario;
      }
    }

    return null; // Si no se encuentra, devuelve null
  }
}
