import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/auth_service.dart';
import '../../screens/login_screen.dart';

class ManagerAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;

  const ManagerAppBarWidget({
    super.key,
    required this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: AppConstants.fontSizeXLarge,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppConstants.primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      shadowColor: AppConstants.primaryColor.withOpacity(0.3),
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: automaticallyImplyLeading ? Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: 'Mở menu',
          );
        },
      ) : null,
      actions: actions ?? [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          tooltip: 'Thông báo',
          onPressed: () {
            _showNotifications(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Đăng xuất',
          onPressed: () {
            _showLogoutDialog(context);
          },
        ),
      ],
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thông báo'),
        content: const Text('Chưa có thông báo mới'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AuthService().logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 