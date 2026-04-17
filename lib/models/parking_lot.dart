class ParkingLot {
  const ParkingLot({
    required this.id,
    required this.name,
    required this.address,
    required this.totalSlots,
  });

  final int id;
  final String name;
  final String address;
  final int totalSlots;

  factory ParkingLot.fromJson(Map<String, dynamic> json) {
    final addr = json['address'] as Map<String, dynamic>;
    return ParkingLot(
      id: json['id'] as int,
      name: json['name'] as String,
      address: '${addr['street']}, ${addr['city']}',
      totalSlots: (json['id'] as int) * 3,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'totalSlots': totalSlots,
  };

  factory ParkingLot.fromCache(Map<String, dynamic> json) => ParkingLot(
    id: json['id'] as int,
    name: json['name'] as String,
    address: json['address'] as String,
    totalSlots: json['totalSlots'] as int,
  );
}
