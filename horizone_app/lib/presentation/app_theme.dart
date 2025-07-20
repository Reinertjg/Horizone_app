import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    scaffoldBackgroundColor: Color(0xFFF4F8FB),
    primaryColor: Color(0xFF005BB1), // Azul vívido, moderno
    hintColor: Color(0xFFFF9900), // Cinza claro, neutro
    highlightColor: Color(0xFFFFFFFF), // Azul suave para interações
  );
}

ThemeData darkTheme() {
  return ThemeData(
    scaffoldBackgroundColor: Color(0xFF1C1C1E),
    primaryColor: Color(0xFF90CAF9),
    hintColor: Color(0xFFFFB74D),
    highlightColor: Color(0xFF2C2C2E),
  );
}
