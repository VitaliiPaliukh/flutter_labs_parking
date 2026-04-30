import 'package:parking/models/parking_lot.dart';

abstract class ParkingLotRepository {
  Future<List<ParkingLot>> getParkingLots();
  Future<void> addParkingLot(ParkingLot lot);
  Future<void> updateParkingLot(ParkingLot lot);
  Future<void> deleteParkingLot(String id);
}
