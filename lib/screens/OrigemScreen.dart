import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrigemScreen extends StatelessWidget {
  const OrigemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Proposlisando APP - ORIGEM'),
          backgroundColor: Colors.amber, // Cor de fundo da appbar
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CrudOrigem(),
          ),
        backgroundColor: Colors.grey[200], // Cor de fundo do Scaffold
      ),
    );
  }
}

class CrudOrigem extends StatefulWidget {
  const CrudOrigem({super.key});

  @override
  OrigemState createState() => OrigemState();
}

class OrigemState extends State<CrudOrigem> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _vegetacaoController = TextEditingController();
  final TextEditingController _terraController = TextEditingController();

  final vegetacaoOpcoes = [
    'Mata de Cocais',
    'Mangues',
    'Floresta Amazônica',
    'Cerrado'
  ];

  final terraOpcoes = ['Seca', 'Arenosa', 'Úmida'];
  String _dropdownvalue = 'Mata de Cocais';
  String _dropdownvalue2 = 'Seca';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Número da Caixa'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _linkController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                  labelText: 'Link do Georeferenciamento'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _dateController,
              onTap: () => _selectDate(_dateController),
              decoration: const InputDecoration(
                labelText: 'Data da Coleta',
                filled: true,
                prefixIcon: Icon(Icons.calendar_today),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Tipo de Vegetação",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton(
              items: vegetacaoOpcoes.map((String item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _dropdownvalue = newValue!;
                  _vegetacaoController.text = newValue;
                });
              },
              value: _dropdownvalue,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _distanceController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Distância até o Rio em KM'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Tipo de Terra",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton(
              items: terraOpcoes.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _dropdownvalue2 = newValue!;
                });
              },
              value: _dropdownvalue2,
            ),
            ElevatedButton(
              onPressed: _cadastrarDados,
              child: const Text('CADASTRAR'),
              style: ElevatedButton.styleFrom(
                primary: Colors.amber, // Cor de fundo do botão
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
                _exibirDadosPorNumeroCaixa(_numberController.text);
              },
              child: const Text('BUSCAR'),
            ),
          ],
        ),
      ),
    );
  }

//Função para pegar a data
  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      String formattedDate = "${picked.day}/${picked.month}/${picked.year}";
      controller.text = formattedDate;
    }
  }

