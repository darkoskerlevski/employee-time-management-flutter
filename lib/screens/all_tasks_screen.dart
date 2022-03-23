import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AllTasksScreen extends StatefulWidget {
  @override
  _AllTasksScreenState createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('All tasks'),
        ),
        body: const Center(
          child: Text(
            'Temporary All tasks page',
            style: TextStyle(fontSize: 24),
          ),
        )
    );
  }

}