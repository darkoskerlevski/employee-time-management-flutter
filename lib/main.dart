// @dart=2.9
import 'dart:async';
import 'dart:io';

import 'package:etm_flutter/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'Screens/Login_Screen.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await initializeService();
  runApp(
    MyApp(),
  );
}


Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();


  if (Platform.isIOS) FlutterBackgroundServiceIOS.registerWith();
  if (Platform.isAndroid) FlutterBackgroundServiceAndroid.registerWith();

  final service = FlutterBackgroundService();
  service.setAsBackgroundService();

  double sumRoll=0;
  double prevRoll=0;
  double sumPitch=0;
  double prevPitch=0;

  print("Hi");

  service.onDataReceived.listen((event) {
    if (event["action"] == "stopService") {
      service.stopService();
    }
    if (event["action"] == "sendData") {

      service.sendData(
        {
          "sumRoll": sumRoll,
          "sumPitch": sumPitch,
        },
      );
    }
  });
}

void onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
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