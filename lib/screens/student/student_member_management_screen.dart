import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/student/student_drawer_widget.dart';
import 'student_add_member_screen.dart';
import 'student_edit_member_screen.dart';

class StudentMemberManagementScreen extends StatefulWidget {
  final String? userName;
  final String? userRole;

  const StudentMemberManagementScreen({
    super.key,
    this.userName = 'Sinh viên',
    this.userRole = 'Thành viên câu lạc bộ',
  });

  @override
  State<StudentMemberManagementScreen> createState() => _StudentMemberManagementScreenState();
}

class _StudentMemberManagementScreenState extends State<StudentMemberManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Mock data cho thành viên
  final List<Map<String, dynamic>> _members = [
    {
      'id': 'HS24123456',
      'name': 'Nguyễn Văn A',
      'gender': 'Nam',
      'class': '12A16',
      'role': 'THÀNH VIÊN',
    },
    {
      'id': 'HS24123457',
      'name': 'Nguyễn Văn B',
      'gender': 'Nam',
      'class': '10A11',
      'role': 'THÀNH VIÊN',
    },
    {
      'id': 'HS24123458',
      'name': 'Nguyễn Văn C',
      'gender': 'Nam',
      'class': '10A1',
      'role': 'THÀNH VIÊN',
    },
    {
      'id': 'HS24123459',
      'name': 'Nguyễn Thị D',
      'gender': 'Nữ',
      'class': '10A9',
      'role': 'THÀNH VIÊN',
    },
    {
      'id': 'HS24123460',
      'name': 'Nguyễn Văn H',
      'gender': 'Nam',
      'class': '11B10',
      'role': 'THÀNH VIÊN',
    },
    {
      'id': 'HS24123461',
      'name': 'Nguyễn Văn T',
      'gender': 'Nam',
      'class': '11B6',
      'role': 'THÀNH VIÊN',
    },
    {
      'id': 'HS24123462',
      'name': 'Lê Thị T',
      'gender': 'Nữ',
      'class': '11B9',
      'role': 'THÀNH VIÊN',
    },
    {
      'id': 'HS24123463',
      'name': 'Trần Văn T',
      'gender': 'Nam',
      'class': '12A3',
      'role': 'THÀNH VIÊN',
    },
    {
      'id': 'HS24123464',
      'name': 'Trần Văn B',
      'gender': 'Nam',
      'class': '12A6',
      'role': 'THÀNH VIÊN',
    },
    {
      'id': 'HS24123465',
      'name': 'Trần Văn C',
      'gender': 'Nam',
      'class': '12A7',
      'role': 'PHÓ CÂU LẠC BỘ',
    },
  ];

  List<Map<String, dynamic>> get _filteredMembers {
    if (_searchQuery.isEmpty) {
      return _members;
    }
    return _members.where((member) {
      return member['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
        member['id'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
        member['class'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý thành viên'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
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
      ),
      drawer: StudentDrawerWidget(
        currentPage: 'member_management',
        userName: widget.userName!,
        userRole: widget.userRole!,
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm theo tên, mã số, lớp...',
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: AppConstants.paddingSmall,
                        ),
                        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),                SizedBox(
                  height: 40,
                  child: FloatingActionButton(
                    onPressed: () => _navigateToAddMember(context),
                    backgroundColor: AppConstants.primaryColor,
                    mini: true,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
            // Thanh thống kê
          Container(
            color: AppConstants.primaryColor.withAlpha(40),
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
            child: Row(
              children: [
                const Icon(Icons.people, size: 16, color: Colors.grey),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  'Tổng số: ${_filteredMembers.length} thành viên',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
            // Danh sách thành viên
          Expanded(
            child: _filteredMembers.isEmpty
                ? const Center(
                    child: Text(
                      'Không tìm thấy thành viên',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredMembers.length,
                    itemBuilder: (context, index) {
                      final member = _filteredMembers[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingMedium,
                          vertical: AppConstants.paddingSmall / 2,
                        ),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(AppConstants.paddingMedium),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header với họ tên và nút thao tác
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Avatar và họ tên
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(                                            color: member['gender'] == 'Nam' ? 
                                              Colors.blue.withAlpha(51) : 
                                              Colors.pink.withAlpha(51),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              _getInitials(member['name']),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: member['gender'] == 'Nam' ? 
                                                  Colors.blue : Colors.pink,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: AppConstants.paddingSmall),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                member['name'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                member['id'],
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
                                  // Nút thao tác
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.visibility, color: Colors.blue),
                                        onPressed: () => _showMemberDetails(context, member),
                                        tooltip: 'Xem chi tiết',
                                        iconSize: 22,
                                      ),                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.green),
                                        onPressed: () => _navigateToEditMember(context, member),
                                        tooltip: 'Chỉnh sửa',
                                        iconSize: 22,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _showDeleteConfirmation(context, member),
                                        tooltip: 'Xóa',
                                        iconSize: 22,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppConstants.paddingMedium),
                              
                              // Thông tin chi tiết
                              Row(
                                children: [
                                  _buildInfoChip(Icons.class_, 'Lớp: ${member['class']}'),
                                  const SizedBox(width: AppConstants.paddingSmall),
                                  _buildInfoChip(Icons.wc, member['gender']),
                                ],
                              ),
                              const SizedBox(height: AppConstants.paddingSmall),
                              
                              // Chức vụ
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.paddingSmall,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: member['role'] == 'PHÓ CÂU LẠC BỘ' ? 
                                    Colors.green.withAlpha(51) : 
                                    (member['role'] == 'CHỦ NHIỆM' ? 
                                      Colors.orange.withAlpha(51) : 
                                      Colors.blue.withAlpha(51)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  member['role'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: member['role'] == 'PHÓ CÂU LẠC BỘ' ? 
                                      Colors.green : 
                                      (member['role'] == 'CHỦ NHIỆM' ? 
                                        Colors.orange : 
                                        Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  void _showMemberDetails(BuildContext context, Map<String, dynamic> member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.person, color: AppConstants.primaryColor),
              const SizedBox(width: AppConstants.paddingSmall),
              const Text('Thông tin thành viên'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Mã số', member['id']),
                _buildDetailRow('Họ tên', member['name']),
                _buildDetailRow('Giới tính', member['gender']),
                _buildDetailRow('Lớp', member['class']),
                _buildDetailRow('Chức vụ', member['role']),
                // Có thể thêm các thông tin khác ở đây
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
    // Phương thức thêm thành viên đã được chuyển sang trang riêng
  // Phương thức chỉnh sửa thành viên đã được chuyển sang trang riêng
  void _showDeleteConfirmation(BuildContext context, Map<String, dynamic> member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc chắn muốn xóa thành viên "${member['name']}" không?'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  _members.removeWhere((m) => m['id'] == member['id']);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa thành viên'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
  
  // Lấy chữ cái đầu của họ tên
  String _getInitials(String name) {
    if (name.isEmpty) return '';
    
    List<String> nameParts = name.split(' ');
    if (nameParts.isEmpty) return '';
    
    // Lấy ký tự đầu tiên của phần cuối cùng (tên)
    String initial = nameParts.last.isNotEmpty ? nameParts.last[0] : '';
    
    return initial.toUpperCase();
  }
  
  // Tạo chip hiển thị thông tin nhỏ
  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.grey.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  // Phương thức chuyển hướng đến trang thêm thành viên
  void _navigateToAddMember(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StudentAddMemberScreen(
          onMemberAdded: (newMember) {
            // Thêm thành viên mới vào danh sách
            setState(() {
              _members.add(newMember);
            });
            
            // Hiển thị thông báo thành công
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã thêm thành viên mới'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }
  
  // Phương thức chuyển hướng đến trang chỉnh sửa thành viên
  void _navigateToEditMember(BuildContext context, Map<String, dynamic> member) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StudentEditMemberScreen(
          member: member,
          onMemberUpdated: (updatedMember) {
            // Cập nhật thông tin thành viên trong danh sách
            setState(() {
              final index = _members.indexWhere((m) => m['id'] == updatedMember['id']);
              if (index != -1) {
                _members[index] = updatedMember;
              }
            });
            
            // Hiển thị thông báo thành công
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã cập nhật thông tin thành viên'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }
}