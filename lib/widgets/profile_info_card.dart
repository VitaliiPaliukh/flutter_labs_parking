import 'package:flutter/material.dart';

import '../models/user.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    final plate = user.vehiclePlate.isEmpty ? 'Not set' : user.vehiclePlate;
    return Column(
      children: [
        _InfoRow(label: 'Name', value: user.name),
        Divider(height: 1, color: Colors.grey.shade200),
        _InfoRow(label: 'Vehicle Plate', value: plate),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}