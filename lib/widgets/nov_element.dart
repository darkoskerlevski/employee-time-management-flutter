import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';

import '../model/list_item.dart';

class NovElement extends StatefulWidget {
  final Function addItem;

  NovElement(this.addItem);
  @override
  State<StatefulWidget> createState() => _NovElementState();
}

class _NovElementState extends State<NovElement> {
  final _naslovController = TextEditingController();
  final _vrednostController = TextEditingController();

  String naslov="";
  double vrednost=0;
  void _submitData() {
    if (_vrednostController.text.isEmpty) {
      return;
    }
    final vnesenNaslov = _naslovController.text;
    final vnesenaVrednost = double.parse(_vrednostController.text);

    if (vnesenNaslov.isEmpty || vnesenaVrednost <= 0) {
      return;
    }

    final newItem = ListItem(id: nanoid(5), naslov: vnesenNaslov, vrednost: vnesenaVrednost);
    widget.addItem(context, newItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TextField(
            controller: _naslovController,
            decoration: InputDecoration(labelText: "Naslov"),
            //  onChanged: (val) {
            //    naslov = val;
            //  }
            onSubmitted: (_) => _submitData(),
          ),
          TextField(
            controller: _vrednostController,
            decoration: InputDecoration(labelText: "Vrednost"),
            keyboardType: TextInputType.number,
            //  onChanged: (val) {
            //    naslov = val;
            //  }
            onSubmitted: (_) => _submitData(),
          ),
          TextButton(
            child: Text("Dodaj"),
            onPressed: _submitData,
          ),
        ],
      ),
    );
  }
}
