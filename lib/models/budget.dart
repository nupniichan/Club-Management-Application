class Budget {
  final int id;
  final String ten;
  final int khoanChiTieu;
  final int nguonThu;
  final String ngay;
  final String thanhVienChiuTrachNhiem;
  final String noiDung;
  final String club;

  const Budget({
    required this.id,
    required this.ten,
    required this.khoanChiTieu,
    required this.nguonThu,
    required this.ngay,
    required this.thanhVienChiuTrachNhiem,
    required this.noiDung,
    required this.club,
  });

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['_id'] ?? 0,
      ten: map['ten'] ?? '',
      khoanChiTieu: map['khoanChiTieu'] ?? 0,
      nguonThu: map['nguonThu'] ?? 0,
      ngay: map['ngay'] ?? '',
      thanhVienChiuTrachNhiem: map['thanhVienChiuTrachNhiem'] ?? '',
      noiDung: map['noiDung'] ?? '',
      club: map['club'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'ten': ten,
      'khoanChiTieu': khoanChiTieu,
      'nguonThu': nguonThu,
      'ngay': ngay,
      'thanhVienChiuTrachNhiem': thanhVienChiuTrachNhiem,
      'noiDung': noiDung,
      'club': club,
    };
  }

  Budget copyWith({
    int? id,
    String? ten,
    int? khoanChiTieu,
    int? nguonThu,
    String? ngay,
    String? thanhVienChiuTrachNhiem,
    String? noiDung,
    String? club,
  }) {
    return Budget(
      id: id ?? this.id,
      ten: ten ?? this.ten,
      khoanChiTieu: khoanChiTieu ?? this.khoanChiTieu,
      nguonThu: nguonThu ?? this.nguonThu,
      ngay: ngay ?? this.ngay,
      thanhVienChiuTrachNhiem: thanhVienChiuTrachNhiem ?? this.thanhVienChiuTrachNhiem,
      noiDung: noiDung ?? this.noiDung,
      club: club ?? this.club,
    );
  }

  int get profit => nguonThu - khoanChiTieu;
} 