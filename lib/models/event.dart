class Event {
  final String id;
  final String ten;
  final String ngayToChuc;
  final String thoiGianBatDau;
  final String thoiGianKetThuc;
  final String diaDiem;
  final String noiDung;
  final String nguoiPhuTrach;
  final List<String> khachMoi;
  final String club;
  final String trangThai;

  const Event({
    required this.id,
    required this.ten,
    required this.ngayToChuc,
    required this.thoiGianBatDau,
    required this.thoiGianKetThuc,
    required this.diaDiem,
    required this.noiDung,
    required this.nguoiPhuTrach,
    required this.khachMoi,
    required this.club,
    required this.trangThai,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['_id'] ?? '',
      ten: map['ten'] ?? '',
      ngayToChuc: map['ngayToChuc'] ?? '',
      thoiGianBatDau: map['thoiGianBatDau'] ?? '',
      thoiGianKetThuc: map['thoiGianKetThuc'] ?? '',
      diaDiem: map['diaDiem'] ?? '',
      noiDung: map['noiDung'] ?? '',
      nguoiPhuTrach: map['nguoiPhuTrach'] ?? '',
      khachMoi: List<String>.from(map['khachMoi'] ?? []),
      club: map['club'] ?? '',
      trangThai: map['trangThai'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'ten': ten,
      'ngayToChuc': ngayToChuc,
      'thoiGianBatDau': thoiGianBatDau,
      'thoiGianKetThuc': thoiGianKetThuc,
      'diaDiem': diaDiem,
      'noiDung': noiDung,
      'nguoiPhuTrach': nguoiPhuTrach,
      'khachMoi': khachMoi,
      'club': club,
      'trangThai': trangThai,
    };
  }

  Event copyWith({
    String? id,
    String? ten,
    String? ngayToChuc,
    String? thoiGianBatDau,
    String? thoiGianKetThuc,
    String? diaDiem,
    String? noiDung,
    String? nguoiPhuTrach,
    List<String>? khachMoi,
    String? club,
    String? trangThai,
  }) {
    return Event(
      id: id ?? this.id,
      ten: ten ?? this.ten,
      ngayToChuc: ngayToChuc ?? this.ngayToChuc,
      thoiGianBatDau: thoiGianBatDau ?? this.thoiGianBatDau,
      thoiGianKetThuc: thoiGianKetThuc ?? this.thoiGianKetThuc,
      diaDiem: diaDiem ?? this.diaDiem,
      noiDung: noiDung ?? this.noiDung,
      nguoiPhuTrach: nguoiPhuTrach ?? this.nguoiPhuTrach,
      khachMoi: khachMoi ?? this.khachMoi,
      club: club ?? this.club,
      trangThai: trangThai ?? this.trangThai,
    );
  }
} 