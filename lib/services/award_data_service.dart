import '../models/award.dart';

class AwardDataService {
  static final AwardDataService _instance = AwardDataService._internal();
  factory AwardDataService() => _instance;
  AwardDataService._internal();

  final List<Award> _awards = [
    Award(
      id: '673c5ce77f6aae48b37a8561',
      tenGiaiThuong: 'Code competitive',
      ngayDatGiai: '2024-11-18',
      loaiGiai: 'Giải nhì',
      thanhVienDatGiai: 'Nguyễn Văn A',
      ghiChu: 'Cuộc thi lập trình xuất sắc',
      anhDatGiai: '1732029750179.jpg',
    ),
    Award(
      id: '673c5ce77f6aae48b37a8562',
      tenGiaiThuong: 'Hackathon Mobile App',
      ngayDatGiai: '2024-10-15',
      loaiGiai: 'Giải nhất',
      thanhVienDatGiai: 'Trần Thị B',
      ghiChu: 'Phát triển ứng dụng di động sáng tạo',
      anhDatGiai: '1732029750180.jpg',
    ),
    Award(
      id: '673c5ce77f6aae48b37a8563',
      tenGiaiThuong: 'AI Challenge',
      ngayDatGiai: '2024-09-20',
      loaiGiai: 'Giải ba',
      thanhVienDatGiai: 'Lê Văn C',
      ghiChu: 'Nghiên cứu và ứng dụng AI',
      anhDatGiai: '1732029750181.jpg',
    ),
  ];

  List<Award> getAllAwards() => List.from(_awards);

  Award? getAwardById(String id) {
    try {
      return _awards.firstWhere((award) => award.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Award> getAwardsByType(String loaiGiai) {
    return _awards.where((award) => award.loaiGiai == loaiGiai).toList();
  }

  List<Award> getAwardsByMember(String thanhVienDatGiai) {
    return _awards.where((award) => award.thanhVienDatGiai == thanhVienDatGiai).toList();
  }

  List<Award> getAwardsByDateRange(DateTime startDate, DateTime endDate) {
    return _awards.where((award) {
      final awardDate = DateTime.parse(award.ngayDatGiai);
      return awardDate.isAfter(startDate.subtract(Duration(days: 1))) &&
             awardDate.isBefore(endDate.add(Duration(days: 1)));
    }).toList();
  }

  List<Award> getAwardsByYear(String year) {
    return _awards.where((award) => award.ngayDatGiai.startsWith(year)).toList();
  }

  void addAward(Award award) {
    _awards.add(award);
  }

  void updateAward(Award updatedAward) {
    final index = _awards.indexWhere((award) => award.id == updatedAward.id);
    if (index != -1) {
      _awards[index] = updatedAward;
    }
  }

  void deleteAward(String id) {
    _awards.removeWhere((award) => award.id == id);
  }

  List<Award> searchAwards(String query) {
    if (query.isEmpty) return getAllAwards();
    
    final lowerQuery = query.toLowerCase();
    return _awards.where((award) =>
      award.tenGiaiThuong.toLowerCase().contains(lowerQuery) ||
      award.loaiGiai.toLowerCase().contains(lowerQuery) ||
      award.thanhVienDatGiai.toLowerCase().contains(lowerQuery) ||
      award.ghiChu.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  List<Award> filterAwards({String? loaiGiai, String? year}) {
    var filtered = getAllAwards();
    
    if (loaiGiai != null && loaiGiai != 'Tất cả') {
      filtered = filtered.where((award) => award.loaiGiai == loaiGiai).toList();
    }
    
    if (year != null && year != 'Tất cả') {
      filtered = filtered.where((award) => award.ngayDatGiai.startsWith(year)).toList();
    }
    
    return filtered;
  }

  Map<String, int> getAwardStatistics() {
    final stats = <String, int>{};
    for (final award in _awards) {
      stats[award.loaiGiai] = (stats[award.loaiGiai] ?? 0) + 1;
    }
    return stats;
  }
} 