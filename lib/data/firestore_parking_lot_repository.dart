import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking/data/parking_lot_repository.dart';
import 'package:parking/models/parking_lot.dart';

class FirestoreParkingLotRepository implements ParkingLotRepository {
  FirestoreParkingLotRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('parking_lots');

  @override
  Future<List<ParkingLot>> getParkingLots() async {
    try {
      final snapshot = await _collection.orderBy('name').get();

      if (snapshot.docs.isEmpty) {
        await _initializeTestData();
        final updatedSnapshot =
            await _collection.orderBy('name').get();
        return updatedSnapshot.docs
            .map((doc) => ParkingLot.fromFirestore(doc.id, doc.data()))
            .toList();
      }

      return snapshot.docs
          .map((doc) => ParkingLot.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _initializeTestData() async {
    final testLots = [
      {
        'name': 'Downtown Parking',
        'address': 'Main St 123',
        'totalSlots': 100
      },
      {
        'name': 'Airport Parking',
        'address': 'Airport Rd 456',
        'totalSlots': 500
      },
      {
        'name': 'Mall Parking',
        'address': 'Shopping Center 789',
        'totalSlots': 250
      },
    ];

    for (final lot in testLots) {
      try {
        await _collection.add(lot);
      } catch (_) {
        // Ignore errors during test data initialization
      }
    }
  }

  @override
  Future<void> addParkingLot(ParkingLot lot) async {
    final data = lot.toFirestore();
    if (lot.id.isEmpty) {
      await _collection.add(data);
      return;
    }

    await _collection.doc(lot.id).set(data);
  }

  @override
  Future<void> updateParkingLot(ParkingLot lot) async {
    await _collection.doc(lot.id).set(
      lot.toFirestore(),
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> deleteParkingLot(String id) async {
    await _collection.doc(id).delete();
  }
}
