import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SatQueryAI());
}

class SatQueryAI extends StatelessWidget {
  const SatQueryAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SatQuery AI',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B4BEA)),
      ),
      home: const HomeScreen(),
    );
  }
}
