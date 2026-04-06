import 'package:flutter/material.dart';

import 'package:parking/core/app_dependencies.dart';
import '../domain/user_validator.dart';
import '../models/user.dart';
import '../widgets/app_button.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  String? _nameErr, _emailErr, _passErr, _confirmErr;
  bool _loading = false;

  final _repo = AppDependencies().userRepository;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final nameErr = UserValidator.validateName(_nameCtrl.text.trim());
    final emailErr = UserValidator.validateEmail(_emailCtrl.text.trim());
    final passErr = UserValidator.validatePassword(_passCtrl.text);
    final confirmErr =
    UserValidator.validateConfirm(_passCtrl.text, _confirmCtrl.text);
    setState(() {
      _nameErr = nameErr;
      _emailErr = emailErr;
      _passErr = passErr;
      _confirmErr = confirmErr;
    });
    if ([nameErr, emailErr, passErr, confirmErr].any((e) => e != null)) return;
    setState(() => _loading = true);
    final user = User(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );
    final success = await _repo.register(user);
    if (!mounted) return;
    setState(() => _loading = false);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This email is already registered')),
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
                  'Create account',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 36),
                AppTextField(
                  label: 'Full Name',
                  hint: 'Vitalii',
                  icon: Icons.person_outline,
                  controller: _nameCtrl,
                  errorText: _nameErr,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Email',
                  hint: 'your@email.com',
                  icon: Icons.email_outlined,
                  controller: _emailCtrl,
                  errorText: _emailErr,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Password',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  obscure: true,
                  controller: _passCtrl,
                  errorText: _passErr,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Confirm Password',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  obscure: true,
                  controller: _confirmCtrl,
                  errorText: _confirmErr,
                ),
                const SizedBox(height: 28),
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : AppButton(label: 'Sign Up', onPressed: _register),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Already have an account?',
                  onPressed: () => Navigator.pop(context),
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