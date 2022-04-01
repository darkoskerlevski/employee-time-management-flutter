import 'package:flutter/material.dart';

class NewCompany extends StatefulWidget {
  final Function addItem;

  NewCompany(this.addItem);
  @override
  State<StatefulWidget> createState() => _NewCompanyState();
}

class _NewCompanyState extends State<NewCompany> {
  final _naslovController = TextEditingController();

  String naslov="";
  double vrednost=0;
  void _submitData() {
    final vnesenNaslov = _naslovController.text;

    if (vnesenNaslov.isEmpty) {
      return;
    }

    widget.addItem(context, vnesenNaslov);
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
            decoration: InputDecoration(labelText: "Company Name"),
            //  onChanged: (val) {
            //    naslov = val;
            //  }
            onSubmitted: (_) => _submitData(),
          ),
          TextButton(
            child: Text("Add"),
            onPressed: _submitData,
          ),
        ],
      ),
    );
  }
}
