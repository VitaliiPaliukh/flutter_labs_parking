import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  const ConnectivityService();

  static Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return _isOnline(result);
  }

  static Stream<bool> get onConnectivityChanged =>
      Connectivity().onConnectivityChanged.map(_isOnline);

  static bool _isOnline(List<ConnectivityResult> result) =>
      result.any((r) => r != ConnectivityResult.none);
}
