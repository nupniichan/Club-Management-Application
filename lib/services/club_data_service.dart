import '../models/club.dart';

class ClubDataService {
  static final ClubDataService _instance = ClubDataService._internal();
  factory ClubDataService() => _instance;
  ClubDataService._internal();

  final List<Club> _clubs = [
    Club(
      id: '67160c5ad55fc5f816de7644',
      ten: 'Câu lạc bộ tin học',
      logo: '/uploads/d034915e14df6c0d63b832c64483d6f6',
      linhVucHoatDong: 'Công Nghệ',
      thanhVien: ['HS123456', 'HS123457', 'HS123458', 'HS123459', 'HS123460', 'HS123461'],
      ngayThanhLap: '2024-10-21T00:00:00.000Z',
      giaoVienPhuTrach: 'Thầy Nguyễn Văn A',
      mieuTa: 'Câu lạc bộ tin học là nơi dành cho các bạn đam mê công nghệ và lập trình...',
      quyDinh: 'Phải có mặt vào cuối tuần',
      clubId: 20,
      budget: 2000000,
      tinhTrang: 'Còn hoạt động',
      truongBanCLB: 'HS123456',
    ),
    Club(
      id: '67160c5ad55fc5f816de7645',
      ten: 'Câu lạc bộ Âm nhạc',
      logo: '/uploads/music_club.jpg',
      linhVucHoatDong: 'Nghệ thuật',
      thanhVien: ['HS123470', 'HS123471', 'HS123472', 'HS123473'],
      ngayThanhLap: '2024-09-15T00:00:00.000Z',
      giaoVienPhuTrach: 'Cô Trần Thị B',
      mieuTa: 'CLB âm nhạc dành cho những bạn yêu thích nghệ thuật âm nhạc',
      quyDinh: 'Tham gia đầy đủ các buổi tập',
      clubId: 21,
      budget: 1500000,
      tinhTrang: 'Còn hoạt động',
      truongBanCLB: 'HS123470',
    ),
    Club(
      id: '67160c5ad55fc5f816de7646',
      ten: 'Câu lạc bộ Thể thao',
      logo: '/uploads/sport_club.jpg',
      linhVucHoatDong: 'Thể thao',
      thanhVien: ['HS123480', 'HS123481'],
      ngayThanhLap: '2024-08-10T00:00:00.000Z',
      giaoVienPhuTrach: 'Thầy Lê Văn C',
      mieuTa: 'CLB thể thao tổ chức các hoạt động rèn luyện sức khỏe',
      quyDinh: 'Tập luyện đều đặn',
      clubId: 22,
      budget: 3000000,
      tinhTrang: 'Tạm dừng',
      truongBanCLB: 'HS123480',
    ),
  ];

  List<Club> getAllClubs() => List.from(_clubs);

  Club? getClubById(String id) {
    try {
      return _clubs.firstWhere((club) => club.id == id);
    } catch (e) {
      return null;
    }
  }

  Club? getClubByClubId(int clubId) {
    try {
      return _clubs.firstWhere((club) => club.clubId == clubId);
    } catch (e) {
      return null;
    }
  }

  List<Club> getClubsByActivity(String linhVucHoatDong) {
    return _clubs.where((club) => club.linhVucHoatDong == linhVucHoatDong).toList();
  }

  List<Club> getClubsByStatus(String tinhTrang) {
    return _clubs.where((club) => club.tinhTrang == tinhTrang).toList();
  }

  List<Club> getActiveClubs() {
    return _clubs.where((club) => club.isActive).toList();
  }

  void addClub(Club club) {
    _clubs.add(club);
  }

  void updateClub(Club updatedClub) {
    final index = _clubs.indexWhere((club) => club.id == updatedClub.id);
    if (index != -1) {
      _clubs[index] = updatedClub;
    }
  }

  void deleteClub(String id) {
    _clubs.removeWhere((club) => club.id == id);
  }

  List<Club> searchClubs(String query) {
    if (query.isEmpty) return getAllClubs();
    
    final lowerQuery = query.toLowerCase();
    return _clubs.where((club) =>
      club.ten.toLowerCase().contains(lowerQuery) ||
      club.linhVucHoatDong.toLowerCase().contains(lowerQuery) ||
      club.giaoVienPhuTrach.toLowerCase().contains(lowerQuery) ||
      club.mieuTa.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  List<Club> filterClubs({String? linhVucHoatDong, String? tinhTrang}) {
    var filtered = getAllClubs();
    
    if (linhVucHoatDong != null && linhVucHoatDong != 'Tất cả') {
      filtered = filtered.where((club) => club.linhVucHoatDong == linhVucHoatDong).toList();
    }
    
    if (tinhTrang != null && tinhTrang != 'Tất cả') {
      filtered = filtered.where((club) => club.tinhTrang == tinhTrang).toList();
    }
    
    return filtered;
  }

  int getTotalBudget() {
    return _clubs.fold(0, (sum, club) => sum + club.budget);
  }

  int getTotalMembers() {
    return _clubs.fold(0, (sum, club) => sum + club.thanhVien.length);
  }

  Map<String, int> getClubStatsByActivity() {
    final stats = <String, int>{};
    for (final club in _clubs) {
      stats[club.linhVucHoatDong] = (stats[club.linhVucHoatDong] ?? 0) + 1;
    }
    return stats;
  }
} 