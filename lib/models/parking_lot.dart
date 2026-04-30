class ParkingLot {
  const ParkingLot({
    required this.id,
    required this.name,
    required this.address,
    required this.totalSlots,
  });

  final String id;
  final String name;
  final String address;
  final int totalSlots;

  factory ParkingLot.fromJson(Map<String, dynamic> json) => ParkingLot(
    id: json['id'].toString(),
    name: (json['name'] as String?) ?? '',
    address: json['address'] is Map<String, dynamic>
        ? ((json['address'] as Map<String, dynamic>)['street'] as String? ?? '')
        : (json['address'] as String? ?? ''),
    totalSlots: (json['totalSlots'] as num?)?.toInt() ?? 0,
  );

  factory ParkingLot.fromFirestore(
    String id,
    Map<String, dynamic> json,
  ) =>
      ParkingLot(
        id: id,
        name: json['name'] as String? ?? 'Unknown',
        address: json['address'] as String? ?? 'No address',
        totalSlots: ((json['totalSlots'] as num?) ?? 0).toInt(),
      );

  factory ParkingLot.fromCache(Map<String, dynamic> json) => ParkingLot(
    id: json['id'] as String,
    name: json['name'] as String,
    address: json['address'] as String,
    totalSlots: (json['totalSlots'] as num).toInt(),
  );

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'address': address,
    'totalSlots': totalSlots,
  };

  Map<String, dynamic> toCache() => {
    'id': id,
    'name': name,
    'address': address,
    'totalSlots': totalSlots,
  };
}
