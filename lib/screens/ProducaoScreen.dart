import 'package:flutter/material.dart';

class ProducaoScreen extends StatelessWidget {
  const ProducaoScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title:const Text('CRUD Produção'),
        ),
        body: const Center(
          child: Text('Conteúdo do CRUD'),
        ),
      ),
    );
  }
}