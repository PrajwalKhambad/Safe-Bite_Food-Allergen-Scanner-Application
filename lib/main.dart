import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:safe_bite/pages/homepage.dart';
import 'themes.dart';
import 'pages/login_screen.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  runApp( MaterialApp(
    // home:LoginPage(),
    debugShowCheckedModeBanner: false,
    home: HomePage(),
    theme: AppTheme.theme,
    ));
}