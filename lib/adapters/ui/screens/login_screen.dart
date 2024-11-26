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
        title: const Text('Iniciar sesión', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFFEB5B00), // Violeta
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen en la parte superior
            Image.asset(
              'assets/img/login_image.png', // Coloca tu imagen aquí
              height: 150,
              fit: BoxFit.cover,
            ),
            Text("QUIZZIER"),
            const SizedBox(height: 32),
            // Campo de usuario
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Usuario',
                labelStyle: TextStyle(color: Color(0xFF640D5F)), // Violeta
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEB5B00)), // Naranja
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Campo de contraseña
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                labelStyle: TextStyle(color: Color(0xFF640D5F)), // Violeta
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEB5B00)), // Naranja
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            // Botón de login
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEB5B00), // Naranja
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(fontSize: 16),
              ),
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
