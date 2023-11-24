import 'package:flutter/material.dart';

// background Color
Color customBackgroundColor =const Color(0xFFF6F4EB);

// Button style
ButtonStyle customElevatedButtonStyle(double width, double height){
  return ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF749BC2),
    foregroundColor: Colors.white,
    elevation: 8,
    padding:const EdgeInsets.symmetric(horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(13)
    ),
    fixedSize: Size(width, height),
  );
}

// Text Field style for profile fill page
InputDecoration customTextFieldStyle(String label){
  return InputDecoration(
    labelText: label,
    hintText: "Enter your $label",
    contentPadding:const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:const BorderSide(color: Colors.black),
    ),
    filled: true,
    fillColor: Colors.grey.shade300,
  );
}

// Text style theme for appbar text only
TextStyle customTextStyle_appbar = const TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: Color(0xFFF6F4EB),
);

// Text style theme
TextStyle customTextStyle_normal = const TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.bold,
  color: Color(0xFFF6F4EB),
);


// appbar theme
class AppTheme{
  static final ThemeData theme = ThemeData(
    appBarTheme:const AppBarTheme(
      backgroundColor: Color(0xFF4682A9),
      foregroundColor: Color(0xFFF6F4EB),
      elevation: 8,
      centerTitle: true
    ),
  );
}
