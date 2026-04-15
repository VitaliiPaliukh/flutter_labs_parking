import 'package:flutter/material.dart';

import 'package:parking/core/app_dependencies.dart';
import 'package:parking/domain/user_validator.dart';
import 'package:parking/widgets/app_button.dart';
import 'package:parking/widgets/app_logo.dart';
import 'package:parking/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String? _emailError;
  String? _passError;
  bool _loading = false;

  final _repo = AppDependencies().userRepository;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final emailErr = UserValidator.validateEmail(_emailCtrl.text.trim());
    final passErr = UserValidator.validatePassword(_passCtrl.text);
    setState(() {
      _emailError = emailErr;
      _passError = passErr;
    });
    if (emailErr != null || passErr != null) return;
    setState(() => _loading = true);
    final user = await _repo.login(_emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
      return;
    }
    await _repo.saveSession(user.email);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hPad = width > 600 ? width * 0.2 : 24.0;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppLogo(),
                const SizedBox(height: 48),
                const Text(
                  'Welcome back',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sign in to monitor your parking',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 36),
                AppTextField(
                  label: 'Email',
                  hint: 'your@email.com',
                  icon: Icons.email_outlined,
                  controller: _emailCtrl,
                  errorText: _emailError,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Password',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  obscure: true,
                  controller: _passCtrl,
                  errorText: _passError,
                ),
                const SizedBox(height: 28),
                if (_loading) const Center(child: CircularProgressIndicator())
                else AppButton(label: 'Sign In', onPressed: _login),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Create account',
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  outlined: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
