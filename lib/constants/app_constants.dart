import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'Quản Lý Câu Lạc Bộ';
  static const String appVersion = '1.0.0';

  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.blueAccent;
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color warningColor = Colors.orange;
  static const Color backgroundColor = Colors.white;
  static const Color textPrimaryColor = Colors.black87;
  static const Color textSecondaryColor = Colors.grey;

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 24.0;
  static const double fontSizeTitle = 32.0;

  // Animation Durations
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);

  // User Roles
  static const String roleManager = 'Quản lý';
  static const String roleStudent = 'Học sinh';

  // Permissions
  static const String permissionViewMembers = 'view_members';
  static const String permissionEditMembers = 'edit_members';
  static const String permissionDeleteMembers = 'delete_members';
  static const String permissionViewActivities = 'view_activities';
  static const String permissionEditActivities = 'edit_activities';
  static const String permissionDeleteActivities = 'delete_activities';
  static const String permissionViewReports = 'view_reports';
  static const String permissionManageSettings = 'manage_settings';

  // API Endpoints (for future use)
  static const String baseUrl = 'https://api.example.com';
  static const String loginEndpoint = '/auth/login';
  static const String logoutEndpoint = '/auth/logout';
  static const String usersEndpoint = '/users';
  static const String activitiesEndpoint = '/activities';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int maxNameLength = 100;
  static const int maxEmailLength = 255;

  // Images
  static const String defaultProfileImage = 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80';
  static const String loginBackgroundImage = 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80';

  // Messages
  static const String loginSuccessMessage = 'Đăng nhập thành công!';
  static const String loginFailureMessage = 'Email hoặc mật khẩu không đúng!';
  static const String logoutMessage = 'Đã đăng xuất thành công!';
  static const String networkErrorMessage = 'Lỗi kết nối mạng. Vui lòng thử lại!';
  static const String unknownErrorMessage = 'Đã xảy ra lỗi không xác định!';

  // Feature Names
  static const String featureMemberManagement = 'Quản lý thành viên';
  static const String featureActivityManagement = 'Quản lý hoạt động';
  static const String featureReports = 'Báo cáo';
  static const String featureSettings = 'Cài đặt';
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppConstants.primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingMedium,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
    );
  }
} 