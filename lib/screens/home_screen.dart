import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io' show Platform;



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

_signOut() async {
  await _firebaseAuth.signOut();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: const Center(
        child: Text(
          'Temporary home page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

}
