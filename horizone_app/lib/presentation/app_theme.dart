
import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
      scaffoldBackgroundColor: Color(0xFFF6F1EB),
      primaryColor: Color(0xFF003566),
      hintColor: Color(0xFFFF914D),
      highlightColor: Color(0xFFF6F1EB)
  );
}

ThemeData darkTheme() {
  return ThemeData(
    scaffoldBackgroundColor: Color(0xFF1E1E1E),
    primaryColor: Color(0xFFB9D6F2),
    hintColor: Color(0xFFFBAE7A),
    highlightColor: Color(0xFF1E1E1E),
  );
}
