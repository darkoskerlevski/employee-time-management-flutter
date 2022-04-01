import 'package:etm_flutter/service/TaskService.dart';
import 'package:etm_flutter/service/UserService.dart';
import 'package:etm_flutter/widgets/newTask.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/Task.dart';
import '../widgets/Card.dart';

class MyTasksScreen extends StatefulWidget {
  User user;
  MyTasksScreen({required this.user});
  @override
  _MyTasksScreenState createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  List<Task> myTasks = [];
  String? companyId;
  @override
  void initState() {
    super.initState();
    UserService.worksFor(widget.user.uid).then((value) {
      setState(() {
        companyId = value;
      });
    }).then((value) {
      TaskService.listTasksForUser(widget.user.uid,companyId!).then((value) {
        setState(() {
          myTasks = value;
        });
      });
    });
  }

  void _addItemFunction(BuildContext ct) {
    if(companyId=='null')
      {
        this.showAlertDialog(ct);
      }
    else{
      showModalBottomSheet(
          context: ct,
          builder: (_) {
            return GestureDetector(
              onTap: () {},
              child: NewTask(addItem: _addNewItemToList, companyId: companyId!, userId: widget.user.uid),
              behavior: HitTestBehavior.opaque,
            );
          });
    }
  }

  void _addNewItemToList(BuildContext ctx, Task task) {
      TaskService.newTask(task);
      TaskService.listTasksForUser(widget.user.uid,companyId!).then((value) {
        setState(() {
          myTasks = value;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My tasks')
        ),
        body: ListView(
          children: [
            for (Task task in myTasks)
              CustomCard(task: task, user: widget.user, removed: false)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: ()=>{
            _addItemFunction(context)
          },
          tooltip: 'Add Task',
          child: const Icon(Icons.add),
        ),
    );
  }

  showAlertDialog(BuildContext context) {  // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.pop(context);
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("You are not in a company"),
      actions: [
        cancelButton
      ],
    );  // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
