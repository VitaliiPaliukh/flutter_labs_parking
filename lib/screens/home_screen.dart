import 'package:flutter/material.dart';

import 'package:parking/models/parking_spot.dart';
import 'package:parking/widgets/parking_zone_card.dart';
import 'package:parking/widgets/stat_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final _zoneA = [
    const ParkingSpot(id: 'A1', isFree: true),
    const ParkingSpot(id: 'A2', isFree: false),
    const ParkingSpot(id: 'A3', isFree: true),
    const ParkingSpot(id: 'A4', isFree: false),
    const ParkingSpot(id: 'A5', isFree: true),
    const ParkingSpot(id: 'A6', isFree: false),
    const ParkingSpot(id: 'A7', isFree: false),
    const ParkingSpot(id: 'A8', isFree: true),
    const ParkingSpot(id: 'A9', isFree: false),
    const ParkingSpot(id: 'A10', isFree: true),
  ];

  static final _zoneB = [
    const ParkingSpot(id: 'B1', isFree: false),
    const ParkingSpot(id: 'B2', isFree: false),
    const ParkingSpot(id: 'B3', isFree: true),
    const ParkingSpot(id: 'B4', isFree: false),
    const ParkingSpot(id: 'B5', isFree: false),
    const ParkingSpot(id: 'B6', isFree: true),
    const ParkingSpot(id: 'B7', isFree: false),
    const ParkingSpot(id: 'B8', isFree: true),
    const ParkingSpot(id: 'B9', isFree: false),
    const ParkingSpot(id: 'B10', isFree: false),
  ];

  int get _totalFree =>
      [..._zoneA, ..._zoneB].where((s) => s.isFree).length;

  int get _totalOccupied =>
      [..._zoneA, ..._zoneB].where((s) => !s.isFree).length;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hPad = width > 600 ? width * 0.1 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        title: const Text(
          'SmartPark',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: const CircleAvatar(
              backgroundColor: Color(0xFF0D47A1),
              child: Text('VP', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Free spots',
                    value: '$_totalFree',
                    color: Colors.green,
                    icon: Icons.check_circle_outline,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatCard(
                    label: 'Occupied',
                    value: '$_totalOccupied',
                    color: Colors.red,
                    icon: Icons.directions_car,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatCard(
                    label: 'Total',
                    value: '${_zoneA.length + _zoneB.length}',
                    color: const Color(0xFF0D47A1),
                    icon: Icons.local_parking,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Parking Map',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ParkingZoneCard(zone: 'A', spots: _zoneA),
            const SizedBox(height: 12),
            ParkingZoneCard(zone: 'B', spots: _zoneB),
            const SizedBox(height: 16),
            Row(
              children: [
                _LegendItem(color: Colors.green.shade400, label: 'Free'),
                const SizedBox(width: 16),
                _LegendItem(color: Colors.red.shade300, label: 'Occupied'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}
