import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EntrepostoScreen extends StatelessWidget {
  const EntrepostoScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Proposlisando APP - ENTREPOSTO DE VENDAS',
            style: TextStyle(fontSize: 17.7),),
          backgroundColor: Colors.green, // Cor de fundo da appbar
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: CrudEntreposto(),
        ),
        backgroundColor: Colors.grey[200], // Cor de fundo do Scaffold
      ),
    );
  }
}

class CrudEntreposto extends StatefulWidget {
  const CrudEntreposto({Key? key});

  @override
  _CrudEntrepostoState createState() => _CrudEntrepostoState();
}

class _CrudEntrepostoState extends State<CrudEntreposto> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            onPressed: _cadastrarDados,
            child: const Text('CADASTRAR'),
            style: ElevatedButton.styleFrom(
              primary: Colors.green, // Cor de fundo do botão
              onPrimary: Colors.white, // Cor do texto do botão
              padding: const EdgeInsets.symmetric(vertical: 16), // Espaçamento interno do botão
            ),
          ),
        ],
      ),
    );
  }

  void _cadastrarDados() {
    String name = _nameController.text;
    String cpf = _cpfController.text;

    if (!validarCPF(_cpfController)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('CPF inválido!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    FirebaseFirestore.instance.collection('dadosEntreposto').add({
      'nome': name,
      'cpf': cpf,
    }).then((value) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sucesso'),
            content: const Text('Dados cadastrados com sucesso!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
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
            title: const Text('Erro'),
            content: Text('Erro ao cadastrar dados: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }

  bool validarCPF(TextEditingController _cpfController) {
    String cpf = _cpfController.text;

    if (cpf.length != 11) {
      return false;
    }

    List<int> digitos =
        cpf.runes.map((rune) => int.parse(String.fromCharCode(rune))).toList();

    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += digitos[i] * (10 - i);
    }
    int primeiroDigito = 11 - (soma % 11);
    primeiroDigito = (primeiroDigito >= 10) ? 0 : primeiroDigito;

    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += digitos[i] * (11 - i);
    }
    int segundoDigito = 11 - (soma % 11);
    segundoDigito = (segundoDigito >= 10) ? 0 : segundoDigito;

    return primeiroDigito == digitos[9] && segundoDigito == digitos[10];
  }
}
