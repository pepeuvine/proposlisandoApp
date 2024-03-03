// ignore_for_file: sort_child_properties_last, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class OrigemScreen extends StatelessWidget {
  const OrigemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Proposlisando APP - ORIGEM'),
            backgroundColor: Colors.amber, // Cor de fundo da appbar
          ),
          body: const Padding(
            padding: EdgeInsets.all(16.0),
            child: CrudOrigem(),
          ),
          backgroundColor: Colors.grey[200], // Cor de fundo do Scaffold
        ),
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
  final TextEditingController _cpfController = TextEditingController();

  final vegetacaoOpcoes = [
    'Caatinga',
    'Veg. Litorânea',
    'Floresta Amazônica',
    'Cerrado',
    'Não Identificada'
  ];

  final terraOpcoes = [
    'Arenoso',
    'Argiloso',
    'Humoso',
    'Calcário',
    'Não Identificado'
  ];

  final abelhaOpcoes = ['Com Ferrão', 'Sem Ferrão'];

  final nomeCientificoOpcoes = ['TUBI', 'ITALIANA'];

  String _valueVegetacao = 'Não Identificada';
  String _valueTerra = 'Não Identificado';
  String _valueAbelha = 'Com Ferrão';
  String _valueNomeCientifico = 'TUBI';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
              controller: _distanceController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Distância até o Rio em KM'),
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
                  _valueVegetacao = newValue!;
                  _vegetacaoController.text = newValue;
                });
              },
              value: _valueVegetacao,
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
                  _valueTerra = newValue!;
                });
              },
              value: _valueTerra,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Tipo de Abelha:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton(
              items: abelhaOpcoes.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _valueAbelha = newValue!;
                });
              },
              value: _valueAbelha,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Nome Científico: ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton(
              items: nomeCientificoOpcoes.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _valueNomeCientifico = newValue!;
                });
              },
              value: _valueNomeCientifico,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: _verificarNumeroCaixa,
              child: const Text('CADASTRAR'),
              style: ElevatedButton.styleFrom(
                primary: Colors.amber, // Cor de fundo do botão
                onPrimary: Colors.white, // Cor do texto do botão
                padding: const EdgeInsets.symmetric(
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
              child: const Text('BUSCAR POR CPF'),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[300],
                onPrimary: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
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
    String cpf = _cpfController.text.replaceAll(RegExp(r'[^\d]'), '');
    String number = _numberController.text;
    String link = _linkController.text;
    String date = _dateController.text;
    String distance = _distanceController.text;

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

    if (!isLinkValid(link)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Link Inválido'),
            content: const Text(
                'O link fornecido não é válido. Por favor, insira um link válido.'),
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
      return; // Sai da função sem cadastrar se o link for inválido
    }

    FirebaseFirestore.instance.collection('Dados ORIGEM').add({
      'cpf': cpf,
      'numero_caixa': number,
      'link_georeferenciamento': link,
      'data_coleta': date,
      'tipo_vegetacao': _valueVegetacao,
      'distancia_rio_km': distance,
      'tipo_terra': _valueTerra,
      'tipo_abelha': _valueAbelha,
      'tipo_nomeCientifico': _valueNomeCientifico
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

//FUNÇÃO BUSCA - FUNÇÃO BUSCA  - FUNÇÃO BUSCA - FUNÇÃO BUSCA - FUNÇÃO BUSCA - FUNÇÃO BUSCA - FUNÇÃO BUSCA - FUNÇÃO BUSCA
  Future<List<DocumentSnapshot>> _buscarDadosPorCpf(String cpf) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Dados ORIGEM')
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
                    String numero_caixa = doc.get('numero_caixa') ?? '';
                    String link = doc.get('link_georeferenciamento') ?? '';
                    String data = doc.get('data_coleta') ?? '';
                    String tipoVegetacao = doc.get('tipo_vegetacao') ?? '';
                    String distanciaRio = doc.get('distancia_rio_km') ?? '';
                    String tipoTerra = doc.get('tipo_terra') ?? '';
                    String tipoAbelha = doc.get('tipo_abelha') ?? '';
                    String tipoNomeCientifico =
                        doc.get('tipo_nomeCientifico') ?? '';
                    String cpfFormatado = _cpfFormatado(cpf);

                    return ListTile(
                      title: Text('CPF: $cpfFormatado'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Número da Caixa: $numero_caixa'),
                          const Text(
                            'Link: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .blue, // Cor azul para indicar que é um link clicável
                              decoration: TextDecoration
                                  .underline, // Sublinhado para indicar que é um link clicável
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (await canLaunch(link)) {
                                await launch(link);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Erro'),
                                      content: const Text(
                                          'Não foi possível abrir o link.'),
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
                              }
                            },
                            child: Text(
                              link,
                              style: const TextStyle(
                                color: Colors
                                    .blue, // Cor azul para indicar que é um link clicável
                                decoration: TextDecoration
                                    .underline, // Sublinhado para indicar que é um link clicável
                              ),
                            ),
                          ),
                          //Text('Link: $link'),
                          Text('Distância até o Rio: $distanciaRio'),
                          Text('Data da Coleta: $data'),
                          Text('Tipo de Vegetação: $tipoVegetacao'),
                          Text('Tipo de Terra: $tipoTerra'),
                          Text('Tipo de Abelha: $tipoAbelha'),
                          Text('Nome Científico: $tipoNomeCientifico'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _editarDado(
                                  documentId,
                                  cpf,
                                  numero_caixa,
                                  link,
                                  data,
                                  tipoVegetacao,
                                  distanciaRio,
                                  tipoTerra,
                                  tipoAbelha,
                                  tipoNomeCientifico);
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

  //FUNÇÃO EXCLUIR - FUNÇÃO EXCLUIR - FUNÇÃO EXCLUIR - FUNÇÃO EXCLUIR - FUNÇÃO EXCLUIR - FUNÇÃO EXCLUIR

  void _excluirDado(String documentId) {
    FirebaseFirestore.instance
        .collection('Dados ORIGEM')
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

//FUNÇÃO EDITAR - FUNÇÃO EDITAR - FUNÇÃO EDITAR - FUNÇÃO EDITAR - FUNÇÃO EDITAR - FUNÇÃO EDITAR - FUNÇÃO EDITAR

  void _editarDado(
      String documentId,
      String cpf,
      String numeroCaixa,
      String linkAtual,
      String dataAtual,
      String tipoVegetacaoAtual,
      String distanciaRioAtual,
      String tipoTerraAtual,
      String tipoAbelha,
      String tipoNomeCientifico) {
    TextEditingController _cpfController = TextEditingController(text: cpf);
    TextEditingController _numberController =
        TextEditingController(text: numeroCaixa);
    TextEditingController _linkController =
        TextEditingController(text: linkAtual);
    TextEditingController _dataController =
        TextEditingController(text: dataAtual);
    TextEditingController _distanciaRioController =
        TextEditingController(text: distanciaRioAtual);
    String _valueVegetacao = tipoVegetacaoAtual;
    String _valueTerra = tipoTerraAtual;

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
                      controller: _linkController,
                      decoration: const InputDecoration(labelText: 'Link'),
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
                          _valueVegetacao = newValue!;
                        });
                      },
                      value: _valueVegetacao,
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
                          _valueTerra = newValue!;
                        });
                      },
                      value: _valueTerra,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Tipo de Abelha:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    DropdownButton(
                      items: abelhaOpcoes.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _valueAbelha = newValue!;
                        });
                      },
                      value: _valueAbelha,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Nome Científico: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    DropdownButton(
                      items: nomeCientificoOpcoes.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _valueNomeCientifico = newValue!;
                        });
                      },
                      value: _valueNomeCientifico,
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
                          .collection('Dados ORIGEM')
                          .doc(documentId)
                          .update({
                        'cpf': _cpfController.text,
                        'numero_caixa': _numberController.text,
                        'link_georeferenciamento': _linkController.text,
                        'data_coleta': _dataController.text,
                        'tipo_vegetacao': _valueVegetacao,
                        'distancia_rio_km': _distanciaRioController.text,
                        'tipo_terra': _valueTerra,
                        'tipo_abelha': _valueAbelha,
                        'tipo_nomeCientifico': _valueNomeCientifico
                      }).then((value) {
                        setState(
                          () {},
                        );
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

//VERIFICAÇÕES - VERIFICAÇÕES - VERIFICAÇÕES - VERIFICAÇÕES - VERIFICAÇÕES - VERIFICAÇÕES - VERIFICAÇÕES

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

  bool isLinkValid(String link) {
    RegExp regExp = RegExp(
      r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$",
      caseSensitive: false,
      multiLine: false,
    );
    return regExp.hasMatch(link);
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
        .collection('Dados ORIGEM')
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
        _verificarDistanciaRio();
      }
    });
  }

  void _verificarDistanciaRio() {
    String distanciaRio = _distanceController.text.trim();
    if (distanciaRio.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Por favor, preencha a distância até o rio.'),
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
      _verificarDataColeta();
    }
  }

  void _verificarDataColeta() {
    String dataColeta = _dateController.text.trim();
    if (dataColeta.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Por favor, insira a data da coleta.'),
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
