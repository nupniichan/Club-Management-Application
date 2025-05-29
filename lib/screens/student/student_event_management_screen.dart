import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/student/student_drawer_widget.dart';

class StudentEventManagementScreen extends StatelessWidget {
  final String? userName;
  final String? userRole;

  const StudentEventManagementScreen({
    super.key,
    this.userName = 'Sinh viên',
    this.userRole = 'Thành viên câu lạc bộ',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: const Text('Quản lý sự kiện & lịch trình'),
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
        currentPage: 'event_management',
        userName: userName!,
        userRole: userRole!,
      ),
      body: const Center(
        child: Text('Màn hình quản lý sự kiện & lịch trình (đang phát triển)'),
      ),
    );
  }
}
