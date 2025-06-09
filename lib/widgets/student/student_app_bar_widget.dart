import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class StudentAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;

  const StudentAppBarWidget({
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
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 