import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  User? _currentUser;
  User? get currentUser => _currentUser;

  // Dữ liệu mẫu cho đăng nhập
  final Map<String, Map<String, dynamic>> _sampleUsers = {
    'quanly@club.com': {
      'id': '1',
      'password': '123456',
      'name': 'Nguyễn Văn Quản',
      'email': 'quanly@club.com',
      'role': 'Quản lý',
      'createdAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      'isActive': true,
    },
    'hocsinh@club.com': {
      'id': '2',
      'password': '123456',
      'name': 'Trần Thị Học',
      'email': 'hocsinh@club.com',
      'role': 'Học sinh',
      'createdAt': DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
      'isActive': true,
    },
  };

  // Đăng nhập
  Future<AuthResult> login(String email, String password) async {
    try {
      // Giả lập thời gian xử lý
      await Future.delayed(const Duration(seconds: 2));

      if (_sampleUsers.containsKey(email)) {
        final userData = _sampleUsers[email]!;
        if (userData['password'] == password) {
          // Tạo User object
          _currentUser = User.fromMap(userData);
          return AuthResult.success(_currentUser!);
        } else {
          return AuthResult.failure('Mật khẩu không đúng');
        }
      } else {
        return AuthResult.failure('Email không tồn tại');
      }
    } catch (e) {
      return AuthResult.failure('Đã xảy ra lỗi: ${e.toString()}');
    }
  }

  // Đăng xuất
  void logout() {
    _currentUser = null;
  }

  // Kiểm tra trạng thái đăng nhập
  bool get isLoggedIn => _currentUser != null;

  // Lấy danh sách tài khoản mẫu (để hiển thị)
  List<Map<String, String>> getSampleAccounts() {
    return [
      {
        'title': 'Tài khoản Quản lý',
        'email': 'quanly@club.com',
        'password': '123456',
        'role': 'Quản lý',
      },
      {
        'title': 'Tài khoản Học sinh',
        'email': 'hocsinh@club.com',
        'password': '123456',
        'role': 'Học sinh',
      },
    ];
  }

  // Kiểm tra quyền
  bool hasPermission(String permission) {
    if (_currentUser == null) return false;
    
    switch (_currentUser!.role) {
      case 'Quản lý':
        return true; // Quản lý có tất cả quyền
      case 'Học sinh':
        // Học sinh chỉ có một số quyền nhất định
        return ['view_members', 'view_activities'].contains(permission);
      default:
        return false;
    }
  }
}

// Class để trả về kết quả đăng nhập
class AuthResult {
  final bool isSuccess;
  final String? errorMessage;
  final User? user;

  AuthResult._({
    required this.isSuccess,
    this.errorMessage,
    this.user,
  });

  factory AuthResult.success(User user) {
    return AuthResult._(
      isSuccess: true,
      user: user,
    );
  }

  factory AuthResult.failure(String message) {
    return AuthResult._(
      isSuccess: false,
      errorMessage: message,
    );
  }
} 