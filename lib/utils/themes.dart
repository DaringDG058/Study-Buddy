import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blueGrey[700],
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blueGrey[600],
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blueGrey[800],
      unselectedItemColor: Colors.grey[500],
      type: BottomNavigationBarType.fixed,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey[700],
        foregroundColor: Colors.white,
      ),
    ),
    fontFamily: 'ArialRounded',
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.tealAccent[100],
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[900],
      selectedItemColor: Colors.tealAccent[200],
      unselectedItemColor: Colors.grey[600],
      type: BottomNavigationBarType.fixed,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.tealAccent[200],
        foregroundColor: Colors.black,
      ),
    ),
    fontFamily: 'ArialRounded',
  );
}

// Custom Text Style for the App Name
const TextStyle kAppNameStyle = TextStyle(
  fontFamily: 'SegoePrint',
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
  fontSize: 22,
);