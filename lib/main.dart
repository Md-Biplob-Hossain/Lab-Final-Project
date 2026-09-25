import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/category_provider.dart';
import 'providers/quiz_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/category_selection_screen.dart';
import 'screens/quiz_config_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuizzicalApp());
}

class QuizzicalApp extends StatelessWidget {
  const QuizzicalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: MaterialApp(
        title: 'Quizzical',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0F4C4C),
            primary: const Color(0xFF0F4C4C),
            secondary: const Color(0xFF2196F3),
            surface: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF2C3E50),
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomeScreen(),
          '/categories': (context) => const CategorySelectionScreen(),
          '/config': (context) => const QuizConfigScreen(),
          '/quiz': (context) => const QuizScreen(),
          '/result': (context) => const ResultScreen(),
        },
      ),
    );
  }
}
