import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProducaoScreen extends StatelessWidget {
  const ProducaoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Proposlisando APP - PRODUÇÃO'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: CrudProducao(),
        ),
      ),
    );
  }
}

class CrudProducao extends StatefulWidget {
  const CrudProducao({super.key});

  @override
  ProducaoState createState() => ProducaoState();
}

class ProducaoState extends State<CrudProducao> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _numberBox = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _numberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Número da caixa'),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _numberBox,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(labelText: 'Número de caixas produzidas'),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: _cadastrarDados,
            child: const Text('CADASTRAR'),
          ),
        ],
      ),
    );
  }

  void _cadastrarDados() {
    String number = _numberController.text;
    int numberBox = int.tryParse(_numberBox.text) ?? 0;

    FirebaseFirestore.instance.collection('Banco de dados de apicultores').add({
      'numero_caixa': number,
      'quantidade_produzida': numberBox,
    }).then((value) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sucesso'),
            content: Text('Dados cadastrados com sucesso!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Erro ao cadastrar dados: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }
}
