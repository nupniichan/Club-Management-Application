import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class ManagerSettingsScreen extends StatelessWidget {
  const ManagerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: const Center(
        child: Text(
          'Cài đặt\n(Đang phát triển)',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppConstants.fontSizeXLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
} 