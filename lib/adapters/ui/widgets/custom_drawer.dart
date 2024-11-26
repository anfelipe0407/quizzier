import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFEB5B00),
            ),
            child: const Text(
              'Menú de opciones',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Formularios'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/formulario');
            },
          ),
          ListTile(
            leading: const Icon(Icons.score),
            title: const Text('Puntuaciones'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/puntuaciones');
            },
          ),
        ],
      ),
    );
  }
}
