import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parking/core/app_dependencies.dart';
import 'package:parking/core/connectivity_service.dart';
import 'package:parking/core/mqtt_service.dart';
import 'package:parking/models/parking_data.dart';
import 'package:parking/models/parking_spot.dart';
import 'package:parking/models/user.dart';
import 'package:parking/widgets/alarm_banner.dart';
import 'package:parking/widgets/mqtt_status_row.dart';
import 'package:parking/widgets/no_internet_banner.dart';
import 'package:parking/widgets/parking_zone_card.dart';
import 'package:parking/widgets/stat_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _user;
  bool _isOnline = true;
  bool _mqttConnected = false;
  bool _alarmActive = false;
  int _free = 5;
  int _occupied = 15;

  late final StreamSubscription<bool> _connectivitySub;
  late final StreamSubscription<ParkingSlots> _slotsSub;
  late final StreamSubscription<bool> _alarmSub;

  final _mqtt = AppDependencies().mqttService;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _initConnectivity();
    _initMqtt();
  }

  Future<void> _initConnectivity() async {
    _isOnline = await ConnectivityService.isConnected();
    if (mounted) setState(() {});
    _connectivitySub =
        ConnectivityService.onConnectivityChanged.listen((online) {
          if (!mounted) return;
          setState(() => _isOnline = online);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(online ? 'Back online' : 'Connection lost'),
              backgroundColor: online ? Colors.green : Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        });
  }

  Future<void> _initMqtt() async {
    final connected = await _mqtt.connect();
    if (!mounted) return;
    setState(() => _mqttConnected = connected);

    _slotsSub = _mqtt.onSlotsChanged.listen((slots) {
      if (!mounted) return;
      setState(() {
        _free = slots.free;
        _occupied = slots.occupied;
      });
    });

    _alarmSub = _mqtt.onAlarm.listen((alarm) {
      if (!mounted) return;
      setState(() => _alarmActive = alarm);
    });
  }

  @override
  void dispose() {
    _connectivitySub.cancel();
    _slotsSub.cancel();
    _alarmSub.cancel();
    _mqtt.disconnect();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final repo = AppDependencies().userRepository;
    final email = await repo.getSession();
    if (email == null || !mounted) return;
    final user = await repo.getUser(email);
    if (!mounted) return;
    setState(() => _user = user);
  }

  List<ParkingSpot> _liveZone(int from, int to) {
    final spots = ParkingData.all.sublist(from, to);
    final int remaining = _free - from;
    return List.generate(spots.length, (i) {
      return ParkingSpot(id: spots[i].id, isFree: i < remaining);
    });
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
          if (_alarmActive)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.warning_amber_rounded, color: Colors.red),
            ),
          if (!_isOnline)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.wifi_off, color: Colors.orange),
            ),
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
            if (!_isOnline) const NoInternetBanner(),
            if (_alarmActive) const AlarmBanner(),
            MqttStatusRow(connected: _mqttConnected),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/parking-lots'),
                icon: const Icon(Icons.format_list_bulleted),
                label: const Text('View All Parking Lots'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF74839C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
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
                    value: '${ParkingData.all.length}',
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
            ParkingZoneCard(zone: 'A', spots: _liveZone(0, 10)),
            const SizedBox(height: 12),
            ParkingZoneCard(zone: 'B', spots: _liveZone(10, 20)),
          ],
        ),
      ),
    );
  }
}
