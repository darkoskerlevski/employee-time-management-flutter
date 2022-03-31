import 'package:etm_flutter/model/user.dart';
import 'package:etm_flutter/service/UserService.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../model/Task.dart';
class NewTask extends StatefulWidget {
  Function? addItem;
  String userId;
  String companyId;
  NewTask({required this.addItem,required this.userId,required this.companyId});
  @override
  State<StatefulWidget> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  String dropdownValue="";
  List<CustomUser> users = [];
  DateTime? _dateTime;

  void _submitData() {
    final String title = _titleController.text;
    final String desc = _descriptionController.text;
    final DateTime? date = _dateTime;
    final String ddv = dropdownValue;

    if(title==null || desc==null || date==null || ddv==""){
      return;
    }
    var uuid = Uuid();
    String uid = uuid.v1();
    Task task = Task(id:uid,allocatedTo: ddv,companyId: widget.companyId,title: title,description: desc,by: date);
    widget.addItem!(context,task);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    UserService.listUsers(widget.companyId).then((value) {
      setState(() {
        users = value;
        dropdownValue = value[0].id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TextField(
            controller: _titleController ,
            decoration: InputDecoration(labelText: "Task Title"),
          ),
          TextField(
            controller: _descriptionController ,
            decoration: InputDecoration(labelText: "Description"),
          ),
          TextField(
            readOnly: true,
            controller: _dateController ,
            decoration: InputDecoration(labelText: "Finish By"),
            //  onChanged: (val) {
            //    naslov = val;
            //  }
            onTap: (){showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2001), lastDate: DateTime(2100)).then((value) => {setState((){_dateTime=value;_dateController.text =value.toString().split(" ")[0];})});},
          ),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: users.map<DropdownMenuItem<String>>((CustomUser value) {
              String email = value.Email;
              return DropdownMenuItem<String>(
                value: value.id,
                child: Text(email),
              );
            }).toList(),
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
