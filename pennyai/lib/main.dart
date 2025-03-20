import 'package:flutter/material.dart';
import 'screens/penny_assistant/penny_assistant.dart';
import 'screens/expenditure/expenditure.dart';
import 'screens/Home/home_screen.dart';
import 'ai.dart';

void main() {
  runApp(const PennyAIApp());
}

class PennyAIApp extends StatelessWidget {
  const PennyAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Penny AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF5E72E4),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5E72E4),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>  HomeScreen(),
        '/assistant': (context) => const PennyAssistantScreen(),
        '/expense': (context) => const ExpenditureScreen(),
      },
    );
  }
}