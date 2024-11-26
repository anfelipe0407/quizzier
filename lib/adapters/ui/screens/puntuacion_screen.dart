import 'package:flutter/material.dart';
import 'package:quizzier/adapters/ui/widgets/base_screen.dart';
import 'package:quizzier/infrastructure/data_source/json_objetos_data_source.dart';
import 'package:quizzier/infrastructure/data_source/objetos_comprados_data_source.dart';
import 'package:quizzier/infrastructure/data_source/puntuacion_local_data_source.dart';
import 'package:quizzier/domain/entities/objeto.dart';

class PuntuacionScreen extends StatefulWidget {
  const PuntuacionScreen({Key? key}) : super(key: key);

  @override
  State<PuntuacionScreen> createState() => _PuntuacionScreenState();
}

class _PuntuacionScreenState extends State<PuntuacionScreen> {
  final PuntuacionLocalDataSource _puntuacionLocalDataSource =
      PuntuacionLocalDataSource();
  final ObjetoCompradoDataSource _objetoCompradoDataSource =
      ObjetoCompradoDataSource();
  final JsonObjetosDataSource _jsonLocalDataSource = JsonObjetosDataSource();

  int _puntajeGlobal = 0;
  List<Objeto> objetosTienda = [];

  @override
  void initState() {
    super.initState();
    _cargarPuntaje();
    _cargarObjetos();
  }

  Future<void> _cargarPuntaje() async {
    final puntaje = await _puntuacionLocalDataSource.obtenerPuntajeGlobal();
    setState(() {
      _puntajeGlobal = puntaje;
    });
  }

  Future<void> _cargarObjetos() async {
    try {
      final objetos = await _jsonLocalDataSource.cargarObjetos();
      setState(() {
        objetosTienda = objetos;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los objetos: $e')),
      );
    }
  }

  Future<void> _comprarObjeto(int id, String nombre, int precio) async {
    if (_puntajeGlobal >= precio) {
      bool? confirmacion = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmación de compra'),
            content: Text('¿Deseas comprar $nombre por $precio puntos?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Comprar'),
              ),
            ],
          );
        },
      );

      if (confirmacion == true) {
        await _puntuacionLocalDataSource.actualizarPuntajeGlobal(-precio);
        await _objetoCompradoDataSource.guardarObjetoComprado(id, nombre);

        setState(() {
          _cargarPuntaje();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Has comprado $nombre!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No tienes suficiente puntaje para comprar $nombre.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colores de la paleta
    Color violeta = Color(0xFF640D5F);
    Color fucsia = Color(0xFFD91656);
    Color naranja = Color(0xFFEB5B00);
    // Color amarillo = Color(0xFFFFB200);

    return BaseScreen(
      title: 'Quizzier: Puntuaciones',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Puntaje Global: $_puntajeGlobal',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: violeta,  // Cambié el color del texto
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Objetos de la Tienda',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: fucsia,  // Cambié el color del título
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: objetosTienda.isEmpty
                  ? Center(child: CircularProgressIndicator(color: naranja)) // Color del cargando
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: objetosTienda.length,
                      itemBuilder: (context, index) {
                        final objeto = objetosTienda[index];
                        return FutureBuilder<bool>(
                          future: _objetoCompradoDataSource.esObjetoComprado(objeto.id),
                          builder: (context, snapshot) {
                            bool comprado = snapshot.data ?? false;
                            return GestureDetector(
                              onTap: () {
                                if (!comprado) {
                                  _comprarObjeto(
                                    objeto.id,
                                    objeto.nombre,
                                    objeto.precio,
                                  );
                                }
                              },
                              child: Card(
                                color: comprado ? Color(0xFF5CB85C) : null,  // Color verde cuando comprado
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      objeto.imagen,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      objeto.nombre,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: violeta,  // Cambié el color del nombre del objeto
                                      ),
                                    ),
                                    Text(
                                      '${objeto.precio} puntos',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: naranja,  // Cambié el color del precio
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
