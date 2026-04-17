import 'package:flutter/material.dart';
import 'package:parking/core/app_dependencies.dart';
import 'package:parking/core/connectivity_service.dart';
import 'package:parking/models/parking_lot.dart';
import 'package:parking/widgets/parking_lot_card.dart';

class ParkingListScreen extends StatefulWidget {
  const ParkingListScreen({super.key});

  @override
  State<ParkingListScreen> createState() => _ParkingListScreenState();
}

class _ParkingListScreenState extends State<ParkingListScreen> {
  late Future<List<ParkingLot>> _future;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _load();
    _checkConnectivity();
  }

  void _load() {
    _future = AppDependencies().parkingLotRepository.getParkingLots();
  }

  Future<void> _checkConnectivity() async {
    final online = await ConnectivityService.isConnected();
    if (mounted) setState(() => _isOnline = online);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hPad = width > 600 ? width * 0.1 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        title: const Text(
          'Parking Lots',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(_load),
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_isOnline)
            Container(
              width: double.infinity,
              color: Colors.orange.shade50,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Offline — showing cached data',
                style: TextStyle(color: Colors.orange.shade700, fontSize: 13),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<ParkingLot>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final lots = snapshot.data ?? [];
                if (lots.isEmpty) {
                  return const Center(child: Text('No parking lots found'));
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: hPad,
                    vertical: 16,
                  ),
                  itemCount: lots.length,
                  itemBuilder: (_, i) => ParkingLotCard(lot: lots[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
