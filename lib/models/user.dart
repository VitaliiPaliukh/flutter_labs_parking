class User {
  const User({
    required this.name,
    required this.email,
    required this.password,
    this.vehiclePlate = '',
  });

  final String name;
  final String email;
  final String password;
  final String vehiclePlate;

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    vehiclePlate: json['vehiclePlate'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'vehiclePlate': vehiclePlate,
  };

  User copyWith({
    String? name,
    String? email,
    String? password,
    String? vehiclePlate,
  }) =>
      User(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      );
}