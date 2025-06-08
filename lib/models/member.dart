class Member {
  final String id;
  final String name;
  final String gender;
  final String className;
  final String role;

  const Member({
    required this.id,
    required this.name,
    required this.gender,
    required this.className,
    required this.role,
  });

  // Getters với tên tiếng Việt để tương thích với code hiện tại
  String get ten => name;
  String get gioiTinh => gender;
  String get lop => className;
  String get vaiTro => role;

  // Operator [] để truy cập như Map
  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'name':
      case 'ten':
        return name;
      case 'gender':
      case 'gioiTinh':
        return gender;
      case 'class':
      case 'className':
      case 'lop':
        return className;
      case 'role':
      case 'vaiTro':
        return role;
      default:
        return null;
    }
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
      className: map['class'] ?? '',
      role: map['role'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'class': className,
      'role': role,
    };
  }

  Member copyWith({
    String? id,
    String? name,
    String? gender,
    String? className,
    String? role,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      className: className ?? this.className,
      role: role ?? this.role,
    );
  }
} 