class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final DateTime createdAt;
  final bool isActive;
  final List<Map<String, dynamic>>? managedClubs;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    this.isActive = true,
    this.managedClubs,
  });

  // Factory constructor để tạo User từ Map (JSON)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      isActive: map['isActive'] ?? true,
      managedClubs: map['managedClubs'] != null 
          ? List<Map<String, dynamic>>.from(map['managedClubs'])
          : null,
    );
  }

  // Chuyển User thành Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'managedClubs': managedClubs,
    };
  }

  // Copy with method để tạo bản sao với một số thay đổi
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    DateTime? createdAt,
    bool? isActive,
    List<Map<String, dynamic>>? managedClubs,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      managedClubs: managedClubs ?? this.managedClubs,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: $role, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}