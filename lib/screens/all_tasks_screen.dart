import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/Task.dart';
import '../service/TaskService.dart';
import '../service/UserService.dart';
import '../widgets/Card.dart';
import '../widgets/newTask.dart';

class AllTasksScreen extends StatefulWidget {
  User user;

  AllTasksScreen({required this.user});

  @override
  _AllTasksScreenState createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
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
      TaskService.listTasksForCompany(companyId!).then((value) {
        setState(() {
          myTasks = value;
        });
      });
    });
  }

  void _addItemFunction(BuildContext ct) {
    if (companyId == null) {
      this.showAlertDialog(ct);
    } else {
      showModalBottomSheet(
          context: ct,
          builder: (_) {
            return GestureDetector(
              onTap: () {},
              child: NewTask(
                  addItem: _addNewItemToList,
                  companyId: companyId!,
                  userId: widget.user.uid),
              behavior: HitTestBehavior.opaque,
            );
          });
    }
  }

  void _addNewItemToList(BuildContext ctx, Task task) {
    TaskService.newTask(task);
    TaskService.listTasksForCompany(companyId!).then((value) {
      setState(() {
        myTasks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My tasks'),
      ),
      body: ListView(
        children: [for (Task task in myTasks) CustomCard(task: task)],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {_addItemFunction(context)},
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("You arent in a company"),
      actions: [cancelButton],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
