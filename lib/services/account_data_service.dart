import '../models/account.dart';

class AccountDataService {
  static final AccountDataService _instance = AccountDataService._internal();
  factory AccountDataService() => _instance;
  AccountDataService._internal();

  final List<Account> _accounts = [
    Account(
      id: '673afdefb543f47cb92cde93',
      userId: 'PS123456',
      name: 'Nguyễn Trần Văn B',
      email: 'PS123456@thpt.edu.vn',
      password: '123456',
      role: 'manager',
      status: 'Hoạt động',
      createdDate: '2024-11-17',
    ),
    Account(
      id: '673afdefb543f47cb92cde94',
      userId: 'HS123456',
      name: 'Trần Văn A',
      email: 'HS123456@thpt.edu.vn',
      password: '123456',
      role: 'student',
      status: 'Hoạt động',
      createdDate: '2024-11-18',
    ),
    Account(
      id: '673afdefb543f47cb92cde95',
      userId: 'HS123457',
      name: 'Lê Thị C',
      email: 'HS123457@thpt.edu.vn',
      password: '123456',
      role: 'student',
      status: 'Tạm khóa',
      createdDate: '2024-11-16',
    ),
  ];

  List<Account> getAllAccounts() => List.from(_accounts);

  Account? getAccountById(String id) {
    try {
      return _accounts.firstWhere((account) => account.id == id);
    } catch (e) {
      return null;
    }
  }

  Account? getAccountByUserId(String userId) {
    try {
      return _accounts.firstWhere((account) => account.userId == userId);
    } catch (e) {
      return null;
    }
  }

  List<Account> getAccountsByRole(String role) {
    return _accounts.where((account) => account.role == role).toList();
  }

  List<Account> getAccountsByStatus(String status) {
    return _accounts.where((account) => account.status == status).toList();
  }

  void addAccount(Account account) {
    _accounts.add(account);
  }

  void updateAccount(Account updatedAccount) {
    final index = _accounts.indexWhere((account) => account.id == updatedAccount.id);
    if (index != -1) {
      _accounts[index] = updatedAccount;
    }
  }

  void deleteAccount(String id) {
    _accounts.removeWhere((account) => account.id == id);
  }

  List<Account> searchAccounts(String query) {
    if (query.isEmpty) return getAllAccounts();
    
    final lowerQuery = query.toLowerCase();
    return _accounts.where((account) =>
      account.name.toLowerCase().contains(lowerQuery) ||
      account.email.toLowerCase().contains(lowerQuery) ||
      account.userId.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  List<Account> filterAccounts({String? role, String? status}) {
    var filtered = getAllAccounts();
    
    if (role != null && role != 'Tất cả') {
      String filterRole = role;
      switch (role) {
        case 'Quản lý':
          filterRole = 'manager';
          break;
        case 'Sinh viên':
          filterRole = 'student';
          break;
        case 'Giảng viên':
          filterRole = 'teacher';
          break;
      }
      filtered = filtered.where((account) => account.role == filterRole).toList();
    }
    
    if (status != null && status != 'Tất cả') {
      filtered = filtered.where((account) => account.status == status).toList();
    }
    
    return filtered;
  }
} 