import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:safe_bite/pages/profile_form_page.dart';
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
            appId: "1:747343795053:android:81cde8ef737f0fb8974064"));
  } else {
    await Firebase.initializeApp();
  }

  runApp( 
    MaterialApp(
    // home:const LoginForm(),
    // home: Profile_Form(),
    debugShowCheckedModeBanner: false,
    theme: AppTheme.theme,
    ));
}