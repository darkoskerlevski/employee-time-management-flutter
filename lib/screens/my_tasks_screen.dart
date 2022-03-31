import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/Task.dart';
import '../widgets/Card.dart';

class MyTasksScreen extends StatefulWidget {
  List<Task> myTasks = [];
  @override
  _MyTasksScreenState createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  @override
  void initState() {
    widget.myTasks.add(new Task(id: "darkoID", allocatedTo: "e6ielq8FESgiFet2uxD1YXJHvYQ2", companyId: "a74647c0-b061-11ec-b2a3-bdfc99ff3e74", title: "Task Title", description: "Task Description", by: DateTime.now()));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My tasks'),
        ),
        body: ListView(
          children: [
            for (Task task in widget.myTasks)
              CustomCard(task: task)
          ],
        ));
  }
}
