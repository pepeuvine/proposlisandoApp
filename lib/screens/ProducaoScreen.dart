import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProducaoScreen extends StatelessWidget {
  const ProducaoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Proposlisando APP - PRODUÇÃO'),
            backgroundColor: Colors.grey,
          ),
          body: const Padding(
            padding: EdgeInsets.all(16.0),
            child: CrudProducao(),
          ),
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
  final TextEditingController _numberBoxController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _cpfController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'CPF'),
          ),
          TextField(
            controller: _numberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Número da caixa'),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _numberBoxController,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(labelText: 'Número de caixas produzidas'),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: _verificarNumeroCaixa,
            child: const Text('CADASTRAR'),
            style: ElevatedButton.styleFrom(
              primary: Colors.grey, // Cor de fundo do botão
              onPrimary: Colors.white, // Cor do texto do botão
              padding: EdgeInsets.symmetric(
                  vertical: 16), // Espaçamento interno do botão
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              _exibirDadosPorCpf(_cpfController.text);
            },
            child: const Text('BUSCAR'),
            style: ElevatedButton.styleFrom(
              primary: Colors.grey[300],
              onPrimary: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

//BANCO DE DADOS

  void _cadastrarDados() {
    String cpf = _cpfController.text.replaceAll(RegExp(r'[^\d]'), '');
    String number = _numberController.text;
    String numberBox = _numberBoxController.text;

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

    FirebaseFirestore.instance.collection('Dados PRODUÇÃO').add({
      'cpf': cpf,
      'numero_caixa': number,
      'quantidade_produzida': numberBox,
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

  void _excluirDado(String documentId) {
    FirebaseFirestore.instance
        .collection('Dados PRODUÇÃO')
        .doc(documentId)
        .delete()
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dado excluído com sucesso'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir dado: $error'),
        ),
      );
    });
  }

  Future<List<DocumentSnapshot>> _buscarDadosPorCpf(String cpf) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Dados PRODUÇÃO')
        .where('cpf', isEqualTo: cpf.replaceAll(RegExp(r'[^\d]'), ''))
        .get();

    return querySnapshot.docs;
  }

  void _exibirDadosPorCpf(String cpf) {
    _buscarDadosPorCpf(cpf).then((docs) {
      if (docs.isEmpty) {
        // Código para exibir caixa não cadastrada
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('CPF Não Cadastrado'),
              content: const Text('O CPF informado não está cadastrado.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Fechar'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Dados Encontrados'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: docs.map((doc) {
                    String documentId = doc.id;
                    String cpf = doc.get('cpf') ?? '';
                    String numeroCaixa = doc.get('numero_caixa') ?? '';
                    String quantidadeCaixa =
                        doc.get('quantidade_produzida').toString() ?? '';
                    String cpfFormatado = _cpfFormatado(cpf);

                    return ListTile(
                      title: Text('CPF: $cpfFormatado'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Número da Caixa: $numeroCaixa'),
                          Text('Quantidade Produzida: $quantidadeCaixa')
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _editarDado(documentId, cpf, numeroCaixa,
                                  quantidadeCaixa);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirmar Exclusão'),
                                    content: const Text(
                                        'Tem certeza que deseja excluir este dado?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          _excluirDado(documentId);
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          _exibirDadosPorCpf(cpf);
                                        },
                                        child: const Text('Sim'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Não'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Fechar'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  void _editarDado(String documentId, String cpf, String numeroCaixa,
      String quantidadeCaixa) {
    TextEditingController _cpfController = TextEditingController(text: cpf);
    TextEditingController _numberController =
        TextEditingController(text: numeroCaixa);
    TextEditingController _numberBoxController =
        TextEditingController(text: quantidadeCaixa);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Editar Dados'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _cpfController,
                      decoration: const InputDecoration(labelText: 'CPF'),
                    ),
                    TextField(
                      controller: _numberController,
                      decoration:
                          const InputDecoration(labelText: 'Número da Caixa'),
                    ),
                    TextField(
                      controller: _numberBoxController,
                      decoration: const InputDecoration(
                          labelText: 'Número de Caixas Produzidas'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
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
                    } else {
                      FirebaseFirestore.instance
                          .collection('Dados PRODUÇÃO')
                          .doc(documentId)
                          .update({
                        'cpf': _cpfController.text,
                        'numero_caixa': _numberController.text,
                        'quantidade_produzida': _numberBoxController.text,
                      }).then((value) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        _exibirDadosPorCpf(cpf);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Dados atualizado com sucesso'),
                          ),
                        );
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao atualizar dado: $error'),
                          ),
                        );
                      });
                    }
                  },
                  child: const Text('Salvar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

//VALIDAÇÕES
  String _cpfFormatado(String cpf) {
    return cpf.substring(0, 3) +
        '.' +
        cpf.substring(3, 6) +
        '.' +
        cpf.substring(6, 9) +
        '-' +
        cpf.substring(9);
  }

  void initState() {
    super.initState();
    _cpfController.addListener(_formatarCPF);
  }

  void _formatarCPF() {
    String cpf = _cpfController.text.replaceAll(RegExp(r'[^\d]'), '');

    if (cpf.length > 3) {
      cpf = cpf.substring(0, 3) + '.' + cpf.substring(3);
    }
    if (cpf.length > 7) {
      cpf = cpf.substring(0, 7) + '.' + cpf.substring(7);
    }
    if (cpf.length > 11) {
      cpf = cpf.substring(0, 11) + '-' + cpf.substring(11);
    }

    _cpfController.value = TextEditingValue(
      text: cpf,
      selection: TextSelection.collapsed(offset: cpf.length),
    );
  }

  void _verificarNumeroCaixa() {
    String number = _numberController.text;
    if (number.isEmpty ||
        int.tryParse(number) == null ||
        int.parse(number) <= 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Número da Caixa'),
            content: const Text(
                'Por favor, preencha o número da caixa com um número válido.'),
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

    FirebaseFirestore.instance
        .collection('Dados PRODUÇÃO')
        .where('numero_caixa', isEqualTo: number)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Número da Caixa'),
              content:
                  const Text('Já existe um cadastro com este número de caixa.'),
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
      } else {
        _verificarQuantidadeCaixa();
      }
    });
  }

  void _verificarQuantidadeCaixa() {
    String number = _numberBoxController.text;
    if (number.isEmpty ||
        int.tryParse(number) == null ||
        int.parse(number) <= 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Número de Caixa Produzidas'),
            content: const Text(
                'Por favor, preencha o número de caixas produzidas com um número válido.'),
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
    } else {
      _cadastrarDados();
    }
  }

  bool validarCPF(TextEditingController _cpfController) {
    String cpf = _cpfController.text.replaceAll(RegExp(r'[^\d]'), '');

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
