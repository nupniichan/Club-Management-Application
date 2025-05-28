import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/student/student_drawer_widget.dart';

class StudentBudgetManagementScreen extends StatelessWidget {
  final String? userName;
  final String? userRole;

  const StudentBudgetManagementScreen({
    super.key,
    this.userName = 'Sinh viên',
    this.userRole = 'Thành viên câu lạc bộ',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: const Text('Quản lý ngân sách'),
        backgroundColor: AppConstants.primaryColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'Mở menu',
            );
          },
        ),
      ),      drawer: StudentDrawerWidget(
        currentPage: 'budget_management',
        userName: userName!,
        userRole: userRole!,
      ),
      body: const Center(
        child: Text('Màn hình quản lý ngân sách (đang phát triển)'),
      ),
    );
  }
}
