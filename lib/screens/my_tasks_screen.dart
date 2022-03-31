import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/Task.dart';

class MyTasksScreen extends StatefulWidget {
  List<Task> myTasks = [];
  @override
  _MyTasksScreenState createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My tasks'),
        ),
        body: ListView(
          children: [
            for (Task task in widget.myTasks)
              CustomCard(task)
          ],
        ));
  }
}
