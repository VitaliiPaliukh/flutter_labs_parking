import 'package:flutter/material.dart';

class ParkingSpotCell extends StatelessWidget {
  const ParkingSpotCell({
    required this.id,
    required this.isFree,
    super.key,
  });

  final String id;
  final bool isFree;

  @override
  Widget build(BuildContext context) {
    final bg = isFree ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);
    final borderColor = isFree ? Colors.green.shade400 : Colors.red.shade300;
    final textColor = isFree ? Colors.green.shade700 : Colors.red.shade400;
    final icon = isFree ? Icons.check_rounded : Icons.directions_car;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(height: 4),
          Text(
            id,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
