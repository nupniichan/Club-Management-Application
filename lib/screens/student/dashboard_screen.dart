import 'package:flutter/material.dart';
import '../login_screen.dart';
import '../../constants/app_constants.dart';
import '../../services/auth_service.dart';
import '../../widgets/student/dashboard_chart_widget.dart';
import '../../widgets/student/stats_card_widget.dart';

class DashboardScreen extends StatelessWidget {
  final String userName;
  final String userRole;

  const DashboardScreen({
    super.key,
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quản Lý Câu Lạc Bộ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.primaryColor.withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.1),
                          child: Icon(
                            userRole == 'Quản lý' 
                                ? Icons.admin_panel_settings
                                : Icons.school,
                            size: 30,
                            color: AppConstants.primaryColor,
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chào mừng trở lại!',
                                style: TextStyle(
                                  fontSize: AppConstants.fontSizeMedium,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: AppConstants.fontSizeXXLarge,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.textPrimaryColor,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.paddingSmall,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppConstants.successColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  userRole,
                                  style: const TextStyle(
                                    fontSize: AppConstants.fontSizeSmall,
                                    fontWeight: FontWeight.w600,
                                    color: AppConstants.successColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(AppConstants.paddingSmall),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.today,
                                color: AppConstants.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateTime.now().day.toString().padLeft(2, '0'),
                                style: const TextStyle(
                                  fontSize: AppConstants.fontSizeSmall,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.primaryColor,
                                ),
                              ),
                              Text(
                                _getMonthName(DateTime.now().month),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingLarge),

              // Stats Cards Row
              Row(
                children: [
                  Expanded(
                    child: StatsCardWidget(
                      title: 'CLB đang quản lý',
                      value: 'CLB Tin học',
                      icon: Icons.business,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: StatsCardWidget(
                      title: 'Tổng Thành Viên',
                      value: '42',
                      icon: Icons.people,
                      color: AppConstants.successColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              
              Row(
                children: [
                  Expanded(
                    child: StatsCardWidget(
                      title: 'Ngân Sách Hiện Tại',
                      value: '5tr',
                      icon: Icons.monetization_on,
                      color: AppConstants.warningColor,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: StatsCardWidget(
                      title: 'Tổng giải thưởng',
                      value: '3',
                      icon: Icons.emoji_events,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingLarge),

              // Charts Section
              const Text(
                'Thống Kê Hoạt Động',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimaryColor,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),

              // Events Chart
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const DashboardChartWidget(
                  title: 'Hoạt động/Sự kiện',
                  chartType: ChartType.events,
                  color: AppConstants.primaryColor,
                ),
              ),
              const SizedBox(height: AppConstants.paddingLarge),

              // Awards Chart
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const DashboardChartWidget(
                  title: 'Giải thưởng',
                  chartType: ChartType.awards,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: AppConstants.paddingLarge),

              // New Members Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingLarge),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppConstants.borderRadiusLarge),
                          topRight: Radius.circular(AppConstants.borderRadiusLarge),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.people_alt,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: AppConstants.paddingSmall),
                          Text(
                            'Thành Viên Mới',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppConstants.fontSizeXLarge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      child: Column(
                        children: [
                          // Table Header
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Họ tên',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppConstants.fontSizeMedium,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'MSHS',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppConstants.fontSizeMedium,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Lớp',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppConstants.fontSizeMedium,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Ngày tham gia',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppConstants.fontSizeMedium,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Table Data
                          _buildMemberRow(
                            'Nguyễn Văn An',
                            'HS001',
                            '10A1',
                            '12/05/2025',
                          ),
                          _buildMemberRow(
                            'Trần Thị Bình',
                            'HS002',
                            '11A3',
                            '14/05/2025',
                          ),
                          _buildMemberRow(
                            'Lê Hoàng Cường',
                            'HS003',
                            '12A2',
                            '18/05/2025',
                          ),
                          _buildMemberRow(
                            'Phạm Thị Dung',
                            'HS004',
                            '10B1',
                            '20/05/2025',
                          ),
                          _buildMemberRow(
                            'Hoàng Văn Em',
                            'HS005',
                            '11A1',
                            '22/05/2025',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      '', 'T1', 'T2', 'T3', 'T4', 'T5', 'T6',
      'T7', 'T8', 'T9', 'T10', 'T11', 'T12'
    ];
    return months[month];
  }

  Widget _buildMemberRow(
    String name,
    String studentId,
    String className,
    String joinDate,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeMedium,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              studentId,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeMedium,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              className,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeMedium,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              joinDate,
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout,
                color: AppConstants.warningColor,
                size: 28,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              const Text(
                'Đăng xuất',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng?',
            style: TextStyle(fontSize: AppConstants.fontSizeMedium),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Hủy',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                AuthService().logout();
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.warningColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
              ),
              child: const Text(
                'Đăng xuất',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
