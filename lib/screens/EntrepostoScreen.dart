import 'package:flutter/material.dart';

class EntrepostoScreen extends StatelessWidget {
  const EntrepostoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ENTREPOSTO DE VENDAS'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: CrudEntreposto(),
        ),
      ),
    );
  }
}

class CrudEntreposto extends StatefulWidget {
  const CrudEntreposto({super.key});

  @override
  EntrepostoState createState() => EntrepostoState();
}

class EntrepostoState extends State<CrudEntreposto> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _nameController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _cpfController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'CPF'),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('CADASTRAR'),
          ),
        ],
      ),
    );
  }
}
