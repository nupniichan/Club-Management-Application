import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
  static const String apiUrl = 'https://club-management-application.onrender.com/api';

  User? _currentUser;
  User? get currentUser => _currentUser;

  // Đăng nhập
  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final role = data['role'];
        
        print('Login Response Data: $data');
        
        // Decode JWT token để lấy userId
        final parts = token.split('.');
        if (parts.length != 3) {
          return AuthResult.failure('Token không hợp lệ');
        }
        
        final payload = parts[1];
        // Thêm padding nếu cần
        String normalized = payload;
        switch (payload.length % 4) {
          case 0:
            break;
          case 2:
            normalized += '==';
            break;
          case 3:
            normalized += '=';
            break;
          default:
            return AuthResult.failure('Token không hợp lệ');
        }
        
        final decoded = utf8.decode(base64.decode(normalized));
        final payloadMap = jsonDecode(decoded);
        final userId = payloadMap['userId'];
        
        print('Decoded userId from token: $userId');
        
        // Lưu thông tin cơ bản vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('role', role);
        await prefs.setString('userId', userId);

        // Lấy thông tin chi tiết của tài khoản
        try {
          final accountResponse = await http.get(
            Uri.parse('$apiUrl/get-account/$userId'),
            headers: {'Authorization': 'Bearer $token'},
          );

          print('Account API Status Code: ${accountResponse.statusCode}');
          print('Account API Response Body: ${accountResponse.body}');

          if (accountResponse.statusCode == 200) {
            final accountData = jsonDecode(accountResponse.body);
            print('Account Data parsed: $accountData');
            
            // Lưu thông tin tài khoản vào SharedPreferences
            await prefs.setString('userId', accountData['userId']);
            await prefs.setString('name', accountData['name']);
            await prefs.setString('email', accountData['email']);
            print('Saved account data to SharedPreferences');

            // Nếu là manager, cho phép đăng nhập trực tiếp
            if (role == 'manager') {
              print('User is manager, allowing direct login');
              _currentUser = User.fromMap({
                'id': accountData['userId'],
                'name': accountData['name'],
                'email': accountData['email'],
                'role': role,
              });
              return AuthResult.success(_currentUser!);
            }

            // Đối với các role khác, kiểm tra xem có quản lý CLB nào không
            print('User is not manager, checking clubs...');
            try {
              final clubsResponse = await http.get(
                Uri.parse('$apiUrl/check-account-clubs/${accountData['userId']}'),
                headers: {'Authorization': 'Bearer $token'},
              );
              
              print('Clubs API Status Code: ${clubsResponse.statusCode}');
              print('Clubs API Response: ${clubsResponse.body}');

              if (clubsResponse.statusCode == 200) {
                final clubsData = jsonDecode(clubsResponse.body);
                if (clubsData['hasActiveClubs']) {
                  print('User has active clubs, getting details...');
                  // Lấy thông tin chi tiết của CLB
                  final clubDetailsResponse = await http.get(
                    Uri.parse('$apiUrl/get-managed-clubs/${accountData['userId']}'),
                    headers: {'Authorization': 'Bearer $token'},
                  );
                  
                  print('Club Details API Status: ${clubDetailsResponse.statusCode}');
                  print('Club Details API Response: ${clubDetailsResponse.body}');

                                      if (clubDetailsResponse.statusCode == 200) {
                      final clubDetails = jsonDecode(clubDetailsResponse.body);
                      print('Club details parsed: $clubDetails');
                      await prefs.setString('managedClubs', jsonEncode(clubDetails));
                      print('Saved club details to SharedPreferences');
                      
                      _currentUser = User.fromMap({
                        'id': accountData['userId'],
                        'name': accountData['name'],
                        'email': accountData['email'],
                        'role': role,
                        'managedClubs': clubDetails,
                      });
                      print('Created user object: $_currentUser');
                      print('LOGIN SUCCESS - returning success result');
                      return AuthResult.success(_currentUser!);
                    } else {
                      print('Club details API failed with status: ${clubDetailsResponse.statusCode}');
                      return AuthResult.failure('Không thể lấy thông tin chi tiết câu lạc bộ.');
                    }
                } else {
                  print('User has no active clubs');
                  return AuthResult.failure('Bạn đang không quản lý câu lạc bộ nào. Vui lòng liên hệ quản trị viên.');
                }
              } else {
                print('Clubs API error status: ${clubsResponse.statusCode}');
                return AuthResult.failure('Có lỗi xảy ra khi kiểm tra thông tin câu lạc bộ.');
              }
            } catch (clubError) {
              print('Clubs API exception: $clubError');
              return AuthResult.failure('Có lỗi xảy ra khi kiểm tra thông tin câu lạc bộ: $clubError');
            }
          } else {
            return AuthResult.failure('Không thể lấy thông tin tài khoản. Status: ${accountResponse.statusCode}, Body: ${accountResponse.body}');
          }
        } catch (accountError) {
          print('Account API Error: $accountError');
          return AuthResult.failure('Có lỗi xảy ra khi lấy thông tin tài khoản: $accountError');
        }
      } else {
        final errorData = jsonDecode(response.body);
        return AuthResult.failure(errorData['message'] ?? 'Đăng nhập thất bại. Vui lòng kiểm tra lại email và mật khẩu.');
      }
    } catch (e) {
      return AuthResult.failure('Đã xảy ra lỗi: ${e.toString()}');
    }
    // Thêm return statement mặc định để đảm bảo null safety
    return AuthResult.failure('Đã xảy ra lỗi không xác định');
  }

  // Đăng xuất
  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Kiểm tra trạng thái đăng nhập
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

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
      case 'manager':
        return true; // Quản lý có tất cả quyền
      case 'student':
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