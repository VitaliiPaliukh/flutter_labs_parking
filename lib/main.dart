import 'package:flutter/material.dart';

import 'package:parking/core/app_dependencies.dart';
import 'package:parking/core/connectivity_service.dart';
import 'package:parking/screens/home_screen.dart';
import 'package:parking/screens/login_screen.dart';
import 'package:parking/screens/profile_screen.dart';
import 'package:parking/screens/register_screen.dart';

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
    final repo = AppDependencies().userRepository;
    final session = await repo.getSession();
    if (!mounted) return;

    if (session == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final online = await ConnectivityService.isConnected();
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/home');

    if (!online) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No internet connection. Limited mode.'),
            // duration: Duration(seconds: 4),
            backgroundColor: Colors.orange,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
