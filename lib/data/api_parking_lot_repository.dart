import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:parking/data/parking_lot_repository.dart';
import 'package:parking/models/parking_lot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiParkingLotRepository implements ParkingLotRepository {
  static const _cacheKey = 'cached_parking_lots';
  static const _apiUrl =
      'https://jsonplaceholder.typicode.com/users';

  @override
  Future<List<ParkingLot>> getParkingLots() async {
    try {
      final response = await http
          .get(Uri.parse(_apiUrl))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return _loadFromCache();
      final list = jsonDecode(response.body) as List<dynamic>;
      final lots = list
          .map((e) => ParkingLot.fromJson(e as Map<String, dynamic>))
          .toList();
      await _saveToCache(lots);
      return lots;
    } catch (_) {
      return _loadFromCache();
    }
  }

  Future<List<ParkingLot>> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cacheKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => ParkingLot.fromCache(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveToCache(List<ParkingLot> lots) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _cacheKey,
      jsonEncode(lots.map((l) => l.toJson()).toList()),
    );
  }
}
