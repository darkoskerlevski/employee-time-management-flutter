import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/Task.dart';
import '../service/TaskService.dart';
import '../service/UserService.dart';
import '../widgets/Card.dart';
import '../widgets/newTask.dart';

class RemovedTasksScreen extends StatefulWidget {
  User user;

  RemovedTasksScreen({required this.user});

  @override
  _RemovedTasksScreenState createState() => _RemovedTasksScreenState();
}

class _RemovedTasksScreenState extends State<RemovedTasksScreen> {
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
      TaskService.listTasksForCompanyRemoved(companyId!).then((value) {
        setState(() {
          myTasks = value;
        });
      });
    });
  }

  void _restoreTaskFunction(BuildContext ct) {
    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: NewTask(
                  addItem: _restoreTask,
                  companyId: companyId!,
                  userId: widget.user.uid),
              behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _restoreTask(BuildContext ctx, String taskId) {
    TaskService.restoreTask(taskId);
    TaskService.listTasksForCompanyRemoved(companyId!).then((value) {
      setState(() {
        myTasks = value;
      });
    });
  }

  void _refresh(){
    TaskService.listTasksForCompanyRemoved(companyId!).then((value) {
      setState(() {
        myTasks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Removed Tasks'),
      ),
      body: ListView(
        children: [for (Task task in myTasks) CustomCard(task: task, user: widget.user, removed: true,callback:_refresh)],
      )
    );
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("You arent in a company"),
      actions: [cancelButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
