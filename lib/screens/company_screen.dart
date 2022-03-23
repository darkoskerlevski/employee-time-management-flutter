import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompanyScreen extends StatefulWidget {
  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Company'),
        ),
        body: const Center(
          child: Text(
            'Temporary Company page',
            style: TextStyle(fontSize: 24),
          ),
        )
    );
  }

}