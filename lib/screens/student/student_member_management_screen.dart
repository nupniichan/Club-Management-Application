import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/student/student_drawer_widget.dart';
import '../../widgets/student/student_app_bar_widget.dart';
import '../../models/member.dart';
import '../../services/member_data_service.dart';

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

  final MemberDataService _memberService = MemberDataService();
  List<Member> _members = [];

  // Form controllers và variables
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final classController = TextEditingController();
  String gender = 'Nam';
  String role = 'THÀNH VIÊN';

  // Biến để lưu trữ thành viên đang được chỉnh sửa
  Member? _editingMember;

  final List<String> _titles = [
    'Quản lý thành viên',
    'Thêm thành viên',
    'Tìm kiếm & Lọc',
    'Chỉnh sửa thành viên',
  ];

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  void _loadMembers() {
    setState(() {
      _members = _memberService.getAllMembers();
    });
  }

  List<Member> get _filteredMembers {
    if (_searchQuery.isEmpty) {
      return _members;
    }
    return _members.where((member) {
      return member.name.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          member.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          member.className.toLowerCase().contains(_searchQuery.toLowerCase());
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
      final newMember = Member(
        id: idController.text,
        name: nameController.text,
        gender: gender,
        className: classController.text,
        role: role,
      );

      // Thêm thành viên mới vào service
      _memberService.addMember(newMember);
      _loadMembers();

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
      final updatedMember = _editingMember!.copyWith(
        id: idController.text,
        name: nameController.text,
        gender: gender,
        className: classController.text,
        role: role,
      );

      // Cập nhật thành viên trong service
      _memberService.updateMember(updatedMember);
      _loadMembers();

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
      appBar: StudentAppBarWidget(title: _currentTitle),
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
            // Clear search when switching tabs
            if (index != 2) {
              _searchController.clear();
              _searchQuery = '';
            }
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
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppConstants.primaryColor.withOpacity(0.1),
                AppConstants.primaryColor.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.people,
                  size: 20,
                  color: AppConstants.primaryColor,
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quản lý thành viên',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppConstants.primaryColor,
                      ),
                    ),
              Text(
                'Tổng số: ${_filteredMembers.length} thành viên',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_filteredMembers.length}',
                style: const TextStyle(
                    color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredMembers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Chưa có thành viên nào',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hãy thêm thành viên đầu tiên của câu lạc bộ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                    ),
                  )
                  : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    itemCount: _filteredMembers.length,
                    itemBuilder: (context, index) {
                      final member = _filteredMembers[index];
                    final Color genderColor = member.gender == 'Nam' ? Colors.blue : Colors.pink;
                    final Color roleColor = _getRoleColor(member.role);
                    
                      return Card(
                      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.grey[50]!,
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
                                  Hero(
                                    tag: 'member-${member.id}',
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                          decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            genderColor,
                                            genderColor.withOpacity(0.7),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              _getInitials(member.name),
                                          style: const TextStyle(
                                            color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                            fontSize: 20,
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
                                                member.name,
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
                                            Icon(Icons.badge, size: 14, color: Colors.grey[600]),
                                            const SizedBox(width: 4),
                                              Text(
                                                member.id.toString(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildActionButton(
                                        icon: Icons.visibility,
                                          color: Colors.blue,
                                        onPressed: () => _showMemberDetails(context, member),
                                        tooltip: 'Xem chi tiết',
                                      ),
                                      const SizedBox(width: 8),
                                      _buildActionButton(
                                        icon: Icons.edit,
                                          color: Colors.green,
                                        onPressed: () => _navigateToEditMember(context, member),
                                        tooltip: 'Chỉnh sửa',
                                      ),
                                      const SizedBox(width: 8),
                                      _buildActionButton(
                                        icon: Icons.delete,
                                          color: Colors.red,
                                        onPressed: () => _showDeleteConfirmation(context, member),
                                        tooltip: 'Xóa',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppConstants.paddingLarge),
                              Container(
                                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                children: [
                                    Expanded(
                                      child: _buildMemberStat(
                                        'Lớp',
                                        member.className,
                                    Icons.class_,
                                        Colors.blue,
                                      ),
                                    ),
                                    Container(
                                      width: 1,
                                      height: 40,
                                      color: Colors.grey[300],
                                    ),
                                    Expanded(
                                      child: _buildMemberStat(
                                        'Giới tính',
                                        member.gender,
                                        member.gender == 'Nam' ? Icons.male : Icons.female,
                                        genderColor,
                                      ),
                                    ),
                              Container(
                                      width: 1,
                                      height: 40,
                                      color: Colors.grey[300],
                                    ),
                                    Expanded(
                                      child: _buildMemberStat(
                                        'Chức vụ',
                                        member.role == 'THÀNH VIÊN' ? 'TV' : 
                                        (member.role == 'PHÓ CÂU LẠC BỘ' ? 'PHÓ' : 'TRƯỞNG'),
                                        Icons.work,
                                        roleColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'PHÓ CÂU LẠC BỘ':
        return Colors.green;
      case 'TRƯỞNG CÂU LẠC BỘ':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: IconButton(
        icon: Icon(icon, size: 18),
        color: color,
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildMemberStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  void _showMemberDetails(BuildContext context, Member member) {
    final Color genderColor =
        member.gender == 'Nam' ? Colors.blue : Colors.pink;
    final Color roleColor =
        member.role == 'PHÓ CÂU LẠC BỘ'
            ? Colors.green
            : (member.role == 'TRƯỞNG CÂU LẠC BỘ'
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
                        tag: 'member-${member.id}',
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
                              _getInitials(member.ten),
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
                              member.ten,
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
                                member.vaiTro,
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
                        member.id.toString(),
                      ),
                      const Divider(),
                      _buildDetailItem(
                        member.gioiTinh == 'Nam' ? Icons.male : Icons.female,
                        'Giới tính',
                        member.gioiTinh,
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
    Member member,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc chắn muốn xóa thành viên "${member.name}" không?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                _memberService.deleteMember(member.id);
                _loadMembers();
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.primaryColor.withOpacity(0.1),
                      AppConstants.primaryColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppConstants.primaryColor.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingMedium),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                'Tìm kiếm & Lọc thành viên',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tìm kiếm thành viên theo tên, mã số hoặc lớp',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    hintText: 'Tìm kiếm theo tên, mã số học sinh, lớp...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: AppConstants.primaryColor),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                      borderSide: BorderSide(color: AppConstants.primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                ),
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingMedium,
                          vertical: AppConstants.paddingSmall,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppConstants.primaryColor.withOpacity(0.1)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.filter_list,
                              size: 16,
                              color: AppConstants.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Kết quả tìm kiếm: ${_filteredMembers.length} thành viên',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppConstants.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      SizedBox(
                        height: 300,
                        child: _filteredMembers.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 48,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                    'Không tìm thấy thành viên',
                                    style: TextStyle(
                                      fontSize: 16,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Thử thay đổi từ khóa tìm kiếm hoặc bộ lọc',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                  ),
                                )
                                : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _filteredMembers.length,
                                  itemBuilder: (context, index) {
                                    final member = _filteredMembers[index];
                                  final Color genderColor = member.gender == 'Nam' ? Colors.blue : Colors.pink;
                                  final Color roleColor = _getRoleColor(member.role);
                                  
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white,
                                            Colors.grey[50]!,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(AppConstants.paddingMedium),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        genderColor,
                                                        genderColor.withOpacity(0.7),
                                                      ],
                                                    ),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Center(
                                        child: Text(
                                          _getInitials(member.name),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                                        fontSize: 16,
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
                                                        member.name,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                        '${member.id} - ${member.className}',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey[600],
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    _buildActionButton(
                                                      icon: Icons.visibility,
                                                      color: Colors.blue,
                                                      onPressed: () => _showMemberDetails(context, member),
                                                      tooltip: 'Xem chi tiết',
                                                    ),
                                                    const SizedBox(width: 6),
                                                    _buildActionButton(
                                                      icon: Icons.edit,
                                                      color: Colors.green,
                                                      onPressed: () => _navigateToEditMember(context, member),
                                                      tooltip: 'Chỉnh sửa',
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: AppConstants.paddingSmall),
                                            Container(
                                              padding: const EdgeInsets.all(AppConstants.paddingSmall),
                                        decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Icon(member.gender == 'Nam' ? Icons.male : Icons.female, 
                                                             size: 16, color: genderColor),
                                                        const SizedBox(width: 4),
                                                        Flexible(
                                                          child: Text(
                                                            member.gender,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                              color: genderColor,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 1,
                                                    height: 20,
                                                    color: Colors.grey[300],
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(Icons.class_, size: 16, color: Colors.blue),
                                                        const SizedBox(width: 4),
                                                        Flexible(
                                        child: Text(
                                                            member.className,
                                                            style: const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.blue,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 1,
                                                    height: 20,
                                                    color: Colors.grey[300],
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Icon(Icons.work, size: 16, color: roleColor),
                                                        const SizedBox(width: 4),
                                                        Flexible(
                                                          child: Text(
                                                            member.role == 'THÀNH VIÊN' ? 'TV' : 
                                                            (member.role == 'PHÓ CÂU LẠC BỘ' ? 'PHÓ' : 'TRƯỞNG'),
                                          style: TextStyle(
                                            fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                              color: roleColor,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
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
                                      ),
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
    Member member,
  ) {
    // Cập nhật form với thông tin của thành viên
    idController.text = member.id;
    nameController.text = member.name;
    classController.text = member.className;

    setState(() {
      _editingMember = member;
      gender = member.gender;
      role = member.role;
      _selectedIndex = 3; // Chuyển đến tab chỉnh sửa thành viên
      _currentTitle = _titles[3]; // Cập nhật tiêu đề
    });
  }
}
