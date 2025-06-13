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
      elevation: 16,
      child: Column(
        children: [
          _buildDrawerHeader(context),
          Expanded(
            child: _buildMenuItems(context),
          ),
          _buildDrawerFooter(),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.primaryColor,
            AppConstants.primaryColor.withOpacity(0.8),
            AppConstants.primaryColor.withOpacity(0.6),
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'student_avatar',
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.school_rounded,
                      size: 36,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                userName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Text(
                  userRole,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingSmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
      children: [
        _buildDrawerItem(
          context,
          icon: Icons.dashboard_rounded,
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
        ),
        const SizedBox(height: 4),
        _buildDrawerItem(
          context,
          icon: Icons.people_rounded,
          title: 'Quản lý thành viên',
          onTap: () => _navigateToScreen(
            context, 
            StudentMemberManagementScreen(
              userName: userName,
              userRole: userRole,
            )
          ),
          isSelected: currentPage == 'member_management',
        ),
        const SizedBox(height: 4),
        _buildDrawerItem(
          context,
          icon: Icons.event_rounded,
          title: 'Quản lý sự kiện & lịch trình',
          onTap: () => _navigateToScreen(
            context, 
            StudentEventManagementScreen(
              userName: userName,
              userRole: userRole,
            )
          ),
          isSelected: currentPage == 'event_management',
        ),
        const SizedBox(height: 4),
        _buildDrawerItem(
          context,
          icon: Icons.account_balance_wallet_rounded,
          title: 'Quản lý ngân sách',
          onTap: () => _navigateToScreen(
            context, 
            StudentBudgetManagementScreen(
              userName: userName,
              userRole: userRole,
            )
          ),
          isSelected: currentPage == 'budget_management',
        ),
        const SizedBox(height: 4),
        _buildDrawerItem(
          context,
          icon: Icons.emoji_events_rounded,
          title: 'Quản lý giải thưởng',
          onTap: () => _navigateToScreen(
            context, 
            StudentAwardManagementScreen(
              userName: userName,
              userRole: userRole,
            )
          ),
          isSelected: currentPage == 'award_management',
        ),
        const SizedBox(height: 4),
        _buildDrawerItem(
          context,
          icon: Icons.assessment_rounded,
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
        const SizedBox(height: AppConstants.paddingMedium),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingLarge),
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.grey.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        _buildDrawerItem(
          context,
          icon: Icons.help_outline_rounded,
          title: 'Trợ giúp',
          onTap: () => _showHelp(context),
          isSecondary: true,
        ),
        const SizedBox(height: 4),
        _buildDrawerItem(
          context,
          icon: Icons.info_outline_rounded,
          title: 'Về ứng dụng',
          onTap: () => _showAbout(context),
          isSecondary: true,
        ),
      ],
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
    bool isSecondary = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pop(context);
            onTap();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppConstants.primaryColor.withOpacity(0.1) : null,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(
                      color: AppConstants.primaryColor.withOpacity(0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppConstants.primaryColor
                        : isSecondary
                            ? Colors.grey.withOpacity(0.1)
                            : AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isSelected
                        ? Colors.white
                        : isSecondary
                            ? Colors.grey[600]
                            : AppConstants.primaryColor,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? AppConstants.primaryColor
                          : isSecondary
                              ? Colors.grey[600]
                              : Colors.black87,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.grey.withOpacity(0.05),
          ],
        ),
      ),
      child: Text(
        'Phiên bản ${AppConstants.appVersion}',
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.3,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.help_rounded,
                color: AppConstants.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            const Text(
              'Trợ giúp',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: const Text(
          'Để được hỗ trợ, vui lòng liên hệ:\n'
          'Email: support@club.com\n'
          'Hotline: 1900-xxxx',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.info_rounded,
                color: AppConstants.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            const Text(
              'Về ứng dụng',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Text(
          '${AppConstants.appName}\n'
          'Phiên bản: ${AppConstants.appVersion}\n\n'
          'Ứng dụng quản lý câu lạc bộ dành cho các trường học và tổ chức.',
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}