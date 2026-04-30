import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:parking/core/app_dependencies.dart';
import 'package:parking/core/connectivity_service.dart';
import 'package:parking/cubit/parking_lots_cubit.dart';

import 'package:parking/core/app_dependencies.dart';
import 'package:parking/core/connectivity_service.dart';
import 'package:parking/firebase_options.dart';
import 'package:parking/screens/home_screen.dart';
import 'package:parking/screens/login_screen.dart';
import 'package:parking/screens/parking_list_screen.dart';
import 'package:parking/screens/profile_screen.dart';
import 'package:parking/screens/register_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _BootstrapApp());
}

class _BootstrapApp extends StatefulWidget {
  const _BootstrapApp();

  @override
  State<_BootstrapApp> createState() => _BootstrapAppState();
}

class _BootstrapAppState extends State<_BootstrapApp> {
  late final Future<void> _firebaseInitFuture;

  @override
  void initState() {
    super.initState();
    _firebaseInitFuture = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _firebaseInitFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Firebase initialization failed.\n'
                    'Run `flutterfire configure` and '
                    'add `firebase_options.dart`.\n\n'
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }

        return const MyApp();
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ParkingLotsCubit(AppDependencies()
                  .parkingLotRepository),
        ),
      ],
      child: MaterialApp(
        title: 'SmartPark',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0D47A1),
          ),
          useMaterial3: true,
        ),
        home: const _AuthGate(),
        routes: {
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/home': (_) => const HomeScreen(),
          '/profile': (_) => const ProfileScreen(),
          '/parking-lots': (_) => const ParkingListScreen(),
        },
      ),
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
            content: Text(
              'No internet connection. Limited mode.',
            ),
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
