import 'package:flutter/material.dart';
import 'package:horizone_app/app/routes.dart';
import 'package:provider/provider.dart';

import '../presentation/state/locale_provider.dart';
import '../presentation/state/theme_provider.dart';


void main() {
        runApp(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => LocaleProvider(const Locale('pt')),
              ),
              ChangeNotifierProvider(
                create: (_) => ThemeProvider(),
              ),
            ],
            child: const MyApp(),
          ),
        );
      }

