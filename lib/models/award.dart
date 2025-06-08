class Award {
  final String id;
  final String tenGiaiThuong;
  final String ngayDatGiai;
  final String loaiGiai;
  final String thanhVienDatGiai;
  final String ghiChu;
  final String anhDatGiai;

  const Award({
    required this.id,
    required this.tenGiaiThuong,
    required this.ngayDatGiai,
    required this.loaiGiai,
    required this.thanhVienDatGiai,
    required this.ghiChu,
    required this.anhDatGiai,
  });

  factory Award.fromMap(Map<String, dynamic> map) {
    return Award(
      id: map['_id'] ?? '',
      tenGiaiThuong: map['tenGiaiThuong'] ?? '',
      ngayDatGiai: map['ngayDatGiai'] ?? '',
      loaiGiai: map['loaiGiai'] ?? '',
      thanhVienDatGiai: map['thanhVienDatGiai'] ?? '',
      ghiChu: map['ghiChu'] ?? '',
      anhDatGiai: map['anhDatGiai'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'tenGiaiThuong': tenGiaiThuong,
      'ngayDatGiai': ngayDatGiai,
      'loaiGiai': loaiGiai,
      'thanhVienDatGiai': thanhVienDatGiai,
      'ghiChu': ghiChu,
      'anhDatGiai': anhDatGiai,
    };
  }

  Award copyWith({
    String? id,
    String? tenGiaiThuong,
    String? ngayDatGiai,
    String? loaiGiai,
    String? thanhVienDatGiai,
    String? ghiChu,
    String? anhDatGiai,
  }) {
    return Award(
      id: id ?? this.id,
      tenGiaiThuong: tenGiaiThuong ?? this.tenGiaiThuong,
      ngayDatGiai: ngayDatGiai ?? this.ngayDatGiai,
      loaiGiai: loaiGiai ?? this.loaiGiai,
      thanhVienDatGiai: thanhVienDatGiai ?? this.thanhVienDatGiai,
      ghiChu: ghiChu ?? this.ghiChu,
      anhDatGiai: anhDatGiai ?? this.anhDatGiai,
    );
  }
} 