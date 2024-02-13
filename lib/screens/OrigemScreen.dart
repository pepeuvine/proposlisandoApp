import 'package:flutter/material.dart';

class OrigemScreen extends StatelessWidget {
  const OrigemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Proposlisando APP - ORIGEM'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CrudOrigem(),
        ),
      ),
    );
  }
}

class CrudOrigem extends StatefulWidget {
  @override
  OrigemState createState() => OrigemState();
}

class OrigemState extends State<CrudOrigem> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
    final TextEditingController _distanceController = TextEditingController();

  final vegetacaoOpcoes = [
    'mata de cocais',
    'mangues',
    'floresta Amazônica',
    'cerrado'
  ];

  final terraOpcoes = ['seca', 'arenosa', 'úmida'];
  String _dropdownvalue = 'mata de cocais';
  String _dropdownvalue2 = 'seca';

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
            controller: _linkController,
            keyboardType: TextInputType.url,
            decoration:
                const InputDecoration(labelText: 'Link do georeferenciamento'),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _dateController,
            onTap: () => _selectDate(),
            decoration: const InputDecoration(
              labelText: 'DATA DA COLETA',
              filled: true,
              prefixIcon: Icon(Icons.calendar_month_rounded),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  // borderSide: BorderSide(color: Colors.grey)
                  ),
            ),
            readOnly: true,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text("TIPO DE VEGETAÇÃO"),
          DropdownButton(
            items: vegetacaoOpcoes.map((String item) {
              return DropdownMenuItem(child: Text(item), value: item);
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _dropdownvalue = newValue!;
              });
            },
            value: _dropdownvalue,
          ),
          const SizedBox(height: 10,),
          TextField(
            controller: _distanceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Distãncia até o rio em KM.'),
          ),
          const SizedBox(height: 10,),
          const Text("TIPO DE TERRA"),
          DropdownButton(
            items: terraOpcoes.map((String item) {
              return DropdownMenuItem(child: Text(item), value: item);
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
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now());

    if (_picked != null) {
      String formattedDate = "${_picked.day}-${_picked.month}-${_picked.year}";
      setState(() {
        _dateController.text = formattedDate;
        //_picked.toString().split(" ")[0];
      });
    }
  }
}
