// lib/main.dart

import 'package:flutter/material.dart';
import 'core/tema.dart';
import 'screens/home_screen.dart';

void main() => runApp(const PeopleOsApp());

class PeopleOsApp extends StatelessWidget {
  const PeopleOsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'People OS',
      debugShowCheckedModeBanner: false,
      theme: Tema.dark,
      home: const HomeScreen(),
    );
  }
}
