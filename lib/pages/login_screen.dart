import 'package:flutter/material.dart';
import 'package:safe_bite/themes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: customBackgroundColor,
      child: ListView(
        children: [
          Container(
            color: customBackgroundColor,
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sign-in using mobile number", style: customTextStyle_normal,),
                const SizedBox(height: 20,),
                Text("Enter your mobile number below", style: customTextStyle_normal,),
                
              ],
            ),
          )
        ],
      ),
    );
  }
}