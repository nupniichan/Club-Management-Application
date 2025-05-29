import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../screens/student/student_member_management_screen.dart';
import '../../screens/student/student_dashboard_screen.dart';
import '../../screens/student/student_event_management_screen.dart';
import '../../screens/student/student_budget_management_screen.dart';
import '../../screens/student/student_award_management_screen.dart';
import '../../screens/student/student_activity_reports_screen.dart';

class StudentDrawerWidget extends StatelessWidget {
  final String currentPage;
  final String userName;
  final String userRole;

  const StudentDrawerWidget({
    super.key,
    required this.currentPage,
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppConstants.primaryColor,
                  AppConstants.primaryColor.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: SafeArea(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.school, // Changed icon to be more student-appropriate
                        size: 40,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      userName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingSmall,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        userRole,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppConstants.fontSizeSmall,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Menu Items - Scrollable
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  onTap: () {
                    if (currentPage != 'dashboard') {
                      _navigateToScreen(
                        context, 
                        DashboardScreen(
                          userName: userName,
                          userRole: userRole,
                        ),
                      );
                    }
                  },
                  isSelected: currentPage == 'dashboard',
                ),                _buildDrawerItem(
                  context,
                  icon: Icons.people,
                  title: 'Quản lý thành viên',
                  onTap: () => _navigateToScreen(
                    context, 
                    StudentMemberManagementScreen(
                      userName: userName,
                      userRole: userRole,
                    )
                  ),
                  isSelected: currentPage == 'member_management',
                ),                _buildDrawerItem(
                  context,
                  icon: Icons.event,
                  title: 'Quản lý sự kiện & lịch trình',
                  onTap: () => _navigateToScreen(
                    context, 
                    StudentEventManagementScreen(
                      userName: userName,
                      userRole: userRole,
                    )
                  ),
                  isSelected: currentPage == 'event_management',
                ),                _buildDrawerItem(
                  context,
                  icon: Icons.account_balance_wallet,
                  title: 'Quản lý ngân sách',
                  onTap: () => _navigateToScreen(
                    context, 
                    StudentBudgetManagementScreen(
                      userName: userName,
                      userRole: userRole,
                    )
                  ),
                  isSelected: currentPage == 'budget_management',
                ),                _buildDrawerItem(
                  context,
                  icon: Icons.emoji_events,
                  title: 'Quản lý giải thưởng',
                  onTap: () => _navigateToScreen(
                    context, 
                    StudentAwardManagementScreen(
                      userName: userName,
                      userRole: userRole,
                    )
                  ),
                  isSelected: currentPage == 'award_management',
                ),                _buildDrawerItem(
                  context,
                  icon: Icons.assessment,
                  title: 'Báo cáo hoạt động',
                  onTap: () => _navigateToScreen(
                    context, 
                    StudentActivityReportsScreen(
                      userName: userName,
                      userRole: userRole,
                    )
                  ),
                  isSelected: currentPage == 'activity_reports',
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'Trợ giúp',
                  onTap: () => _showHelp(context),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'Về ứng dụng',
                  onTap: () => _showAbout(context),
                ),
                const SizedBox(height: AppConstants.paddingMedium),
              ],
            ),
          ),

          // Footer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.paddingSmall),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            child: Text(
              'Phiên bản ${AppConstants.appVersion}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: AppConstants.fontSizeSmall,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.white : AppConstants.primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : Colors.black87,
        ),
      ),
      tileColor: isSelected ? AppConstants.primaryColor : null,
      onTap: () {
        Navigator.pop(context); // Close drawer
        onTap();
      },
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingLarge,
        vertical: AppConstants.paddingSmall,
      ),
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help, color: AppConstants.primaryColor),
            const SizedBox(width: AppConstants.paddingSmall),
            const Text('Trợ giúp'),
          ],
        ),
        content: const Text(
          'Để được hỗ trợ, vui lòng liên hệ:\n'
          'Email: support@club.com\n'
          'Hotline: 1900-xxxx',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info, color: AppConstants.primaryColor),
            const SizedBox(width: AppConstants.paddingSmall),
            const Text('Về ứng dụng'),
          ],
        ),
        content: Text(
          '${AppConstants.appName}\n'
          'Phiên bản: ${AppConstants.appVersion}\n\n'
          'Ứng dụng quản lý câu lạc bộ dành cho các trường học và tổ chức.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}