import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/student/student_drawer_widget.dart';

class StudentMemberManagementScreen extends StatefulWidget {
  final String? userName;
  final String? userRole;

  const StudentMemberManagementScreen({
    super.key,
    this.userName = 'Sinh viên',
    this.userRole = 'Thành viên câu lạc bộ',
  });

  @override
  State<StudentMemberManagementScreen> createState() =>
      _StudentMemberManagementScreenState();
}

class _StudentMemberManagementScreenState
    extends State<StudentMemberManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedIndex = 0;
  String _currentTitle = 'Quản lý thành viên';

  // Form controllers và variables
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final classController = TextEditingController();
  String gender = 'Nam';
  String role = 'THÀNH VIÊN';

  // Biến để lưu trữ thành viên đang được chỉnh sửa
  Map<String, dynamic>? _editingMember;

  final List<String> _titles = [
    'Quản lý thành viên',
    'Thêm thành viên',
    'Tìm kiếm & Lọc',
    'Chỉnh sửa thành viên',
  ];

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
      return member['name'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          member['id'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          member['class'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    nameController.dispose();
    idController.dispose();
    classController.dispose();
    super.dispose();
  }

  // Reset form về trạng thái mặc định
  void _resetForm() {
    nameController.clear();
    idController.clear();
    classController.clear();
    setState(() {
      gender = 'Nam';
      role = 'THÀNH VIÊN';
    });
  }

  // Phương thức lưu thành viên mới
  void _saveMember() {
    if (_formKey.currentState!.validate()) {
      // Tạo đối tượng thành viên mới
      final newMember = {
        'id': idController.text,
        'name': nameController.text,
        'gender': gender,
        'class': classController.text,
        'role': role,
      };

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

      // Reset form và chuyển về tab danh sách
      _resetForm();
      setState(() {
        _selectedIndex = 0;
        _currentTitle = _titles[0];
      });
    }
  }

  // Phương thức lưu cập nhật thành viên
  void _updateMember() {
    if (_formKey.currentState!.validate() && _editingMember != null) {
      // Tạo đối tượng thành viên đã cập nhật
      final updatedMember = {
        'id': idController.text,
        'name': nameController.text,
        'gender': gender,
        'class': classController.text,
        'role': role,
      };

      // Cập nhật thành viên trong danh sách
      setState(() {
        final index = _members.indexWhere(
          (m) => m['id'] == _editingMember!['id'],
        );
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

      // Reset form và chuyển về tab danh sách
      _resetForm();
      setState(() {
        _editingMember = null;
        _selectedIndex = 0;
        _currentTitle = _titles[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTitle),
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
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            _selectedIndex > 2 ? 0 : _selectedIndex, // Ẩn tab chỉnh sửa
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
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Danh sách'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_outlined),
            label: 'Thêm thành viên',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
          // Tab chỉnh sửa sẽ không hiển thị trong bottom navigation
          // nhưng vẫn có thể được chọn thông qua code
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildMemberList();
      case 1:
        return _buildAddMember();
      case 2:
        return _buildSearchAndFilter();
      case 3:
        return _buildEditMember();
      default:
        return _buildMemberList();
    }
  }

  Widget _buildMemberList() {
    return Column(
      children: [
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
          child:
              _filteredMembers.isEmpty
                  ? const Center(
                    child: Text(
                      'Không tìm thấy thành viên',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
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
                          padding: const EdgeInsets.all(
                            AppConstants.paddingMedium,
                          ),
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
                                          decoration: BoxDecoration(
                                            color:
                                                member['gender'] == 'Nam'
                                                    ? Colors.blue.withAlpha(51)
                                                    : Colors.pink.withAlpha(51),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              _getInitials(member['name']),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    member['gender'] == 'Nam'
                                                        ? Colors.blue
                                                        : Colors.pink,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: AppConstants.paddingSmall,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                        icon: const Icon(
                                          Icons.visibility,
                                          color: Colors.blue,
                                        ),
                                        onPressed:
                                            () => _showMemberDetails(
                                              context,
                                              member,
                                            ),
                                        tooltip: 'Xem chi tiết',
                                        iconSize: 22,
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.green,
                                        ),
                                        onPressed:
                                            () => _navigateToEditMember(
                                              context,
                                              member,
                                            ),
                                        tooltip: 'Chỉnh sửa',
                                        iconSize: 22,
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed:
                                            () => _showDeleteConfirmation(
                                              context,
                                              member,
                                            ),
                                        tooltip: 'Xóa',
                                        iconSize: 22,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: AppConstants.paddingMedium,
                              ),

                              // Thông tin chi tiết
                              Row(
                                children: [
                                  _buildInfoChip(
                                    Icons.class_,
                                    'Lớp: ${member['class']}',
                                  ),
                                  const SizedBox(
                                    width: AppConstants.paddingSmall,
                                  ),
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
                                  color:
                                      member['role'] == 'PHÓ CÂU LẠC BỘ'
                                          ? Colors.green.withAlpha(51)
                                          : (member['role'] ==
                                                  'TRƯỞNG CÂU LẠC BỘ'
                                              ? Colors.orange.withAlpha(51)
                                              : Colors.blue.withAlpha(51)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  member['role'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        member['role'] == 'PHÓ CÂU LẠC BỘ'
                                            ? Colors.green
                                            : (member['role'] ==
                                                    'TRƯỞNG CÂU LẠC BỘ'
                                                ? Colors.orange
                                                : Colors.blue),
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
    );
  }

  void _showMemberDetails(BuildContext context, Map<String, dynamic> member) {
    final Color genderColor =
        member['gender'] == 'Nam' ? Colors.blue : Colors.pink;
    final Color roleColor =
        member['role'] == 'PHÓ CÂU LẠC BỘ'
            ? Colors.green
            : (member['role'] == 'TRƯỞNG CÂU LẠC BỘ'
                ? Colors.orange
                : Colors.blue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header với avatar và họ tên
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withAlpha(
                      (0.05 * 255).round(),
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppConstants.borderRadiusLarge),
                      topRight: Radius.circular(AppConstants.borderRadiusLarge),
                    ),
                  ),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'member-${member['id']}',
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                genderColor.withAlpha((0.7 * 255).round()),
                                genderColor,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: genderColor.withAlpha(
                                  (0.3 * 255).round(),
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _getInitials(member['name']),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
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
                              member['name'],
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeXLarge,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: roleColor.withAlpha((0.2 * 255).round()),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                member['role'],
                                style: TextStyle(
                                  color: roleColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: AppConstants.fontSizeSmall,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Thông tin chi tiết
                Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    children: [
                      _buildDetailItem(
                        Icons.badge_outlined,
                        'Mã số học sinh',
                        member['id'],
                      ),
                      const Divider(),
                      _buildDetailItem(
                        member['gender'] == 'Nam' ? Icons.male : Icons.female,
                        'Giới tính',
                        member['gender'],
                        iconColor: genderColor,
                      ),
                      const Divider(),
                      _buildDetailItem(
                        Icons.class_outlined,
                        'Lớp',
                        member['class'],
                      ),
                      const Divider(),
                      _buildDetailItem(
                        Icons.work_outline,
                        'Chức vụ',
                        member['role'],
                        textColor: roleColor,
                      ),
                      const Divider(),
                      _buildDetailItem(
                        Icons.calendar_today,
                        'Ngày tham gia',
                        '01/09/2023',
                      ),
                    ],
                  ),
                ),

                // Buttons
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingLarge,
                    vertical: AppConstants.paddingMedium,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _navigateToEditMember(context, member),
                        icon: const Icon(Icons.edit),
                        label: const Text('Chỉnh sửa'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingMedium,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        label: const Text('Đóng'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String label,
    String value, {
    Color? iconColor,
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (iconColor ?? AppConstants.primaryColor).withAlpha(
                (0.1 * 255).round(),
              ),
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusMedium,
              ),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppConstants.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: AppConstants.fontSizeSmall,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? AppConstants.textPrimaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Map<String, dynamic> member,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc chắn muốn xóa thành viên "${member['name']}" không?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }

  // Phương thức xây dựng giao diện thêm thành viên trong tab
  Widget _buildAddMember() {
    // Reset form khi tab được chọn (chỉ dùng cho thêm mới, không còn dùng cho chỉnh sửa)
    if (_selectedIndex == 1) {
      _resetForm();
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thêm thành viên mới',
            style: TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingLarge),

          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: idController,
                      decoration: const InputDecoration(
                        labelText: 'Mã số học sinh',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mã số học sinh';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),

                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Họ tên',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập họ tên';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),

                    // Bố cục giới tính bên trái và lớp bên phải chia đôi màn hình 50/50
                    Row(
                      children: [
                        // Giới tính - Bên trái (50%)
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: gender,
                            decoration: const InputDecoration(
                              labelText: 'Giới tính',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.wc),
                            ),
                            items:
                                ['Nam', 'Nữ'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                gender = newValue!;
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: AppConstants.paddingMedium),

                        // Lớp - Bên phải (50%)
                        Expanded(
                          child: TextFormField(
                            controller: classController,
                            decoration: const InputDecoration(
                              labelText: 'Lớp',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.class_),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập lớp';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),

                    DropdownButtonFormField<String>(
                      value: role,
                      decoration: const InputDecoration(
                        labelText: 'Chức vụ',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.work),
                      ),
                      items:
                          [
                            'THÀNH VIÊN',
                            'PHÓ CÂU LẠC BỘ',
                            'TRƯỞNG CÂU LẠC BỘ',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          role = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _saveMember,
                        icon: const Icon(Icons.save),
                        label: const Text('Thêm thành viên'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                          padding: const EdgeInsets.all(
                            AppConstants.paddingMedium,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingMedium),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Chuyển về tab danh sách sau khi hủy
                          setState(() {
                            _resetForm();
                            _selectedIndex = 0;
                            _currentTitle = _titles[0];
                          });
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text('Hủy'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(
                            AppConstants.paddingMedium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Phương thức xây dựng giao diện chỉnh sửa thành viên
  Widget _buildEditMember() {
    if (_editingMember == null) {
      return const Center(
        child: Text(
          'Không có thành viên được chọn để chỉnh sửa',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chỉnh sửa thành viên',
            style: TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingLarge),

          // Form chỉnh sửa
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: idController,
                      decoration: const InputDecoration(
                        labelText: 'Mã số học sinh',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mã số học sinh';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),

                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Họ tên',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập họ tên';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),

                    // Bố cục giới tính bên trái và lớp bên phải chia đôi màn hình 50/50
                    Row(
                      children: [
                        // Giới tính - Bên trái (50%)
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: gender,
                            decoration: const InputDecoration(
                              labelText: 'Giới tính',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.wc),
                            ),
                            items:
                                ['Nam', 'Nữ'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                gender = newValue!;
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: AppConstants.paddingMedium),

                        // Lớp - Bên phải (50%)
                        Expanded(
                          child: TextFormField(
                            controller: classController,
                            decoration: const InputDecoration(
                              labelText: 'Lớp',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.class_),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập lớp';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),

                    DropdownButtonFormField<String>(
                      value: role,
                      decoration: const InputDecoration(
                        labelText: 'Chức vụ',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.work),
                      ),
                      items:
                          [
                            'THÀNH VIÊN',
                            'PHÓ CÂU LẠC BỘ',
                            'TRƯỞNG CÂU LẠC BỘ',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          role = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _updateMember,
                        icon: const Icon(Icons.save),
                        label: const Text('Cập nhật thông tin'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                          padding: const EdgeInsets.all(
                            AppConstants.paddingMedium,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingMedium),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Chuyển về tab danh sách sau khi hủy
                          setState(() {
                            _resetForm();
                            _editingMember = null;
                            _selectedIndex = 0;
                            _currentTitle = _titles[0];
                          });
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text('Hủy'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(
                            AppConstants.paddingMedium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Phương thức xây dựng giao diện tìm kiếm và lọc
  Widget _buildSearchAndFilter() {
    // Sử dụng Scaffold để có thể điều chỉnh kích thước khi hiển thị bàn phím
    return Scaffold(
      // Không hiển thị appBar mới vì đã có appBar chính
      backgroundColor: Colors.transparent, // Để khớp với nền chính
      // Đảm bảo cài đặt này để tránh tràn màn hình khi bàn phím hiện lên
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        // Sử dụng SingleChildScrollView để cuộn toàn bộ nội dung khi cần
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề - Phần cố định
              const Text(
                'Tìm kiếm & Lọc thành viên',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.paddingLarge),

              // Thanh tìm kiếm - Phần cố định
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm thành viên...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusMedium,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: AppConstants.paddingMedium),

              // Phần có thể cuộn
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bộ lọc
                      const Text(
                        'Bộ lọc',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeLarge,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),

                      _buildDropdownField('Lớp', [
                        'Tất cả',
                        '10A1',
                        '10A9',
                        '10A11',
                        '11B6',
                        '11B9',
                        '11B10',
                        '12A3',
                        '12A6',
                        '12A7',
                        '12A16',
                      ]),
                      const SizedBox(height: AppConstants.paddingMedium),
                      _buildDropdownField('Giới tính', ['Tất cả', 'Nam', 'Nữ']),
                      const SizedBox(height: AppConstants.paddingMedium),
                      _buildDropdownField('Chức vụ', [
                        'Tất cả',
                        'THÀNH VIÊN',
                        'PHÓ CÂU LẠC BỘ',
                        'TRƯỞNG CÂU LẠC BỘ',
                      ]),
                      const SizedBox(height: AppConstants.paddingLarge),

                      // Nút xóa bộ lọc và áp dụng
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _searchController.clear();
                                });
                              },
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

                      const SizedBox(height: AppConstants.paddingLarge),

                      // Kết quả tìm kiếm - giới hạn chiều cao để không bị tràn
                      SizedBox(
                        height:
                            300, // Chiều cao cố định cho phần kết quả tìm kiếm
                        child:
                            _filteredMembers.isEmpty
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
                                  shrinkWrap: true,
                                  itemCount: _filteredMembers.length,
                                  itemBuilder: (context, index) {
                                    final member = _filteredMembers[index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            member['gender'] == 'Nam'
                                                ? Colors.blue.withAlpha(51)
                                                : Colors.pink.withAlpha(51),
                                        child: Text(
                                          _getInitials(member['name']),
                                          style: TextStyle(
                                            color:
                                                member['gender'] == 'Nam'
                                                    ? Colors.blue
                                                    : Colors.pink,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      title: Text(member['name'] ?? ''),
                                      subtitle: Text(
                                        '${member['id'] ?? '-'} - ${member['class'] ?? '-'}',
                                      ),
                                      trailing: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              member['role'] == 'PHÓ CÂU LẠC BỘ'
                                                  ? Colors.green.withAlpha(51)
                                                  : (member['role'] ==
                                                          'TRƯỞNG CÂU LẠC BỘ'
                                                      ? Colors.orange.withAlpha(
                                                        51,
                                                      )
                                                      : Colors.blue.withAlpha(
                                                        51,
                                                      )),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Text(
                                          member['role'] ?? 'THÀNH VIÊN',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                member['role'] ==
                                                        'PHÓ CÂU LẠC BỘ'
                                                    ? Colors.green
                                                    : (member['role'] ==
                                                            'TRƯỞNG CÂU LẠC BỘ'
                                                        ? Colors.orange
                                                        : Colors.blue),
                                          ),
                                        ),
                                      ),
                                      onTap:
                                          () => _showMemberDetails(
                                            context,
                                            member,
                                          ),
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Phương thức để xây dựng trường dropdown (chỉ sử dụng cho tab Search & Filter)
  Widget _buildDropdownField(String label, List<String> items) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
      items:
          items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
      onChanged: (value) {},
    );
  }

  // Phương thức chuyển hướng đến tab chỉnh sửa thành viên
  void _navigateToEditMember(
    BuildContext context,
    Map<String, dynamic> member,
  ) {
    // Đóng dialog chi tiết trước khi chuyển màn hình
    Navigator.of(context).pop();

    // Cập nhật form với thông tin của thành viên
    idController.text = member['id'];
    nameController.text = member['name'];
    classController.text = member['class'];

    setState(() {
      _editingMember = Map<String, dynamic>.from(member);
      gender = member['gender'];
      role = member['role'];
      _selectedIndex = 3; // Chuyển đến tab chỉnh sửa thành viên
      _currentTitle = _titles[3]; // Cập nhật tiêu đề
    });
  }
}
