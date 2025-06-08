import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/manager/manager_drawer_widget.dart';
import '../../widgets/manager/manager_app_bar_widget.dart';

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

  // Updated club data based on MongoDB structure  
  final List<Map<String, dynamic>> _clubs = [
    {
      '_id': '67160c5ad55fc5f816de7644',
      'ten': 'Câu lạc bộ tin học',
      'logo': '/uploads/d034915e14df6c0d63b832c64483d6f6',
      'linhVucHoatDong': 'Công Nghệ',
      'thanhVien': ['HS123456', 'HS123457', 'HS123458', 'HS123459', 'HS123460', 'HS123461'],
      'ngayThanhLap': '2024-10-21T00:00:00.000Z',
      'giaoVienPhuTrach': 'Thầy Nguyễn Văn A',
      'mieuTa': 'Câu lạc bộ tin học là nơi dành cho các bạn đam mê công nghệ và lập trình...',
      'quyDinh': 'Phải có mặt vào cuối tuần',
      'clubId': 20,
      'budget': 2000000,
      'tinhTrang': 'Còn hoạt động',
      'truongBanCLB': 'HS123456',
    },
    {
      '_id': '67160c5ad55fc5f816de7645',
      'ten': 'Câu lạc bộ Âm nhạc',
      'logo': '/uploads/music_club.jpg',
      'linhVucHoatDong': 'Nghệ thuật',
      'thanhVien': ['HS123470', 'HS123471', 'HS123472', 'HS123473'],
      'ngayThanhLap': '2024-09-15T00:00:00.000Z',
      'giaoVienPhuTrach': 'Cô Trần Thị B',
      'mieuTa': 'CLB âm nhạc dành cho những bạn yêu thích nghệ thuật âm nhạc',
      'quyDinh': 'Tham gia đầy đủ các buổi tập',
      'clubId': 21,
      'budget': 1500000,
      'tinhTrang': 'Còn hoạt động',
      'truongBanCLB': 'HS123470',
    },
    {
      '_id': '67160c5ad55fc5f816de7646',
      'ten': 'Câu lạc bộ Thể thao',
      'logo': '/uploads/sport_club.jpg',
      'linhVucHoatDong': 'Thể thao',
      'thanhVien': ['HS123480', 'HS123481'],
      'ngayThanhLap': '2024-08-10T00:00:00.000Z',
      'giaoVienPhuTrach': 'Thầy Lê Văn C',
      'mieuTa': 'CLB thể thao tổ chức các hoạt động rèn luyện sức khỏe',
      'quyDinh': 'Tập luyện đều đặn',
      'clubId': 22,
      'budget': 3000000,
      'tinhTrang': 'Tạm dừng',
      'truongBanCLB': 'HS123480',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ManagerAppBarWidget(title: _currentTitle),
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
                  '${_clubs.where((c) => c['tinhTrang'] == 'Còn hoạt động').length}',
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

  String _formatDate(String isoDateString) {
    final date = DateTime.parse(isoDateString);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatCurrency(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M VNĐ';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K VNĐ';
    } else {
      return '${amount} VNĐ';
    }
  }

  Widget _buildClubCard(Map<String, dynamic> club) {
    final isActive = club['tinhTrang'] == 'Còn hoạt động';
    final statusColor = isActive ? Colors.green : Colors.orange;
    final categoryColors = {
      'Công Nghệ': Colors.blue,
      'Nghệ thuật': Colors.purple,
      'Thể thao': Colors.red,
    };
    final categoryColor = categoryColors[club['linhVucHoatDong']] ?? Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              categoryColor.withOpacity(0.03),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          categoryColor,
                          categoryColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: categoryColor.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        club['ten'][0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          club['ten'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8, 
                                vertical: 4
                              ),
                              decoration: BoxDecoration(
                                color: categoryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: categoryColor.withOpacity(0.3)
                                ),
                              ),
                              child: Text(
                                club['linhVucHoatDong'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: categoryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8, 
                                vertical: 4
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: statusColor.withOpacity(0.3)
                                ),
                              ),
                              child: Text(
                                isActive ? 'Hoạt động' : 'Tạm dừng',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.people,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Thành viên:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${club['thanhVien'].length} người',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey[300],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.attach_money,
                                    size: 16,
                                    color: Colors.green[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Ngân sách:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatCurrency(club['budget']),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.school,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'GV phụ trách: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            club['giaoVienPhuTrach'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _showClubDetails(club),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('Chi tiết'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16, 
                        vertical: 8
                      ),
                      side: const BorderSide(color: Colors.blue),
                      foregroundColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => _showChangeStatusDialog(club),
                    icon: const Icon(Icons.swap_horiz, size: 16),
                    label: const Text('Trạng thái'),
                    style: FilledButton.styleFrom(
                      backgroundColor: club['tinhTrang'] == 'Còn hoạt động' ? Colors.orange : Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16, 
                        vertical: 8
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstants.primaryColor,
                    AppConstants.primaryColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  club['ten'][0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    club['ten'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ID: ${club['clubId']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildClubDetailRow('Tên câu lạc bộ', club['ten'], Icons.business),
              _buildClubDetailRow('Lĩnh vực hoạt động', club['linhVucHoatDong'], Icons.category),
              _buildClubDetailRow('Mô tả', club['mieuTa'], Icons.description),
              _buildClubDetailRow('Quy định', club['quyDinh'], Icons.rule),
              _buildClubDetailRow('Giáo viên phụ trách', club['giaoVienPhuTrach'], Icons.school),
              _buildClubDetailRow('Trưởng ban CLB', club['truongBanCLB'], Icons.person),
              _buildClubDetailRow('Ngày thành lập', _formatDate(club['ngayThanhLap']), Icons.calendar_today),
              _buildClubDetailRow('Số thành viên', '${club['thanhVien'].length} người', Icons.people),
              _buildClubDetailRow('Ngân sách', _formatCurrency(club['budget']), Icons.attach_money, 
                colorValue: Colors.green[700]),
              _buildClubDetailRow('Tình trạng', club['tinhTrang'], Icons.info, 
                colorValue: club['tinhTrang'] == 'Còn hoạt động' ? Colors.green : Colors.orange),
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

  Widget _buildClubDetailRow(String label, String value, IconData icon, {Color? colorValue}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colorValue ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> club) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: Colors.orange,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text(
              'Xác nhận xóa',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bạn có chắc chắn muốn xóa câu lạc bộ sau?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 20,
                    child: Text(
                      club['ten'][0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          club['ten'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${club['thanhVien'].length} thành viên • ${_formatCurrency(club['budget'])}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Thao tác này không thể hoàn tác!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.red[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessDialog('Đã xóa câu lạc bộ "${club['ten']}" thành công!');
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _showChangeStatusDialog(Map<String, dynamic> club) {
    final currentStatus = club['tinhTrang'];
    final newStatus = currentStatus == 'Còn hoạt động' ? 'Tạm dừng' : 'Còn hoạt động';
    final statusColor = newStatus == 'Còn hoạt động' ? Colors.green : Colors.orange;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.swap_horiz, color: statusColor),
            const SizedBox(width: 8),
            const Text('Thay đổi trạng thái'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bạn có muốn thay đổi trạng thái của câu lạc bộ "${club['ten']}" không?'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trạng thái hiện tại: $currentStatus',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Trạng thái mới: $newStatus',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                club['tinhTrang'] = newStatus;
              });
              Navigator.pop(context);
              _showSuccessDialog('Đã thay đổi trạng thái câu lạc bộ "${club['ten']}" thành "$newStatus"');
            },
            style: ElevatedButton.styleFrom(backgroundColor: statusColor),
            child: const Text('Thay đổi', style: TextStyle(color: Colors.white)),
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


} 