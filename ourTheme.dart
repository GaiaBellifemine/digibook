import 'package:flutter/material.dart';

class ourTheme{
  Color _background=Color.fromARGB(255, 77, 49, 71);
  Color _lightGrey=Color.fromARGB(255, 164, 164, 164);
  Color _darkGrey=Color.fromARGB(255, 119, 124, 135);
  
  ThemeData buildTheme(){
    return ThemeData(
      canvasColor: _background,
      primaryColor: _background,
      accentColor:  _lightGrey,
      secondaryHeaderColor: _darkGrey,
    );
  }
}