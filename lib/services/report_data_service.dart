import '../models/report.dart';

class ReportDataService {
  static final ReportDataService _instance = ReportDataService._internal();
  factory ReportDataService() => _instance;
  ReportDataService._internal();

  // Manager reports with complex structure
  final List<Report> _managerReports = [
    Report(
      id: '673c6cb889b097623521cf58',
      tenBaoCao: 'Báo cáo tháng 11',
      ngayBaoCao: '2024-11-19T00:00:00.000Z',
      nhanSuPhuTrach: 'Nguyễn Phi Quốc Bảo',
      danhSachSuKien: [
        ReportEvent(
          ten: 'IT Day',
          nguoiPhuTrach: 'Nguyễn Phi Quốc Bảo',
          ngayToChuc: '2024-11-22T00:00:00.000Z',
          diaDiem: 'Sân trường',
        ),
      ],
      danhSachGiai: [
        ReportAward(
          tenGiai: 'Giải Nhất Lập trình',
          loaiGiai: 'Cấp trường',
          ngayDatGiai: '2024-11-20T00:00:00.000Z',
          thanhVienDatGiai: 'Trần Văn A',
        ),
      ],
      tongNganSachChiTieu: 4000000,
      tongThu: 5000000,
      ketQuaDatDuoc: 'Sự kiện diễn ra hơn cả mong đợi, các doanh nghiệp muốn hợp tác với câu lạc bộ trong tương lai',
      club: '67160c5ad55fc5f816de7644',
    ),
    Report(
      id: '673c6cb889b097623521cf59',
      tenBaoCao: 'Báo cáo tháng 10',
      ngayBaoCao: '2024-10-25T00:00:00.000Z',
      nhanSuPhuTrach: 'Trần Văn B',
      danhSachSuKien: [
        ReportEvent(
          ten: 'Workshop Lập trình Web',
          nguoiPhuTrach: 'Trần Văn A',
          ngayToChuc: '2024-10-20T00:00:00.000Z',
          diaDiem: 'Phòng Lab A',
        ),
      ],
      danhSachGiai: [],
      tongNganSachChiTieu: 2000000,
      tongThu: 1500000,
      ketQuaDatDuoc: 'Workshop được tổ chức thành công với sự tham gia đông đảo của sinh viên',
      club: '67160c5ad55fc5f816de7644',
    ),
  ];

  // Student reports with simple structure
  final List<Report> _studentReports = [
    Report(
      id: '673c6cb889b097623521cf61',
      tenBaoCao: 'Báo cáo tháng 11',
      ngayBaoCao: '2024-11-19',
      nhanSuPhuTrach: 'Nguyễn Phi Quốc Bảo',
      danhSachSuKien: [],
      danhSachGiai: [],
      tongNganSachChiTieu: 4000000,
      tongThu: 5000000,
      ketQuaDatDuoc: 'Sự kiện diễn ra hơn cả mong đợi, các doanh nghiệp muốn hợp tác với câu lạc bộ',
      club: '67160c5ad55fc5f816de7644',
      danhSachSuKienSimple: ['IT Day', 'Tech Talk'],
      danhSachGiaiSimple: ['Giải nhất cuộc thi lập trình'],
    ),
    Report(
      id: '673c6cb889b097623521cf62',
      tenBaoCao: 'Báo cáo tháng 10',
      ngayBaoCao: '2024-10-31',
      nhanSuPhuTrach: 'Trần Văn C',
      danhSachSuKien: [],
      danhSachGiai: [],
      tongNganSachChiTieu: 3500000,
      tongThu: 4200000,
      ketQuaDatDuoc: 'Tháng hoạt động tốt với nhiều sự kiện chất lượng',
      club: '67160c5ad55fc5f816de7644',
      danhSachSuKienSimple: ['Hackathon X', 'Workshop AI'],
      danhSachGiaiSimple: ['Giải khuyến khích AI Challenge'],
    ),
  ];

  List<Report> getAllManagerReports() => List.from(_managerReports);
  List<Report> getAllStudentReports() => List.from(_studentReports);

  Report? getManagerReportById(String id) {
    try {
      return _managerReports.firstWhere((report) => report.id == id);
    } catch (e) {
      return null;
    }
  }

