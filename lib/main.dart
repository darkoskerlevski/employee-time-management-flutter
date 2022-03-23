import 'package:etm_flutter/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/main_screen.dart';
import 'screens/list_detail_screen.dart';
import 'blocs/list_bloc.dart';
import 'blocs/list_event.dart';
import 'Screens/Login_Screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Employee Time Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:LoginScreen(),
      routes: {
        '/homescreen' : (_) => HomeScreen()
      },
    );
  }
}