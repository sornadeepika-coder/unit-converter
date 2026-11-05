import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          primary: const Color(0xFF1E88E5),
          secondary: const Color(0xFF0D47A1),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F8FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E88E5),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 2,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
