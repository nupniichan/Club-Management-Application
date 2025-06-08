class ReportEvent {
  final String ten;
  final String nguoiPhuTrach;
  final String ngayToChuc;
  final String diaDiem;

  const ReportEvent({
    required this.ten,
    required this.nguoiPhuTrach,
    required this.ngayToChuc,
    required this.diaDiem,
  });

  factory ReportEvent.fromMap(Map<String, dynamic> map) {
    return ReportEvent(
      ten: map['ten'] ?? '',
      nguoiPhuTrach: map['nguoiPhuTrach'] ?? '',
      ngayToChuc: map['ngayToChuc'] ?? '',
      diaDiem: map['diaDiem'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ten': ten,
      'nguoiPhuTrach': nguoiPhuTrach,
      'ngayToChuc': ngayToChuc,
      'diaDiem': diaDiem,
    };
  }
}

class ReportAward {
  final String tenGiai;
  final String loaiGiai;
  final String ngayDatGiai;
  final String thanhVienDatGiai;

  const ReportAward({
    required this.tenGiai,
    required this.loaiGiai,
    required this.ngayDatGiai,
    required this.thanhVienDatGiai,
  });

  factory ReportAward.fromMap(Map<String, dynamic> map) {
    return ReportAward(
      tenGiai: map['tenGiai'] ?? '',
      loaiGiai: map['loaiGiai'] ?? '',
      ngayDatGiai: map['ngayDatGiai'] ?? '',
      thanhVienDatGiai: map['thanhVienDatGiai'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tenGiai': tenGiai,
      'loaiGiai': loaiGiai,
      'ngayDatGiai': ngayDatGiai,
      'thanhVienDatGiai': thanhVienDatGiai,
    };
  }
}

class Report {
  final String id;
  final String tenBaoCao;
  final String ngayBaoCao;
  final String nhanSuPhuTrach;
  final List<ReportEvent> danhSachSuKien;
  final List<ReportAward> danhSachGiai;
  final int tongNganSachChiTieu;
  final int tongThu;
  final String ketQuaDatDuoc;
  final String club;
  // For simple event/award lists (student reports)
  final List<String>? danhSachSuKienSimple;
  final List<String>? danhSachGiaiSimple;

  const Report({
    required this.id,
    required this.tenBaoCao,
    required this.ngayBaoCao,
    required this.nhanSuPhuTrach,
    required this.danhSachSuKien,
    required this.danhSachGiai,
    required this.tongNganSachChiTieu,
    required this.tongThu,
    required this.ketQuaDatDuoc,
    required this.club,
    this.danhSachSuKienSimple,
    this.danhSachGiaiSimple,
  });

  factory Report.fromMap(Map<String, dynamic> map) {
    List<ReportEvent> events = [];
    List<ReportAward> awards = [];
    List<String>? simpleEvents;
    List<String>? simpleAwards;

    // Handle complex event structure (manager reports)
    if (map['danhSachSuKien'] is List && map['danhSachSuKien'].isNotEmpty && map['danhSachSuKien'][0] is Map) {
      events = (map['danhSachSuKien'] as List)
          .map((e) => ReportEvent.fromMap(e))
          .toList();
    }
    // Handle simple event structure (student reports)
    else if (map['danhSachSuKien'] is List) {
      simpleEvents = List<String>.from(map['danhSachSuKien'] ?? []);
    }

    // Handle complex award structure (manager reports)
    if (map['danhSachGiai'] is List && map['danhSachGiai'].isNotEmpty && map['danhSachGiai'][0] is Map) {
      awards = (map['danhSachGiai'] as List)
          .map((e) => ReportAward.fromMap(e))
          .toList();
    }
    // Handle simple award structure (student reports)
    else if (map['danhSachGiai'] is List) {
      simpleAwards = List<String>.from(map['danhSachGiai'] ?? []);
    }

    return Report(
      id: map['_id'] ?? '',
      tenBaoCao: map['tenBaoCao'] ?? '',
      ngayBaoCao: map['ngayBaoCao'] ?? '',
      nhanSuPhuTrach: map['nhanSuPhuTrach'] ?? '',
      danhSachSuKien: events,
      danhSachGiai: awards,
      tongNganSachChiTieu: map['tongNganSachChiTieu'] ?? 0,
      tongThu: map['tongThu'] ?? 0,
      ketQuaDatDuoc: map['ketQuaDatDuoc'] ?? '',
      club: map['club'] ?? '',
      danhSachSuKienSimple: simpleEvents,
      danhSachGiaiSimple: simpleAwards,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'tenBaoCao': tenBaoCao,
      'ngayBaoCao': ngayBaoCao,
      'nhanSuPhuTrach': nhanSuPhuTrach,
      'danhSachSuKien': danhSachSuKienSimple ?? danhSachSuKien.map((e) => e.toMap()).toList(),
      'danhSachGiai': danhSachGiaiSimple ?? danhSachGiai.map((e) => e.toMap()).toList(),
      'tongNganSachChiTieu': tongNganSachChiTieu,
      'tongThu': tongThu,
      'ketQuaDatDuoc': ketQuaDatDuoc,
      'club': club,
    };
  }

  Report copyWith({
    String? id,
    String? tenBaoCao,
    String? ngayBaoCao,
    String? nhanSuPhuTrach,
    List<ReportEvent>? danhSachSuKien,
    List<ReportAward>? danhSachGiai,
    int? tongNganSachChiTieu,
    int? tongThu,
    String? ketQuaDatDuoc,
    String? club,
    List<String>? danhSachSuKienSimple,
    List<String>? danhSachGiaiSimple,
  }) {
    return Report(
      id: id ?? this.id,
      tenBaoCao: tenBaoCao ?? this.tenBaoCao,
      ngayBaoCao: ngayBaoCao ?? this.ngayBaoCao,
      nhanSuPhuTrach: nhanSuPhuTrach ?? this.nhanSuPhuTrach,
      danhSachSuKien: danhSachSuKien ?? this.danhSachSuKien,
      danhSachGiai: danhSachGiai ?? this.danhSachGiai,
      tongNganSachChiTieu: tongNganSachChiTieu ?? this.tongNganSachChiTieu,
      tongThu: tongThu ?? this.tongThu,
      ketQuaDatDuoc: ketQuaDatDuoc ?? this.ketQuaDatDuoc,
      club: club ?? this.club,
      danhSachSuKienSimple: danhSachSuKienSimple ?? this.danhSachSuKienSimple,
      danhSachGiaiSimple: danhSachGiaiSimple ?? this.danhSachGiaiSimple,
    );
  }

  int get profit => tongThu - tongNganSachChiTieu;
  
  bool get isProfit => profit >= 0;
} 