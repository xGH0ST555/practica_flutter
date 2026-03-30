import 'package:flutter/material.dart';
import 'package:practica_1/themes/exports.dart';

class AppTheme {
  static final primary = Colors.black;

  static ThemeData get Theme => ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      titleTextStyle: GoogleFonts.calSans(
        color: Colors.white,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ), 
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primary,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      unselectedLabelStyle: GoogleFonts.calSans(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      selectedLabelStyle: GoogleFonts.calSans(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: EdgeInsets.all(20),
      titleTextStyle: GoogleFonts.calSans(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
    ),

    textTheme: TextTheme(
      bodyMedium: GoogleFonts.calSans(),
    ),
    
    
  
  );
}