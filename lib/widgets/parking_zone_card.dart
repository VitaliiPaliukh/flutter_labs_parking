import 'package:flutter/material.dart';

import 'package:parking/models/parking_spot.dart';
import 'package:parking/widgets/parking_spot_cell.dart';

class ParkingZoneCard extends StatelessWidget {
  const ParkingZoneCard({
    required this.zone,
    required this.spots,
    super.key,
  });

  final String zone;
  final List<ParkingSpot> spots;

  int get _freeCount => spots.where((s) => s.isFree).length;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Zone $zone',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$_freeCount / ${spots.length} free',
                style: TextStyle(
                  color: _freeCount > 0 ? Colors.green.shade700 : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.85,
            children: spots
                .map((s) => ParkingSpotCell(id: s.id, isFree: s.isFree))
                .toList(),
          ),
        ],
      ),
    );
  }
}
