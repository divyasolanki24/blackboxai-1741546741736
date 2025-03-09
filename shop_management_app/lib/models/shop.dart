class Shop {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  Shop({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
    };
  }

  Shop copyWith({
    String? name,
    String? address,
    String? phone,
    String? email,
    bool? isActive,
  }) {
    return Shop(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isActive: isActive ?? this.isActive,
    );
  }
}
