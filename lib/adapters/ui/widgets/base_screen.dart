import 'package:flutter/material.dart';
import 'package:quizzier/adapters/ui/widgets/custom_drawer.dart';

class BaseScreen extends StatelessWidget {
  final String title;
  final Widget body;

  const BaseScreen({Key? key, required this.title, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Color(0xFFEB5B00),
      ),
      drawer: const CustomDrawer(),
      body: body,
    );
  }
}
