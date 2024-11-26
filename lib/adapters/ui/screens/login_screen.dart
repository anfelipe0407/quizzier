import 'package:flutter/material.dart';
import 'package:quizzier/application/use_cases/autenticar_usuario.dart';
import 'package:quizzier/infrastructure/data_source/json_local_data_source.dart';
import 'package:quizzier/adapters/repository/usuario_repository_impl.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  late AutenticarUsuario _autenticarUsuario;

  @override
  void initState() {
    super.initState();
    final dataSource = JsonLocalDataSource();
    final repository = UsuarioRepositoryImpl(dataSource: dataSource);
    _autenticarUsuario = AutenticarUsuario(repository: repository);
  }

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final usuario = await _autenticarUsuario.call(username, password);

    if (usuario != null) {
      Navigator.pushReplacementNamed(context, '/formulario');
    } else {
      setState(() {
        _errorMessage = 'Usuario o contraseña incorrectos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar sesión'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
