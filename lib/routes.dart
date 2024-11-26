import 'package:flutter/material.dart';
import 'package:quizzier/adapters/ui/screens/login_screen.dart';
import 'package:quizzier/adapters/ui/screens/formulario_screen.dart';
import 'package:quizzier/adapters/ui/screens/puntuacion_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const LoginScreen(),
      '/formulario': (context) => const FormularioScreen(),
      '/puntuaciones': (context) => const PuntuacionScreen(),
    };
  }
}
