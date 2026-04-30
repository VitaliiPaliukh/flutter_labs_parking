import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/core/connectivity_service.dart';
import 'package:parking/cubit/parking_lots_cubit.dart';
import 'package:parking/models/parking_lot.dart';
import 'package:parking/widgets/parking_lot_card.dart';

class ParkingListScreen extends StatelessWidget {
  const ParkingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ParkingLotsCubit>().loadParkingLots();
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
            onPressed: () =>
                context.read<ParkingLotsCubit>().loadParkingLots(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showLotDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _ConnectivityBanner(),
          Expanded(
            child: BlocBuilder<ParkingLotsCubit,
                ParkingLotsState>(
              builder: (context, state) {
                if (state is ParkingLotsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ParkingLotsLoaded) {
                  final lots = state.lots;
                  return lots.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'No parking lots found',
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: () =>
                                    _showLotDialog(context),
                                icon: const Icon(Icons.add),
                                label: const Text(
                                  'Add first parking lot',
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          itemCount: lots.length,
                          itemBuilder: (_, i) =>
                              ParkingLotCard(
                                lot: lots[i],
                                onEdit: () =>
                                    _showLotDialog(
                                      context,
                                      initial: lots[i],
                                    ),
                                onDelete: () =>
                                    _deleteLot(
                                      context,
                                      lots[i],
                                    ),
                              ),
                        );
                }
                if (state is ParkingLotsError) {
                  return Center(
                    child: Text('Error: ${state.message}'),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLotDialog(
    BuildContext context, {
    ParkingLot? initial,
  }) async {
    final formKey = GlobalKey<FormState>();
    final nameController =
        TextEditingController(text: initial?.name ?? '');
    final addressController = TextEditingController(
      text: initial?.address ?? '',
    );
    final totalController = TextEditingController(
      text: initial?.totalSlots.toString() ?? '',
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            initial == null
                ? 'Add parking lot'
                : 'Edit parking lot',
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    validator: (value) =>
                        (value == null ||
                                value.trim().isEmpty)
                            ? 'Enter name'
                            : null,
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                    ),
                    validator: (value) =>
                        (value == null ||
                                value.trim().isEmpty)
                            ? 'Enter address'
                            : null,
                  ),
                  TextFormField(
                    controller: totalController,
                    decoration: const InputDecoration(
                      labelText: 'Total slots',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final parsed = int.tryParse(
                        (value ?? '').trim(),
                      );
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
              onPressed: () =>
                  Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (!(formKey.currentState
                        ?.validate() ??
                    false)) {
                  return;
                }
                final lot = ParkingLot(
                  id: initial?.id ?? '',
                  name: nameController.text.trim(),
                  address:
                      addressController.text.trim(),
                  totalSlots: int.parse(
                    totalController.text.trim(),
                  ),
                );
                Navigator.pop(dialogContext);
                if (initial == null) {
                  context
                      .read<ParkingLotsCubit>()
                      .addParkingLot(lot);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content:
                          Text('Parking lot added'),
                    ),
                  );
                } else {
                  context
                      .read<ParkingLotsCubit>()
                      .updateParkingLot(lot);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Parking lot updated',
                      ),
                    ),
                  );
                }
              },
              child: Text(initial == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteLot(
    BuildContext context,
    ParkingLot lot,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete parking lot'),
        content: Text('Delete "${lot.name}"?'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;
    context.read<ParkingLotsCubit>().deleteParkingLot(
          lot.id,
        );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Parking lot deleted'),
      ),
    );
  }
}

class _ConnectivityBanner extends StatefulWidget {
  @override
  State<_ConnectivityBanner> createState() =>
      _ConnectivityBannerState();
}

class _ConnectivityBannerState
    extends State<_ConnectivityBanner> {
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final online =
        await ConnectivityService.isConnected();
    if (mounted) setState(() => _isOnline = online);
  }

  @override
  Widget build(BuildContext context) {
    return !_isOnline
        ? Container(
            width: double.infinity,
            color: Colors.orange.shade50,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Text(
              'Offline — showing cached data',
              style: TextStyle(
                color: Colors.orange.shade700,
                fontSize: 13,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
