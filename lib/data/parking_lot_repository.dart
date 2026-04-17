import 'package:parking/models/parking_lot.dart';


abstract class ParkingLotRepository {
  Future<List<ParkingLot>> getParkingLots();
}
