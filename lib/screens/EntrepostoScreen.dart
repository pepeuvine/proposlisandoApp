import 'package:flutter/material.dart';

class EntrepostoScreen extends StatelessWidget {
  const EntrepostoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title:const Text('CRUD Entreposto de Vendas'),
        ),
        body: const Center(
          child: Text('Conteúdo do CRUD'),
        ),
      ),
    );
  }
}