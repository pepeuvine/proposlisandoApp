import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proposlisando_app/screens/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid 
  ? await Firebase.initializeApp(
     options: const FirebaseOptions(
      apiKey: 'AIzaSyCtl3mCY127XShagmHO8pdWWnfEXJZIYxw',
      appId: '1:754599152402:android:2a83b112e70b189c2b01cb',
      messagingSenderId: '754599152402',
      projectId: 'banco-de-dados-de-apicultores',
    ))
    : await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen()
    );
  }
}


  