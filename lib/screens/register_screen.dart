import 'package:flutter/material.dart';

import 'package:parking/widgets/app_button.dart';
import 'package:parking/widgets/app_logo.dart';
import 'package:parking/widgets/app_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                const SizedBox(height: 6),
                Text(
                  'Join SmartPark today',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 36),
                const AppTextField(
                  label: 'Full Name',
                  hint: 'John Doe',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 14),
                const AppTextField(
                  label: 'Email',
                  hint: 'your@email.com',
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 14),
                const AppTextField(
                  label: 'Password',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  obscure: true,
                ),
                const SizedBox(height: 14),
                const AppTextField(
                  label: 'Confirm Password',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  obscure: true,
                ),
                const SizedBox(height: 28),
                AppButton(
                  label: 'Sign Up',
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                        (_) => false,
                  ),
                ),
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
