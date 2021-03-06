import 'package:etm_flutter/screens/RemovedTasks.dart';
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
    if (companyId == 'null') {
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

  void _refresh(){
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
        title: const Text('All tasks'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.remove_circle),
              tooltip: 'Removed Tasks',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RemovedTasksScreen(user: widget.user)));
              }),
        ]
      ),
      body: ListView(
        children: [for (Task task in myTasks) CustomCard(task: task, user: widget.user, removed: false, callback: _refresh,)],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {_addItemFunction(context)},
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
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
      title: Text("Alert!"),
      content: Text("You are not in a company"),
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
