import 'package:parking/core/connectivity_service.dart';
import 'package:parking/core/mqtt_service.dart';
import 'package:parking/data/local_user_repository.dart';
import 'package:parking/data/user_repository.dart';

class AppDependencies {
  AppDependencies._();
  static final AppDependencies _instance = AppDependencies._();
  factory AppDependencies() => _instance;

  final UserRepository userRepository = LocalUserRepository();
  final ConnectivityService connectivity = const ConnectivityService();

  /// Replace with your local broker IP (same Wi-Fi as ESP8266)
  final MqttService mqttService = MqttService(
    brokerIp: '192.168.0.100',
    // wsPort: 9001,
    wsPath: '/',
  );
}
