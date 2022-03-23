import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/main_screen.dart';
import 'screens/list_detail_screen.dart';

import 'blocs/list_bloc.dart';
import 'blocs/list_event.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListBloc>(
      create: (BuildContext context) => ListBloc()..add(ListInitializedEvent()),
      child: MaterialApp(
        // Application name
          title: 'Flutter Hello World',
          // Application theme data, you can set the colors for the application as
          // you want
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.red,
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx) => MainScreen(),
            ListDetailScreen.routeName: (ctx) => ListDetailScreen(),
          }
        // A widget which will be started on application startup
      ),
    );
  }
}
