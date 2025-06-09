import '../models/budget_allocation.dart';

class BudgetAllocationDataService {
  static final BudgetAllocationDataService _instance = BudgetAllocationDataService._internal();
  factory BudgetAllocationDataService() => _instance;
  BudgetAllocationDataService._internal();

  final List<BudgetAllocation> _allocations = [
    BudgetAllocation(
      id: 10,
      club: '67160c5ad55fc5f816de7644',
      clubName: 'Câu lạc bộ tin học',
      amount: 1000000,
      purpose: 'Thưởng câu lạc bộ mang về thành tích xuất sắc cho trường',
      allocationDate: '2024-11-19',
    ),
    BudgetAllocation(
      id: 11,
      club: '67160c5ad55fc5f816de7644',
      clubName: 'Câu lạc bộ tin học',
      amount: 2500000,
      purpose: 'Hỗ trợ tổ chức sự kiện IT Day',
      allocationDate: '2024-11-15',
    ),
    BudgetAllocation(
      id: 12,
      club: '67160c5ad55fc5f816de7645',
      clubName: 'Câu lạc bộ Toán học',
      amount: 1500000,
      purpose: 'Mua sách và tài liệu học tập',
      allocationDate: '2024-11-10',
    ),
  ];

  List<BudgetAllocation> getAllAllocations() => List.from(_allocations);

  BudgetAllocation? getAllocationById(int id) {
    try {
      return _allocations.firstWhere((allocation) => allocation.id == id);
    } catch (e) {
      return null;
    }
  }

  List<BudgetAllocation> getAllocationsByClub(String clubId) {
    return _allocations.where((allocation) => allocation.club == clubId).toList();
  }

  List<BudgetAllocation> getAllocationsByClubName(String clubName) {
    return _allocations.where((allocation) => allocation.clubName.toLowerCase().contains(clubName.toLowerCase())).toList();
  }

  List<BudgetAllocation> getAllocationsByDateRange(DateTime startDate, DateTime endDate) {
    return _allocations.where((allocation) {
      final allocationDate = DateTime.parse(allocation.allocationDate);
      return allocationDate.isAfter(startDate.subtract(Duration(days: 1))) &&
             allocationDate.isBefore(endDate.add(Duration(days: 1)));
    }).toList();
  }

  List<BudgetAllocation> getAllocationsByYear(String year) {
    return _allocations.where((allocation) => allocation.allocationDate.startsWith(year)).toList();
  }

  void addAllocation(BudgetAllocation allocation) {
    _allocations.add(allocation);
  }

  void updateAllocation(BudgetAllocation updatedAllocation) {
    final index = _allocations.indexWhere((allocation) => allocation.id == updatedAllocation.id);
    if (index != -1) {
      _allocations[index] = updatedAllocation;
    }
  }

  void deleteAllocation(int id) {
    _allocations.removeWhere((allocation) => allocation.id == id);
  }

  List<BudgetAllocation> searchAllocations(String query) {
    if (query.isEmpty) return getAllAllocations();
    
    final lowerQuery = query.toLowerCase();
    return _allocations.where((allocation) =>
      allocation.clubName.toLowerCase().contains(lowerQuery) ||
      allocation.purpose.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  List<BudgetAllocation> filterAllocations({String? club, String? year, int? minAmount, int? maxAmount}) {
    var filtered = getAllAllocations();
    
    if (club != null && club != 'Tất cả') {
      filtered = filtered.where((allocation) => allocation.club == club).toList();
    }
    
    if (year != null && year != 'Tất cả') {
      filtered = filtered.where((allocation) => allocation.allocationDate.startsWith(year)).toList();
    }
    
    if (minAmount != null) {
      filtered = filtered.where((allocation) => allocation.amount >= minAmount).toList();
    }
    
    if (maxAmount != null) {
      filtered = filtered.where((allocation) => allocation.amount <= maxAmount).toList();
    }
    
    return filtered;
  }

  int getTotalAllocatedAmount() {
    return _allocations.fold(0, (sum, allocation) => sum + allocation.amount);
  }

  int getTotalAllocationsByClub(String clubId) {
    return _allocations.where((allocation) => allocation.club == clubId)
                      .fold(0, (sum, allocation) => sum + allocation.amount);
  }

  Map<String, int> getAllocationStatsByClub() {
    final stats = <String, int>{};
    for (final allocation in _allocations) {
      stats[allocation.clubName] = (stats[allocation.clubName] ?? 0) + allocation.amount;
    }
    return stats;
  }

  int getNextId() {
    if (_allocations.isEmpty) return 1;
    return _allocations.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
  }
} 