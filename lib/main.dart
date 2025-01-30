import 'dart:io';

import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'home_screen.dart';
import 'result_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reconocimiento de Medicamentos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(), // Pantalla inicial
        '/home': (context) => HomeScreen(), // Pantalla principal (Home)
        '/result': (context) => ResultScreen(
            image: ModalRoute.of(context)!.settings.arguments
                as File), // Pantalla de resultados
      },
    );
  }
}
