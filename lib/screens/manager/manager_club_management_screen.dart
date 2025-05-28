import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/auth_service.dart';
import '../login_screen.dart';
import '../../widgets/manager/manager_drawer_widget.dart';

class ManagerClubManagementScreen extends StatefulWidget {
  const ManagerClubManagementScreen({super.key});

  @override
  State<ManagerClubManagementScreen> createState() => _ManagerClubManagementScreenState();
}

class _ManagerClubManagementScreenState extends State<ManagerClubManagementScreen> {
  int _selectedIndex = 0;
  String _currentTitle = 'Danh sách câu lạc bộ';

  final List<String> _titles = [
    'Danh sách câu lạc bộ',
    'Thêm câu lạc bộ',
    'Tìm kiếm & Lọc',
  ];

  // Sample club data
  final List<Map<String, dynamic>> _clubs = [
    {
      'id': 1,
      'name': 'Câu lạc bộ Bóng đá',
      'description': 'CLB thể thao bóng đá của trường',
      'members': 25,
      'status': 'Hoạt động',
      'createdDate': '15/01/2024',
      'category': 'Thể thao',
    },
    {
      'id': 2,
      'name': 'Câu lạc bộ Âm nhạc',
      'description': 'CLB âm nhạc và biểu diễn',
      'members': 18,
      'status': 'Hoạt động',
      'createdDate': '20/01/2024',
      'category': 'Nghệ thuật',
    },
    {
      'id': 3,
      'name': 'Câu lạc bộ Tin học',
      'description': 'CLB lập trình và công nghệ',
      'members': 32,
      'status': 'Tạm dừng',
      'createdDate': '10/01/2024',
      'category': 'Công nghệ',
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
      ),
      drawer: const ManagerDrawerWidget(
        currentPage: 'club_management',
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
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Danh sách',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Thêm CLB',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Tìm kiếm',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildClubList();
      case 1:
        return _buildAddClub();
      case 2:
        return _buildSearchAndFilter();
      default:
        return _buildClubList();
    }
  }

  Widget _buildClubList() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatsCard(
                  'Tổng CLB',
                  '${_clubs.length}',
                  Icons.business,
                  AppConstants.primaryColor,
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: _buildStatsCard(
                  'Hoạt động',
                  '${_clubs.where((c) => c['status'] == 'Hoạt động').length}',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          
          // Club List
          const Text(
            'Danh sách câu lạc bộ',
            style: TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          
          Expanded(
            child: ListView.builder(
              itemCount: _clubs.length,
              itemBuilder: (context, index) {
                final club = _clubs[index];
                return _buildClubCard(club);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
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
    );
  }

  Widget _buildClubCard(Map<String, dynamic> club) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppConstants.primaryColor,
          child: Text(
            club['name'][0],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          club['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppConstants.fontSizeMedium,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(club['description']),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${club['members']} thành viên'),
                const SizedBox(width: AppConstants.paddingMedium),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: club['status'] == 'Hoạt động' ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    club['status'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 8),
                  Text('Xem chi tiết'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Chỉnh sửa'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Xóa', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            _handleClubAction(value.toString(), club);
          },
        ),
        onTap: () => _showClubDetails(club),
      ),
    );
  }

  Widget _buildAddClub() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thêm câu lạc bộ mới',
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
                  _buildTextField('Tên câu lạc bộ', Icons.business),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildTextField('Mô tả', Icons.description, maxLines: 3),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildDropdownField('Danh mục', ['Thể thao', 'Nghệ thuật', 'Công nghệ', 'Học thuật']),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildTextField('Số lượng thành viên tối đa', Icons.people, keyboardType: TextInputType.number),
                  const SizedBox(height: AppConstants.paddingLarge),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showSuccessDialog('Thêm câu lạc bộ thành công!');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        ),
                      ),
                      child: const Text(
                        'Tạo câu lạc bộ',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          fontWeight: FontWeight.bold,
                        ),
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
    return Container(
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
          
          // Search bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Tìm kiếm câu lạc bộ...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          
          // Filters
          const Text(
            'Bộ lọc',
            style: TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          
          _buildDropdownField('Danh mục', ['Tất cả', 'Thể thao', 'Nghệ thuật', 'Công nghệ', 'Học thuật']),
          const SizedBox(height: AppConstants.paddingMedium),
          _buildDropdownField('Trạng thái', ['Tất cả', 'Hoạt động', 'Tạm dừng']),
          const SizedBox(height: AppConstants.paddingLarge),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Xóa bộ lọc'),
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
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

  Widget _buildTextField(String label, IconData icon, {int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      maxLines: maxLines,
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
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
      items: items.map((item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      )).toList(),
      onChanged: (value) {},
    );
  }

  void _handleClubAction(String action, Map<String, dynamic> club) {
    switch (action) {
      case 'view':
        _showClubDetails(club);
        break;
      case 'edit':
        _showSuccessDialog('Chỉnh sửa ${club['name']}');
        break;
      case 'delete':
        _showDeleteConfirmation(club);
        break;
    }
  }

  void _showClubDetails(Map<String, dynamic> club) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(club['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mô tả: ${club['description']}'),
            const SizedBox(height: 8),
            Text('Danh mục: ${club['category']}'),
            const SizedBox(height: 8),
            Text('Số thành viên: ${club['members']}'),
            const SizedBox(height: 8),
            Text('Trạng thái: ${club['status']}'),
            const SizedBox(height: 8),
            Text('Ngày tạo: ${club['createdDate']}'),
          ],
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

  void _showDeleteConfirmation(Map<String, dynamic> club) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa câu lạc bộ "${club['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessDialog('Đã xóa câu lạc bộ "${club['name']}"');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
      builder: (context) => AlertDialog(
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
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        title: Row(
          children: [
            Icon(
              Icons.logout,
              color: AppConstants.warningColor,
              size: 28,
            ),
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Hủy',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              AuthService().logout();
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.warningColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
            ),
            child: const Text(
              'Đăng xuất',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
} 