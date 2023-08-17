import 'package:flutter/material.dart';

// background Color
Color customBackgroundColor = Color.fromARGB(255, 170, 200, 223);

// Button style
ButtonStyle customElevatedButtonStyle(double width, double height){
  return ElevatedButton.styleFrom(
    backgroundColor: Colors.orange,
    foregroundColor: Colors.white,
    elevation: 8,
    padding:const EdgeInsets.symmetric(horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(13)
    ),
    fixedSize: Size(width, height),
  );
}

// Text style theme for appbar text only
TextStyle customTextStyle_appbar = const TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

// Text style theme
TextStyle customTextStyle_normal = const TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

// appbar theme
class AppTheme{
  static final ThemeData theme = ThemeData(
    appBarTheme:const AppBarTheme(
      backgroundColor: Colors.red,
      foregroundColor: Colors.black,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
      ),
      centerTitle: true
    ),
  );
}
