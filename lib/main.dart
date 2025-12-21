import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const QCYApp());
}

class QCYApp extends StatelessWidget {
  const QCYApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const HomeScreen());
  }
}
