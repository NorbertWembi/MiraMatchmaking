import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/auth_choice_screen.dart';
import 'navbar.dart';
import 'features/chat/chat_page.dart';
import 'screens/onboarding_step1.dart';
import 'screens/onboarding_step2.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Error loading .env file: $e");
    print("App will continue but API features may not work");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miira Matchmaking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      home: const AuthChoiceScreen(),

      routes: {
        '/navbar': (context) => const NavBar(),
        '/chat': (context) => const ChatPage(),
        '/onboarding1': (context) => const OnboardingStep1(),
        '/onboarding2': (context) => const OnboardingStep2(
          appTitle: 'Miira',
          username: '',
          age: 0,
          gender: '',
        ),
      },
    );
  }
}
