import 'package:etm_flutter/screens/task_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/Task.dart';

class CustomCard extends StatelessWidget{
  Task task;
  User user;
  bool removed;
  CustomCard({required this.task, required this.user, required this.removed});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.alarm),
            title: Text(task.title,style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text(task.description,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              task.by.toString(),
              style: TextStyle(color: Colors.grey),
            ),
          ),
          // Text(
          //   "Asignee: " + user.email!,
          //   style: TextStyle(color: Colors.grey),
          // ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskDetailsScreen(task: task, user: user, removed: removed)));
                  },
                  child: const Text('Open Task', style: TextStyle(color: Colors.blue))
              )
            ],
          ),
        ],
      ),
    );
  }

}