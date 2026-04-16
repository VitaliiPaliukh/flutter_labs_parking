import 'package:flutter/material.dart';

class MqttStatusRow extends StatelessWidget {
  const MqttStatusRow({required this.connected, super.key});

  final bool connected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          size: 10,
          color: connected ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 6),
        Text(
          connected ? 'Live data from sensor' : 'Connecting to sensor...',
          style: TextStyle(
            fontSize: 12,
            color: connected ? Colors.green.shade700 : Colors.grey,
          ),
        ),
      ],
    );
  }
}
