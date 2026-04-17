import 'package:parking/core/connectivity_service.dart';
import 'package:parking/core/mqtt_service.dart';
import 'package:parking/data/api_parking_lot_repository.dart';
import 'package:parking/data/local_user_repository.dart';
import 'package:parking/data/parking_lot_repository.dart';
import 'package:parking/data/user_repository.dart';

class AppDependencies {
  AppDependencies._();
  static final AppDependencies _instance = AppDependencies._();
  factory AppDependencies() => _instance;

  final UserRepository userRepository = LocalUserRepository();
  final ConnectivityService connectivity = const ConnectivityService();
  final MqttService mqttService = MqttService(brokerIp: '192.168.0.101');
  final ParkingLotRepository parkingLotRepository =
  ApiParkingLotRepository();
}
