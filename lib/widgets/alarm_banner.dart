import 'package:flutter/material.dart';

class AlarmBanner extends StatelessWidget {
  const AlarmBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.red.shade700,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Parking is FULL — gate closed',
            style: TextStyle(color: Colors.red.shade700),
          ),
        ],
      ),
    );
  }
}
