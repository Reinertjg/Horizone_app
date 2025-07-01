import 'package:flutter/material.dart';
import 'package:horizone_app/app/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyApp()
      ),
  );
}
