import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  runApp(const MaterialApp(home: MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DEMO"),
      ),
      body: Container(
        child: ElevatedButton(onPressed: () {
          exit(0);
        },child: Text("Press"),),
      ),
    );
  }
}