  Report? getStudentReportById(String id) {
    try {
      return _studentReports.firstWhere((report) => report.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Report> getManagerReportsByClub(String clubId) {
    return _managerReports.where((report) => report.club == clubId).toList();
  }

  List<Report> getStudentReportsByClub(String clubId) {
    return _studentReports.where((report) => report.club == clubId).toList();
  }

  List<Report> getManagerReportsByDateRange(DateTime startDate, DateTime endDate) {
    return _managerReports.where((report) {
      final reportDate = DateTime.parse(report.ngayBaoCao);
      return reportDate.isAfter(startDate.subtract(Duration(days: 1))) &&
             reportDate.isBefore(endDate.add(Duration(days: 1)));
    }).toList();
  }

  List<Report> getStudentReportsByDateRange(DateTime startDate, DateTime endDate) {
    return _studentReports.where((report) {
      final reportDate = DateTime.parse(report.ngayBaoCao);
      return reportDate.isAfter(startDate.subtract(Duration(days: 1))) &&
             reportDate.isBefore(endDate.add(Duration(days: 1)));
    }).toList();
  }

  void addManagerReport(Report report) {
    _managerReports.add(report);
  }

  void addStudentReport(Report report) {
    _studentReports.add(report);
  }

  void updateManagerReport(Report updatedReport) {
    final index = _managerReports.indexWhere((report) => report.id == updatedReport.id);
    if (index != -1) {
      _managerReports[index] = updatedReport;
    }
  }

  void updateStudentReport(Report updatedReport) {
    final index = _studentReports.indexWhere((report) => report.id == updatedReport.id);
    if (index != -1) {
      _studentReports[index] = updatedReport;
    }
  }

  void deleteManagerReport(String id) {
    _managerReports.removeWhere((report) => report.id == id);
  }

  void deleteStudentReport(String id) {
    _studentReports.removeWhere((report) => report.id == id);
  }

  List<Report> searchManagerReports(String query) {
    if (query.isEmpty) return getAllManagerReports();
    
    final lowerQuery = query.toLowerCase();
    return _managerReports.where((report) =>
      report.tenBaoCao.toLowerCase().contains(lowerQuery) ||
      report.nhanSuPhuTrach.toLowerCase().contains(lowerQuery) ||
      report.ketQuaDatDuoc.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  List<Report> searchStudentReports(String query) {
    if (query.isEmpty) return getAllStudentReports();
    
    final lowerQuery = query.toLowerCase();
    return _studentReports.where((report) =>
      report.tenBaoCao.toLowerCase().contains(lowerQuery) ||
      report.nhanSuPhuTrach.toLowerCase().contains(lowerQuery) ||
      report.ketQuaDatDuoc.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  List<Report> filterManagerReports({String? club, String? year, String? staff}) {
    var filtered = getAllManagerReports();
    
    if (club != null && club != 'Tất cả') {
      filtered = filtered.where((report) => report.club == club).toList();
    }
    
    if (year != null && year != 'Tất cả') {
      filtered = filtered.where((report) => report.ngayBaoCao.startsWith(year)).toList();
    }
    
    if (staff != null && staff != 'Tất cả') {
      filtered = filtered.where((report) => report.nhanSuPhuTrach == staff).toList();
    }
    
    return filtered;
  }

  List<Report> filterStudentReports({String? club, String? year, String? staff}) {
    var filtered = getAllStudentReports();
    
    if (club != null && club != 'Tất cả') {
      filtered = filtered.where((report) => report.club == club).toList();
    }
    
    if (year != null && year != 'Tất cả') {
      filtered = filtered.where((report) => report.ngayBaoCao.startsWith(year)).toList();
    }
    
    if (staff != null && staff != 'Tất cả') {
      filtered = filtered.where((report) => report.nhanSuPhuTrach == staff).toList();
    }
    
    return filtered;
  }

  // Statistics methods
  int getTotalManagerIncome() {
    return _managerReports.fold(0, (sum, report) => sum + report.tongThu);
  }

  int getTotalManagerExpenditure() {
    return _managerReports.fold(0, (sum, report) => sum + report.tongNganSachChiTieu);
  }

  int getTotalStudentIncome() {
    return _studentReports.fold(0, (sum, report) => sum + report.tongThu);
  }

  int getTotalStudentExpenditure() {
    return _studentReports.fold(0, (sum, report) => sum + report.tongNganSachChiTieu);
  }

  int getTotalManagerProfit() {
    return getTotalManagerIncome() - getTotalManagerExpenditure();
  }

  int getTotalStudentProfit() {
    return getTotalStudentIncome() - getTotalStudentExpenditure();
  }
} 