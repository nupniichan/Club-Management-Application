// Full class with mobile/web layout and full detailed report view
import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/auth_service.dart';
import '../login_screen.dart';
import '../../widgets/manager/manager_drawer_widget.dart';

class ManagerReportsScreen extends StatefulWidget {
  const ManagerReportsScreen({super.key});

  @override
  State<ManagerReportsScreen> createState() => _ManagerReportsScreenState();
}

class _ManagerReportsScreenState extends State<ManagerReportsScreen> {
  final List<Map<String, dynamic>> _reports = List.generate(
    5,
    (index) => {
      'title': 'Báo cáo ngày 21',
      'date': '11/22/2024',
      'manager': 'Nguyễn Văn A',
      'club': 'Tin học',
    },
  );

  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo cáo câu lạc bộ'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Thông báo',
            onPressed: () => _showNotifications(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      drawer: const ManagerDrawerWidget(
        currentPage: 'reports',
        userName: 'Nguyễn Phi Quốc Bảo',
        userRole: 'Quản lý',
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isMobile(context)
                ? Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 32,
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Tìm kiếm theo tên báo cáo',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          // handle search logic
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 32,
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        value: 'Tất cả CLB',
                        items: const [
                          DropdownMenuItem(
                            value: 'Tất cả CLB',
                            child: Text('Tất cả CLB'),
                          ),
                          DropdownMenuItem(
                            value: 'Tin học',
                            child: Text('Tin học'),
                          ),
                          DropdownMenuItem(
                            value: 'Toán học',
                            child: Text('Toán học'),
                          ),
                        ],
                        onChanged: (value) {
                          // handle club filter logic
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 32,
                      child: TextField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: 'mm/dd/yyyy',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          // handle start date picker
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 32,
                      child: TextField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: 'mm/dd/yyyy',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          // handle end date picker
                        },
                      ),
                    ),
                  ],
                )
                : Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Tìm kiếm theo tên báo cáo',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          // handle search logic
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        value: 'Tất cả CLB',
                        items: const [
                          DropdownMenuItem(
                            value: 'Tất cả CLB',
                            child: Text('Tất cả CLB'),
                          ),
                          DropdownMenuItem(
                            value: 'Tin học',
                            child: Text('Tin học'),
                          ),
                          DropdownMenuItem(
                            value: 'Toán học',
                            child: Text('Toán học'),
                          ),
                        ],
                        onChanged: (value) {
                          // handle club filter logic
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: 'mm/dd/yyyy',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          // handle start date picker
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: 'mm/dd/yyyy',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          // handle end date picker
                        },
                      ),
                    ),
                  ],
                ),
            const SizedBox(height: AppConstants.paddingMedium),
            const Text('Danh sách báo cáo'),
            const SizedBox(height: AppConstants.paddingMedium),
            Expanded(
              child:
                  isMobile(context)
                      ? ListView.separated(
                        itemCount: _reports.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final report = _reports[index];
                          return ListTile(
                            title: Text(
                              report['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Ngày: ${report['date']}'),
                                Text('Quản lý: ${report['manager']}'),
                                Text('CLB: ${report['club']}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.remove_red_eye,
                                color: Colors.blue,
                              ),
                              onPressed: () => _viewReport(report),
                            ),
                          );
                        },
                      )
                      : ListView(
                        children: [
                          Table(
                            columnWidths: const {
                              0: FlexColumnWidth(3),
                              1: FlexColumnWidth(2),
                              2: FlexColumnWidth(3),
                              3: FlexColumnWidth(2),
                              4: IntrinsicColumnWidth(),
                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: AppConstants.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                ),
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      'TÊN BÁO CÁO',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      'NGÀY BÁO CÁO',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      'NHÂN SỰ PHỤ TRÁCH',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      'CLB',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      'HÀNH ĐỘNG',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ..._reports.map(
                                (report) => TableRow(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.black12),
                                    ),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        report['title'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(report['date']),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(report['manager']),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(report['club']),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () => _viewReport(report),
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
          ],
        ),
      ),
    );
  }

  void _viewReport(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.description, color: AppConstants.primaryColor),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(report['title']),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Thông tin cơ bản', Colors.lightBlue.shade100),
                  _infoRow('Tên báo cáo', report['title']),
                  _infoRow('Ngày báo cáo', report['date']),
                  _infoRow('Nhân sự phụ trách', 'Bảo'),
                  _infoRow('Câu lạc bộ', report['club']),
                  const SizedBox(height: 16),
                  _sectionTitle('Danh sách sự kiện', Colors.lightBlue.shade100),
                  _tableRow([
                    'Tên sự kiện',
                    'Người phụ trách',
                    'Ngày tổ chức',
                    'Địa điểm',
                  ], isHeader: true),
                  _tableRow([
                    'Lễ khánh thành',
                    'Nguyễn Văn A',
                    '8/2/2025',
                    'TP.HCM',
                  ]),
                  const SizedBox(height: 16),
                  _sectionTitle(
                    'Danh sách giải thưởng',
                    Colors.lightBlue.shade100,
                  ),
                  _tableRow([
                    'Tên giải thưởng',
                    'Loại giải',
                    'Ngày đạt giải',
                    'Thành viên đạt giải',
                  ], isHeader: true),
                  _tableRow(['VIP 100', 'VIP', '8/2/2025', 'Nguyễn Văn B']),
                  const SizedBox(height: 16),
                  _sectionTitle('Thông tin tài chính', Colors.green.shade100),
                  _infoRow('Tổng ngân sách chi tiêu', '100,000 VND'),
                  _infoRow('Tổng thu', '100,000 VND'),
                  const SizedBox(height: 16),
                  _sectionTitle('Kết quả đạt được', Colors.yellow.shade100),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Giải thưởng đã được trao'),
                  ),
                ],
              ),
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

  Widget _sectionTitle(String title, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      color: color,
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _infoRow(String label, String value) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _tableRow(List<String> cells, {bool isHeader = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
        color: isHeader ? Colors.grey.shade100 : null,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children:
            cells
                .map(
                  (cell) => Expanded(
                    child: Text(
                      cell,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight:
                            isHeader ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.notifications, color: AppConstants.primaryColor),
                const SizedBox(width: AppConstants.paddingSmall),
                const Text('Thông báo'),
              ],
            ),
            content: const Text('Chưa có thông báo mới.'),
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
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusMedium,
              ),
            ),
            title: Row(
              children: [
                Icon(Icons.logout, color: AppConstants.warningColor, size: 28),
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
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  AuthService().logout();
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.warningColor,
                ),
                child: const Text(
                  'Đăng xuất',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
