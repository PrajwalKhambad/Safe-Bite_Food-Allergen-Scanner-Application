import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'themes.dart';
import 'pages/login_screen.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "",
            projectId: "",
            messagingSenderId: "",
            appId: "",
            storageBucket: ""));
  } else {
    await Firebase.initializeApp();
  }

  runApp( 
    MaterialApp(
    home:const LoginForm(),
    debugShowCheckedModeBanner: false,
    theme: AppTheme.theme,
    ));
}
