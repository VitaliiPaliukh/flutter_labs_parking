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

  void _reload() => setState(_load);

  Future<void> _checkConnectivity() async {
    final online = await ConnectivityService.isConnected();
    if (mounted) setState(() => _isOnline = online);
  }

  Future<ParkingLot?> _showLotDialog({ParkingLot? initial}) async {
    final formKey = GlobalKey<FormState>();
    final nameController =
        TextEditingController(text: initial?.name ?? '');
    final addressController =
        TextEditingController(text: initial?.address ?? '');
    final totalController = TextEditingController(
      text: initial?.totalSlots.toString() ?? '',
    );

    return showDialog<ParkingLot>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(initial == null ? 'Add parking lot' : 'Edit parking lot'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) => (value == null ||
                            value.trim().isEmpty)
                        ? 'Enter name'
                        : null,
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) => (value == null ||
                            value.trim().isEmpty)
                        ? 'Enter address'
                        : null,
                  ),
                  TextFormField(
                    controller: totalController,
                    decoration: const InputDecoration(labelText: 'Total slots'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final parsed = int.tryParse((value ?? '').trim());
                      if (parsed == null || parsed <= 0) {
                        return 'Enter positive number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (!(formKey.currentState?.validate() ?? false)) {
                  return;
                }
                Navigator.pop(
                  dialogContext,
                  ParkingLot(
                    id: initial?.id ?? '',
                    name: nameController.text.trim(),
                    address: addressController.text.trim(),
                    totalSlots: int.parse(totalController.text.trim()),
                  ),
                );
              },
              child: Text(initial == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addLot() async {
    final lot = await _showLotDialog();
    if (lot == null) return;
    try {
      await AppDependencies().parkingLotRepository.addParkingLot(lot);
      _reload();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parking lot added')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add: $e')),
      );
    }
  }

  Future<void> _editLot(ParkingLot lot) async {
    final updated = await _showLotDialog(initial: lot);
    if (updated == null) return;
    try {
      await AppDependencies().parkingLotRepository.updateParkingLot(updated);
      _reload();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parking lot updated')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e')),
      );
    }
  }

  Future<void> _deleteLot(ParkingLot lot) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete parking lot'),
        content: Text('Delete "${lot.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await AppDependencies().parkingLotRepository.deleteParkingLot(lot.id);
      _reload();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parking lot deleted')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $e')),
      );
    }
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
            onPressed: _reload,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addLot,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          if (!_isOnline)
            Container(
              width: double.infinity,
              color: Colors.orange.shade50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('No parking lots found'),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _addLot,
                          icon: const Icon(Icons.add),
                          label: const Text('Add first parking lot'),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: hPad,
                    vertical: 16,
                  ),
                  itemCount: lots.length,
                  itemBuilder: (_, i) => ParkingLotCard(
                    lot: lots[i],
                    onEdit: () => _editLot(lots[i]),
                    onDelete: () => _deleteLot(lots[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
