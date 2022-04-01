import 'package:etm_flutter/service/CompanyService.dart';
import 'package:flutter/material.dart';
class NewEmployee extends StatefulWidget {
  final Function addItem;

  NewEmployee(this.addItem);
  @override
  State<StatefulWidget> createState() => _NewEmployeeState();
}

class _NewEmployeeState extends State<NewEmployee> {
  final _uuidController = TextEditingController();

  String companyUuid="";
  Future<void> _submitData() async {
    final companyuuid = _uuidController .text;
    List<String> companies = await CompanyService.getAllCompanies();

    if (companyuuid.isEmpty || !companies.contains(companyuuid)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Company not found"),
      ));
      Navigator.of(context).pop();
      return;
    }

    widget.addItem(context, companyuuid);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TextField(
            controller: _uuidController ,
            decoration: InputDecoration(labelText: "Company Id"),
            //  onChanged: (val) {
            //    naslov = val;
            //  }
            onSubmitted: (_) => _submitData(),
          ),
          TextButton(
            child: Text("Join"),
            onPressed: _submitData,
          ),
        ],
      ),
    );
  }
}
