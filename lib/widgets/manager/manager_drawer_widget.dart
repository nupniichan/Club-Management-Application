import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/auth_service.dart';
import '../../screens/login_screen.dart';
import '../../screens/manager/manager_club_management_screen.dart';
import '../../screens/manager/manager_event_approval_screen.dart';
import '../../screens/manager/manager_account_management_screen.dart';
import '../../screens/manager/manager_reports_screen.dart';

class ManagerDrawerWidget extends StatelessWidget {
  final String currentPage;
  final String userName;
  final String userRole;

  const ManagerDrawerWidget({
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
                        Icons.admin_panel_settings,
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
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  onTap: () => Navigator.pop(context),
                  isSelected: currentPage == 'dashboard',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.business,
                  title: 'Quản lý câu lạc bộ',
                  onTap: () => _navigateToScreen(context, const ManagerClubManagementScreen()),
                  isSelected: currentPage == 'club_management',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.event_available,
                  title: 'Phê duyệt sự kiện',
                  onTap: () => _navigateToScreen(context, const ManagerEventApprovalScreen()),
                  isSelected: currentPage == 'event_approval',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.account_circle,
                  title: 'Quản lý tài khoản',
                  onTap: () => _navigateToScreen(context, const ManagerAccountManagementScreen()),
                  isSelected: currentPage == 'account_management',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.analytics,
                  title: 'Báo cáo câu lạc bộ',
                  onTap: () => _navigateToScreen(context, const ManagerReportsScreen()),
                  isSelected: currentPage == 'reports',
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