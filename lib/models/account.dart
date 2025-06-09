class Account {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String password;
  final String role;
  final String status;
  final String createdDate;

  const Account({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.status,
    required this.createdDate,
  });

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['_id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? '',
      status: map['status'] ?? '',
      createdDate: map['createdDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userId': userId,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'status': status,
      'createdDate': createdDate,
    };
  }

  Account copyWith({
    String? id,
    String? userId,
    String? name,
    String? email,
    String? password,
    String? role,
    String? status,
    String? createdDate,
  }) {
    return Account(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      status: status ?? this.status,
      createdDate: createdDate ?? this.createdDate,
    );
  }
} 