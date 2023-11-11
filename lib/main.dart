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
            apiKey: "AIzaSyAbaO2VaWJzXcKOShzfMQTipajpPK2FMKg",
            projectId: "safebite-d87bb",
            messagingSenderId: "747343795053",
            appId: "1:747343795053:android:81cde8ef737f0fb8974064",
            storageBucket: "safebite-d87bb.appspot.com"));
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