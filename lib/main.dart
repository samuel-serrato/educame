import 'package:flutter/material.dart';
import 'package:educame/BNavigation/bottom_nav.dart';
import 'package:educame/BNavigation/routes.dart';
import 'package:educame/screens/coordinacion/homeCoordinacion.dart';
import 'package:educame/screens/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting(
      'es'); // Inicializa el formateo de fechas para español
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Educame',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
