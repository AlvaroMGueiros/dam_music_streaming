import 'package:flutter/material.dart';

class LightTheme {
  LightTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),

    //playlists
    cardColor: Color(0xFFF5F5F5),
    
    //Inputs
    dividerColor: Colors.grey[400],
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6C63FF),
      secondary:  Color(0xFF6C63FF),
      surface: Colors.white,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: Colors.black,
    ),

    // global, vai pegar na tabbar
    tabBarTheme: TabBarThemeData(
      labelColor:  Color(0xFF6C63FF),
      unselectedLabelColor: Colors.grey[400],
      indicatorColor:  Color(0xFF6C63FF),
      indicatorSize: TabBarIndicatorSize.tab,
    ),

    // global
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF5F5F5),
      elevation: 1,
      iconTheme: IconThemeData(color:  Color(0xFF6C63FF)),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    // Todos textos
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),

  );
}