import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyTasksScreen extends StatefulWidget {
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
      body: const Center(
        child: Text(
          'Temporary My tasks page',
          style: TextStyle(fontSize: 24),
        ),
      )
    );
  }

}