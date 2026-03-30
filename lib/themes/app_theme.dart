import 'package:flutter/material.dart';

class AppTheme {
  static final primary = Colors.blueAccent;

  static ThemeData get Theme => ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 25, color: Colors.white),
      
    ),
    
  
  );
}