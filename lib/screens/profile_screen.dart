import 'package:flutter/material.dart';

import 'package:parking/widgets/app_button.dart';
import 'package:parking/widgets/profile_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _accountItems = [
    {'icon': Icons.person_outline, 'label': 'Edit Profile'},
    {'icon': Icons.directions_car_outlined, 'label': 'My Vehicles'},
    {'icon': Icons.notifications_outlined, 'label': 'Notifications'},
  ];

  static const _settingsItems = [
    {'icon': Icons.wifi_outlined, 'label': 'MQTT Settings'},
    {'icon': Icons.local_parking_outlined, 'label': 'My Parking Lots'},
    {'icon': Icons.help_outline, 'label': 'Help & Support'},
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hPad = width > 600 ? width * 0.2 : 24.0;
    final color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 52,
              backgroundColor: color,
              child: const Text(
                'JD',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'john@example.com',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            const ProfileSection(title: 'Account', items: _accountItems),
            const SizedBox(height: 16),
            const ProfileSection(title: 'Settings', items: _settingsItems),
            const SizedBox(height: 32),
            AppButton(
              label: 'Sign Out',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                    (_) => false,
              ),
              outlined: true,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
