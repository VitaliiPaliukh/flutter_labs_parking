import 'package:parking/core/connectivity_service.dart';
import 'package:parking/core/mqtt_service.dart';
import 'package:parking/data/firestore_parking_lot_repository.dart';
import 'package:parking/data/local_user_repository.dart';
import 'package:parking/data/parking_lot_repository.dart';
import 'package:parking/data/user_repository.dart';

class AppDependencies {
  AppDependencies._();
  static final AppDependencies _instance = AppDependencies._();
  factory AppDependencies() => _instance;

  final UserRepository userRepository = LocalUserRepository();
  final ConnectivityService connectivity = const ConnectivityService();
  final MqttService mqttService = MqttService(brokerIp: '172.20.10.3');
  final ParkingLotRepository parkingLotRepository =
      FirestoreParkingLotRepository();
}
