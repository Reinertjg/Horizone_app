import 'package:flutter/material.dart';
import 'package:horizone_app/app/routes.dart';
import 'package:provider/provider.dart';

import '../presentation/state/locale_provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(const Locale('pt')), // idioma padrão
      child: const MyApp(),
    ),
  );
}

