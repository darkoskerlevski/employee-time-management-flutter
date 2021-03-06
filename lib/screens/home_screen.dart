import 'package:etm_flutter/screens/all_tasks_screen.dart';
import 'package:etm_flutter/screens/company_screen.dart';
import 'package:etm_flutter/screens/my_tasks_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  User? user = _firebaseAuth.currentUser;
  HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

_signOut() async {
  await _firebaseAuth.signOut();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      MyTasksScreen(user: widget.user!),
      AllTasksScreen(user: widget.user!),
      CompanyScreen(user:widget.user!)
    ];
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'My Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'All Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Company',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

}
