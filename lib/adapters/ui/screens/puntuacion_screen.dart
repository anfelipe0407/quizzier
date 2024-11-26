import 'package:flutter/material.dart';
import 'package:quizzier/adapters/ui/widgets/base_screen.dart';
import 'package:quizzier/infrastructure/data_source/puntuacion_local_data_source.dart';

class PuntuacionScreen extends StatefulWidget {
  const PuntuacionScreen({Key? key}) : super(key: key);

  @override
  State<PuntuacionScreen> createState() => _PuntuacionScreenState();
}

class _PuntuacionScreenState extends State<PuntuacionScreen> {
  final PuntuacionLocalDataSource _puntuacionLocalDataSource =
      PuntuacionLocalDataSource();
  int _puntajeGlobal = 0;

  @override
  void initState() {
    super.initState();
    _cargarPuntaje();
  }

  Future<void> _cargarPuntaje() async {
    final puntaje = await _puntuacionLocalDataSource.obtenerPuntajeGlobal();
    setState(() {
      _puntajeGlobal = puntaje;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Puntuaciones',
      body: Center(
        child: Text(
          'Puntaje Global: $_puntajeGlobal',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
