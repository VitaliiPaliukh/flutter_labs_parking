import 'package:flutter/material.dart';

import '../core/app_dependencies.dart';
import '../models/parking_spot.dart';
import '../models/user.dart';
import '../widgets/parking_zone_card.dart';
import '../widgets/stat_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _user;

  static final _zoneA = [
    const ParkingSpot(id: 'A1', isFree: true),
    const ParkingSpot(id: 'A2', isFree: false),
    const ParkingSpot(id: 'A3', isFree: true),
    const ParkingSpot(id: 'A4', isFree: false),
    const ParkingSpot(id: 'A5', isFree: true),
    const ParkingSpot(id: 'A6', isFree: true),
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

  int get _free => [..._zoneA, ..._zoneB].where((s) => s.isFree).length;
  int get _occupied => [..._zoneA, ..._zoneB].where((s) => !s.isFree).length;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final repo = AppDependencies().userRepository;
    final email = await repo.getSession();
    if (email == null || !mounted) return;
    final user = await repo.getUser(email);
    if (!mounted) return;
    setState(() => _user = user);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hPad = width > 600 ? width * 0.1 : 16.0;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        title: Text(
          'Hi, ${_user?.name ?? '...'}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              await Navigator.pushNamed(context, '/profile');
              _loadUser();
            },
            child: CircleAvatar(
              backgroundColor: const Color(0xFF0D47A1),
              child: Text(
                _user != null ? _user!.name[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white),
              ),
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
                    label: 'Free',
                    value: '$_free',
                    color: Colors.green,
                    icon: Icons.check_circle_outline,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatCard(
                    label: 'Occupied',
                    value: '$_occupied',
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
          ],
        ),
      ),
    );
  }
}