import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    scaffoldBackgroundColor: Color(0xFFF6F1EB),
    primaryColor: Color(0xFF005BB1),
    hintColor: Color(0xFFFF981F),
    highlightColor: Color(0xFFFFFFFF),
    focusColor: Color(0xFFFFD29F), // Verde para foco
    disabledColor: Color(0xFFBDBDBD), // Cinza para desabilitado
    shadowColor: Color(0xFF000000),
  );
}

ThemeData darkTheme() {
  return ThemeData(
    scaffoldBackgroundColor: Color(0xFF1C1C1E),
    primaryColor: Color(0xFF90CAF9),
    hintColor: Color(0xFFFFB74D),
    highlightColor: Color(0xFF2C2C2E),
    focusColor: Color(0xFFFF8800), // Verde claro para foco
    disabledColor: Color(0xFF616161), // Cinza escuro para desabilitado
    shadowColor: Color(0xFFFFFFFF),
  );
}
