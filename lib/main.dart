import 'package:flutter/material.dart';

import 'core/app_dependencies.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartPark',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
        useMaterial3: true,
      ),
      home: const _AuthGate(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}

/// Checks persisted session and routes to home or login.
class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final session = await AppDependencies().userRepository.getSession();
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      session != null ? '/home' : '/login',
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}