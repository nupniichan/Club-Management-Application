import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/auth_service.dart';
import '../login_screen.dart';
import '../../widgets/manager/manager_drawer_widget.dart';

class ManagerAccountManagementScreen extends StatefulWidget {
  const ManagerAccountManagementScreen({super.key});

  @override
  State<ManagerAccountManagementScreen> createState() =>
      _ManagerAccountManagementScreenState();
}

class _ManagerAccountManagementScreenState
    extends State<ManagerAccountManagementScreen> {
  int _selectedIndex = 0;
  String _currentTitle = 'Danh sách tài khoản';

  final List<String> _titles = [
    'Danh sách tài khoản',
    'Thêm tài khoản',
    'Tìm kiếm & Lọc',
  ];

  final List<Map<String, dynamic>> _accounts = [
    {
      'id': 1,
      'name': 'Nguyễn Văn A',
      'role': 'Sinh viên',
      'status': 'Hoạt động',
      'createdDate': '15/01/2024',
    },
    {
      'id': 2,
      'name': 'Trần Thị B',
      'role': 'Quản lý',
      'status': 'Tạm khóa',
      'createdDate': '20/01/2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTitle),
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
        currentPage: 'account_management',
        userName: 'Nguyễn Phi Quốc Bảo',
        userRole: 'Quản lý',
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _currentTitle = _titles[index];
          });
        },
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Danh sách'),
          BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Thêm'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildAccountList();
      case 1:
        return _buildAddAccount();
      case 2:
        return _buildSearchAndFilter();
      default:
        return _buildAccountList();
    }
  }

  Widget _buildAccountList() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStatsCard(
                'Tổng TK',
                _accounts.length.toString(),
                Icons.people,
                AppConstants.primaryColor,
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              _buildStatsCard(
                'Hoạt động',
                _accounts
                    .where((a) => a['status'] == 'Hoạt động')
                    .length
                    .toString(),
                Icons.check_circle,
                Colors.green,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          const Text(
            'Danh sách tài khoản',
            style: TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Expanded(
            child: ListView.builder(
              itemCount: _accounts.length,
              itemBuilder:
                  (context, index) => _buildAccountCard(_accounts[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              value,
              style: TextStyle(
                fontSize: AppConstants.fontSizeXLarge,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(Map<String, dynamic> account) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppConstants.primaryColor,
          child: Text(
            account['name'][0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          account['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${account['role']} • ${account['status']}'),
        trailing: PopupMenuButton(
          onSelected:
              (value) => _handleAccountAction(value.toString(), account),
          itemBuilder:
              (context) => [
                const PopupMenuItem(value: 'view', child: Text('Xem chi tiết')),
                const PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa')),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Xóa', style: TextStyle(color: Colors.red)),
                ),
              ],
        ),
      ),
    );
  }

  Widget _buildAddAccount() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thêm tài khoản mới',
            style: TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTextField('Họ tên', Icons.person),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildTextField('Email', Icons.email),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildDropdownField('Vai trò', [
                    'Sinh viên',
                    'Quản lý',
                    'Giảng viên',
                  ]),
                  const SizedBox(height: AppConstants.paddingLarge),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          () => _showSuccessDialog('Tạo tài khoản thành công!'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.paddingMedium,
                        ),
                      ),
                      child: const Text(
                        'Tạo tài khoản',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tìm kiếm & Lọc',
            style: TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          _buildTextField('Tìm kiếm theo tên hoặc email', Icons.search),
          const SizedBox(height: AppConstants.paddingMedium),
          _buildDropdownField('Vai trò', [
            'Tất cả',
            'Sinh viên',
            'Quản lý',
            'Giảng viên',
          ]),
          _buildDropdownField('Trạng thái', [
            'Tất cả',
            'Hoạt động',
            'Tạm khóa',
          ]),
          const SizedBox(height: AppConstants.paddingLarge),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Xóa lọc'),
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                  ),
                  child: const Text('Áp dụng'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(top: AppConstants.paddingMedium),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.borderRadiusMedium,
            ),
          ),
        ),
        items:
            items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
        onChanged: (_) {},
      ),
    );
  }

  void _handleAccountAction(String action, Map<String, dynamic> account) {
    switch (action) {
      case 'view':
        _showSuccessDialog('Chi tiết tài khoản: ${account['name']}');
        break;
      case 'edit':
        _showSuccessDialog('Chỉnh sửa: ${account['name']}');
        break;
      case 'delete':
        _showSuccessDialog('Đã xóa tài khoản: ${account['name']}');
        break;
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Thành công'),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
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
