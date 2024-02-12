import 'package:flutter/material.dart';

class OrigemScreen extends StatelessWidget {
  const OrigemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title:const Text('CRUD Origem'),
        ),
        body: const Center(
          child: Text('Conteúdo do CRUD'),
        ),
      ),
    );
  }
}