//FUNÇÃO CADASTRO - FUNÇÃO CADASTRO - FUNÇÃO CADASTRO - FUNÇÃO CADASTRO - FUNÇÃO CADASTRO - FUNÇÃO CADASTRO
  void _cadastrarDados() {
    String number = _numberController.text;
    String link = _linkController.text;
    String date = _dateController.text;
    String distance = _distanceController.text;

    FirebaseFirestore.instance.collection('Dados ORIGEM').add({
      'numero_caixa': number,
      'link_georeferenciamento': link,
      'data_coleta': date,
      'tipo_vegetacao': _dropdownvalue,
      'distancia_rio_km': distance,
      'tipo_terra': _dropdownvalue2,
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

//FUNÇÃO BUSCA - FUNÇÃO BUSCA  - FUNÇÃO BUSCA - FUNÇÃO BUSCA - FUNÇÃO BUSCA - FUNÇÃO BUSCA - FUNÇÃO BUSCA - FUNÇÃO BUSCA
  Future<List<DocumentSnapshot>> _buscarDadosPorNumeroCaixa(
      String numeroCaixa) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Dados ORIGEM')
        .where('numero_caixa', isEqualTo: numeroCaixa)
        .get();

    return querySnapshot.docs;
  }

  void _exibirDadosPorNumeroCaixa(String numeroCaixa) {
    _buscarDadosPorNumeroCaixa(numeroCaixa).then((docs) {
      if (docs.isEmpty) {
        // Código para exibir caixa não cadastrada
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Caixa Não Cadastrada'),
              content: const Text('A caixa informada não está cadastrada.'),
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
                    String numero_caixa = doc.get('numero_caixa') ?? '';
                    String link = doc.get('link_georeferenciamento') ?? '';
                    String data = doc.get('data_coleta') ?? '';
                    String tipoVegetacao = doc.get('tipo_vegetacao') ?? '';
                    String distanciaRio = doc.get('distancia_rio_km') ?? '';
                    String tipoTerra = doc.get('tipo_terra') ?? '';

                    return ListTile(
                      title: Text('Número da caixa: $numero_caixa'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Link: $link'),
                          Text('Data: $data'),
                          Text('Tipo de Vegetação: $tipoVegetacao'),
                          Text('Distância até o Rio: $distanciaRio'),
                          Text('Tipo de Terra: $tipoTerra'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              //_editarDado(documentId, numero_caixa, link, data,
                              //    tipoVegetacao, distanciaRio, tipoTerra);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
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
                                          _exibirDadosPorNumeroCaixa(
                                              numeroCaixa);
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

  //FUNÇÃO EXCLUIR - FUNÇÃO EXCLUIR - FUNÇÃO EXCLUIR - FUNÇÃO EXCLUIR - FUNÇÃO EXCLUIR - FUNÇÃO EXCLUIR

  void _excluirDado(String documentId) {
    FirebaseFirestore.instance
        .collection('Dados ORIGEM')
        .doc(documentId)
        .delete()
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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

// FUNÇÃO EDITAR

/*
  void _editarDado(
    String documentId,
    String numeroCaixa,
    String linkAtual,
    String dataAtual,
    String tipoVegetacaoAtual,
    String distanciaRioAtual,
    String tipoTerraAtual,
  ) {
    TextEditingController _numberController =
        TextEditingController(text: numeroCaixa);
    TextEditingController _linkController =
        TextEditingController(text: linkAtual);
    TextEditingController _dataController =
        TextEditingController(text: dataAtual);
    TextEditingController _distanciaRioController =
        TextEditingController(text: distanciaRioAtual);
    String _dropdownvalue = tipoVegetacaoAtual;
    String _dropdownvalue2 = tipoTerraAtual;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Editar Dado'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _numberController,
                      decoration:
                          const InputDecoration(labelText: 'Número da caixa'),
                    ),
                    TextField(
                      controller: _linkController,
                      decoration: const InputDecoration(labelText: 'Link'),
                    ),
                    TextField(
                      controller: _dataController,
                      onTap: () => _selectDate(_dataController),
                      decoration: const InputDecoration(
                        labelText: 'Data da Coleta',
                        filled: true,
                        prefixIcon: Icon(Icons.calendar_today),
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(),
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Tipo de Vegetação",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton(
                      items: vegetacaoOpcoes.map((String item) {
                        return DropdownMenuItem(value: item, child: Text(item));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropdownvalue = newValue!;
                        });
                      },
                      value: _dropdownvalue,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _distanciaRioController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Distância até o Rio em KM'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Tipo de Terra",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton(
                      items: terraOpcoes.map((String item) {
                        return DropdownMenuItem(value: item, child: Text(item));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropdownvalue2 = newValue!;
                        });
                      },
                      value: _dropdownvalue2,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('Dados ORIGEM')
                        .doc(documentId)
                        .update({
                      'numero_caixa': _numberController.text,
                      'link_georeferenciamento': _linkController.text,
                      'data_coleta': _dataController.text,
                      'tipo_vegetacao': _dropdownvalue,
                      'distancia_rio_km': _distanciaRioController.text,
                      'tipo_terra': _dropdownvalue2,
                    }).then((value) {
                      Navigator.of(context).pop();
                      _exibirDadosPorNumeroCaixa(numeroCaixa);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Dado atualizado com sucesso'),
                        ),
                      );
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao atualizar dado: $error'),
                        ),
                      );
                    });
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
*/
}
