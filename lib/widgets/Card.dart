import 'package:flutter/material.dart';

import '../model/Task.dart';

class CustomCard extends StatelessWidget{
  Task task;
  CustomCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.alarm),
            title: Text("dakisd",style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text("dasdsadas",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "dsadadsd",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {},
                  child: const Text('Create reminder', style: TextStyle(color: Colors.blue))
              )
            ],
          ),
        ],
      ),
    );
  }

}