import '../models/budget.dart';

class BudgetDataService {
  static final BudgetDataService _instance = BudgetDataService._internal();
  factory BudgetDataService() => _instance;
  BudgetDataService._internal();

  final List<Budget> _budgets = [
    Budget(
      id: 18,
      ten: 'Ngân sách tổ chức sự kiện IT Day',
      khoanChiTieu: 4000000,
      nguonThu: 5000000,
      ngay: '2024-11-19',
      thanhVienChiuTrachNhiem: 'Nguyễn Phi Quốc Bảo',
      noiDung: 'Ngân sách thu từ việc bán vé và chi tiêu tổ chức sự kiện',
      club: '67160c5ad55fc5f816de7644',
    ),
    Budget(
      id: 19,
      ten: 'Ngân sách Hackathon X',
      khoanChiTieu: 3500000,
      nguonThu: 4200000,
      ngay: '2024-12-15',
      thanhVienChiuTrachNhiem: 'Trần Văn B',
      noiDung: 'Ngân sách cho cuộc thi lập trình 24h',
      club: '67160c5ad55fc5f816de7644',
    ),
    Budget(
      id: 20,
      ten: 'Ngân sách Workshop AI',
      khoanChiTieu: 2500000,
      nguonThu: 3000000,
      ngay: '2024-10-30',
      thanhVienChiuTrachNhiem: 'Lê Thị C',
      noiDung: 'Chi phí tổ chức workshop về trí tuệ nhân tạo',
      club: '67160c5ad55fc5f816de7644',
    ),
  ];

  List<Budget> getAllBudgets() => List.from(_budgets);

  Budget? getBudgetById(int id) {
    try {
      return _budgets.firstWhere((budget) => budget.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Budget> getBudgetsByClub(String clubId) {
    return _budgets.where((budget) => budget.club == clubId).toList();
  }

  List<Budget> getBudgetsByDateRange(DateTime startDate, DateTime endDate) {
    return _budgets.where((budget) {
      final budgetDate = DateTime.parse(budget.ngay);
      return budgetDate.isAfter(startDate.subtract(Duration(days: 1))) &&
             budgetDate.isBefore(endDate.add(Duration(days: 1)));
    }).toList();
  }

  List<Budget> getBudgetsByYear(String year) {
    return _budgets.where((budget) => budget.ngay.startsWith(year)).toList();
  }

  void addBudget(Budget budget) {
    _budgets.add(budget);
  }

  void updateBudget(Budget updatedBudget) {
    final index = _budgets.indexWhere((budget) => budget.id == updatedBudget.id);
    if (index != -1) {
      _budgets[index] = updatedBudget;
    }
  }

  void deleteBudget(int id) {
    _budgets.removeWhere((budget) => budget.id == id);
  }

  List<Budget> searchBudgets(String query) {
    if (query.isEmpty) return getAllBudgets();
    
    final lowerQuery = query.toLowerCase();
    return _budgets.where((budget) =>
      budget.ten.toLowerCase().contains(lowerQuery) ||
      budget.thanhVienChiuTrachNhiem.toLowerCase().contains(lowerQuery) ||
      budget.noiDung.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  List<Budget> filterBudgets({String? club, String? year, String? personInCharge}) {
    var filtered = getAllBudgets();
    
    if (club != null && club != 'Tất cả') {
      filtered = filtered.where((budget) => budget.club == club).toList();
    }
    
    if (year != null && year != 'Tất cả') {
      filtered = filtered.where((budget) => budget.ngay.startsWith(year)).toList();
    }
    
    if (personInCharge != null && personInCharge != 'Tất cả') {
      filtered = filtered.where((budget) => budget.thanhVienChiuTrachNhiem == personInCharge).toList();
    }
    
    return filtered;
  }

  int getTotalIncome() {
    return _budgets.fold(0, (sum, budget) => sum + budget.nguonThu);
  }

  int getTotalExpenditure() {
    return _budgets.fold(0, (sum, budget) => sum + budget.khoanChiTieu);
  }

  int getTotalProfit() {
    return getTotalIncome() - getTotalExpenditure();
  }
} 