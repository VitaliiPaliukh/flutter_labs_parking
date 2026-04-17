import 'package:parking/models/parking_spot.dart';

class ParkingData {
  const ParkingData._();

  static final zoneA = [
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

  static final zoneB = [
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

  static List<ParkingSpot> get all => [...zoneA, ...zoneB];
}
