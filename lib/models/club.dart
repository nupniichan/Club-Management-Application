class Club {
  final String id;
  final String ten;
  final String logo;
  final String linhVucHoatDong;
  final List<String> thanhVien;
  final String ngayThanhLap;
  final String giaoVienPhuTrach;
  final String mieuTa;
  final String quyDinh;
  final int clubId;
  final int budget;
  final String tinhTrang;
  final String truongBanCLB;

  const Club({
    required this.id,
    required this.ten,
    required this.logo,
    required this.linhVucHoatDong,
    required this.thanhVien,
    required this.ngayThanhLap,
    required this.giaoVienPhuTrach,
    required this.mieuTa,
    required this.quyDinh,
    required this.clubId,
    required this.budget,
    required this.tinhTrang,
    required this.truongBanCLB,
  });

  factory Club.fromMap(Map<String, dynamic> map) {
    return Club(
      id: map['_id'] ?? '',
      ten: map['ten'] ?? '',
      logo: map['logo'] ?? '',
      linhVucHoatDong: map['linhVucHoatDong'] ?? '',
      thanhVien: List<String>.from(map['thanhVien'] ?? []),
      ngayThanhLap: map['ngayThanhLap'] ?? '',
      giaoVienPhuTrach: map['giaoVienPhuTrach'] ?? '',
      mieuTa: map['mieuTa'] ?? '',
      quyDinh: map['quyDinh'] ?? '',
      clubId: map['clubId'] ?? 0,
      budget: map['budget'] ?? 0,
      tinhTrang: map['tinhTrang'] ?? '',
      truongBanCLB: map['truongBanCLB'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'ten': ten,
      'logo': logo,
      'linhVucHoatDong': linhVucHoatDong,
      'thanhVien': thanhVien,
      'ngayThanhLap': ngayThanhLap,
      'giaoVienPhuTrach': giaoVienPhuTrach,
      'mieuTa': mieuTa,
      'quyDinh': quyDinh,
      'clubId': clubId,
      'budget': budget,
      'tinhTrang': tinhTrang,
      'truongBanCLB': truongBanCLB,
    };
  }

  Club copyWith({
    String? id,
    String? ten,
    String? logo,
    String? linhVucHoatDong,
    List<String>? thanhVien,
    String? ngayThanhLap,
    String? giaoVienPhuTrach,
    String? mieuTa,
    String? quyDinh,
    int? clubId,
    int? budget,
    String? tinhTrang,
    String? truongBanCLB,
  }) {
    return Club(
      id: id ?? this.id,
      ten: ten ?? this.ten,
      logo: logo ?? this.logo,
      linhVucHoatDong: linhVucHoatDong ?? this.linhVucHoatDong,
      thanhVien: thanhVien ?? this.thanhVien,
      ngayThanhLap: ngayThanhLap ?? this.ngayThanhLap,
      giaoVienPhuTrach: giaoVienPhuTrach ?? this.giaoVienPhuTrach,
      mieuTa: mieuTa ?? this.mieuTa,
      quyDinh: quyDinh ?? this.quyDinh,
      clubId: clubId ?? this.clubId,
      budget: budget ?? this.budget,
      tinhTrang: tinhTrang ?? this.tinhTrang,
      truongBanCLB: truongBanCLB ?? this.truongBanCLB,
    );
  }

  bool get isActive => tinhTrang == 'Còn hoạt động';
} 