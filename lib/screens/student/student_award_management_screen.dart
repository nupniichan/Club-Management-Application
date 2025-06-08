import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/student/student_drawer_widget.dart';
import '../../widgets/student/student_app_bar_widget.dart';
import '../../models/award.dart';
import '../../services/award_data_service.dart';

class StudentAwardManagementScreen extends StatefulWidget {
  final String? userName;
  final String? userRole;

  const StudentAwardManagementScreen({
    super.key,
    this.userName = 'Sinh viên',
    this.userRole = 'Thành viên câu lạc bộ',
  });

  @override
  State<StudentAwardManagementScreen> createState() =>
      _StudentAwardManagementScreenState();
}

class _StudentAwardManagementScreenState
    extends State<StudentAwardManagementScreen> {
  int _selectedIndex = 0;
  String _currentTitle = 'Quản lý giải thưởng';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _titles = [
    'Quản lý giải thưởng',
    'Thêm giải thưởng',
    'Tìm kiếm & Lọc',
    'Chỉnh sửa giải thưởng',
  ];

  // Form controllers for editing
  final _formKey = GlobalKey<FormState>();
  final awardNameController = TextEditingController();
  final memberNameController = TextEditingController();
  final dateController = TextEditingController();
  final noteController = TextEditingController();
  String selectedAwardType = 'Giải nhất';
  Award? _editingAward;

  final AwardDataService _awardService = AwardDataService();
  List<Award> _awards = [];

  @override
  void initState() {
    super.initState();
    _loadAwards();
  }

  void _loadAwards() {
    setState(() {
      _awards = _awardService.getAllAwards();
    });
  }

  List<Award> get _filteredAwards {
    return _awards.where((award) {
      return _searchQuery.isEmpty ||
          award.tenGiaiThuong.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          award.loaiGiai.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          award.thanhVienDatGiai.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          award.ghiChu.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    awardNameController.dispose();
    memberNameController.dispose();
    dateController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Color _getAwardTypeColor(String loaiGiai) {
    switch (loaiGiai) {
      case 'Giải nhất':
        return Colors.red;
      case 'Giải nhì':
        return Colors.orange;
      case 'Giải ba':
        return Colors.blue;
      case 'Giải khuyến khích':
        return Colors.green;
      default:
        return AppConstants.primaryColor;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StudentAppBarWidget(title: _currentTitle),
      drawer: StudentDrawerWidget(
        currentPage: 'award_management',
        userName: widget.userName!,
        userRole: widget.userRole!,
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
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
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Danh sách'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Thêm mới'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    // If editing, show edit form regardless of selectedIndex
    if (_editingAward != null) {
      return _buildEditAward();
    }
    
    switch (_selectedIndex) {
      case 0:
        return _buildAwardList();
      case 1:
        return _buildAddAward();
      case 2:
        return _buildSearchAndFilter();
      default:
        return _buildAwardList();
    }
  }

  Widget _buildAwardList() {
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
                  Icons.emoji_events,
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
                      'Danh sách giải thưởng',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    Text(
                      'Tổng số: ${_filteredAwards.length} giải thưởng',
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
                  '${_filteredAwards.length}',
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
          child: _filteredAwards.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Chưa có giải thưởng nào',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hãy thêm giải thưởng đầu tiên của câu lạc bộ',
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
                  itemCount: _filteredAwards.length,
                  itemBuilder: (context, index) {
                    final award = _filteredAwards[index];
                    final Color awardColor = _getAwardTypeColor(award.loaiGiai);
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              awardColor.withOpacity(0.05),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          awardColor,
                                          awardColor.withOpacity(0.7),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: awardColor.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.emoji_events,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppConstants.paddingMedium),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          award.tenGiaiThuong,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Thành viên: ${award.thanhVienDatGiai}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: awardColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: awardColor.withOpacity(0.3)),
                                    ),
                                    child: Text(
                                      award.loaiGiai,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: awardColor,
                                      ),
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
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Icon(Icons.calendar_today, 
                                               color: Colors.blue, size: 20),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Ngày đạt giải',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            _formatDate(award.ngayDatGiai),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 1,
                                      height: 50,
                                      color: Colors.grey[300],
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Icon(Icons.person, 
                                               color: Colors.green, size: 20),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Thành viên',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            award.thanhVienDatGiai,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 1,
                                      height: 50,
                                      color: Colors.grey[300],
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Icon(Icons.image, 
                                               color: Colors.orange, size: 20),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Hình ảnh',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            award.anhDatGiai.isNotEmpty ? 'Có' : 'Không',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (award.ghiChu.isNotEmpty) ...[
                                const SizedBox(height: AppConstants.paddingMedium),
                                Text(
                                  award.ghiChu,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              const SizedBox(height: AppConstants.paddingMedium),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () => _showAwardDetails(context, award),
                                    icon: const Icon(Icons.visibility, size: 16),
                                    label: const Text('Xem chi tiết'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                      side: const BorderSide(color: Colors.blue),
                                      foregroundColor: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  FilledButton.icon(
                                    onPressed: () => _navigateToEditAward(award),
                                    icon: const Icon(Icons.edit, size: 16),
                                    label: const Text('Chỉnh sửa'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    ),
                                  ),
                                ],
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

  Widget _buildAddAward() {
    return const Center(
      child: Text(
        'Chức năng thêm giải thưởng (đang phát triển)',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
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
                        'Tìm kiếm giải thưởng',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeXLarge,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tìm kiếm theo tên giải thưởng, loại giải hoặc thành viên',
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
                hintText: 'Tìm kiếm theo tên giải thưởng, loại giải, thành viên...',
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
          if (_searchQuery.isNotEmpty) ...[
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
                    'Kết quả tìm kiếm: ${_filteredAwards.length} giải thưởng',
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
          ],
          Expanded(
            child: _filteredAwards.isEmpty && _searchQuery.isNotEmpty
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
                          'Không tìm thấy giải thưởng',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Thử thay đổi từ khóa tìm kiếm',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _searchQuery.isEmpty ? 0 : _filteredAwards.length,
                    itemBuilder: (context, index) {
                      final award = _filteredAwards[index];
                      final Color awardColor = _getAwardTypeColor(award.loaiGiai);
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [awardColor, awardColor.withOpacity(0.7)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.emoji_events,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          title: Text(
                            award.tenGiaiThuong,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            '${award.loaiGiai} • ${award.thanhVienDatGiai}',
                            style: TextStyle(color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8, 
                                  vertical: 4
                                ),
                                decoration: BoxDecoration(
                                  color: awardColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  award.loaiGiai,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: awardColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios, 
                                   size: 16, color: Colors.grey[400]),
                            ],
                          ),
                          onTap: () => _showAwardDetails(context, award),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Navigate to edit award
  void _navigateToEditAward(Award award) {
    awardNameController.text = award.tenGiaiThuong;
    memberNameController.text = award.thanhVienDatGiai;
    dateController.text = _formatDate(award.ngayDatGiai);
    noteController.text = award.ghiChu;
    
    setState(() {
      _editingAward = award;
      selectedAwardType = award.loaiGiai;
      _currentTitle = _titles[3];
    });
  }

  // Build edit award form
  Widget _buildEditAward() {
    if (_editingAward == null) {
      return const Center(
        child: Text(
          'Không có giải thưởng được chọn để chỉnh sửa',
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
            'Chỉnh sửa giải thưởng',
            style: TextStyle(
              fontSize: AppConstants.fontSizeXXLarge,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimaryColor,
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
                      controller: awardNameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên giải thưởng',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.emoji_events),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên giải thưởng';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    
                    DropdownButtonFormField<String>(
                      value: selectedAwardType,
                      decoration: const InputDecoration(
                        labelText: 'Loại giải',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.military_tech),
                      ),
                      items: ['Giải nhất', 'Giải nhì', 'Giải ba', 'Giải khuyến khích']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedAwardType = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    
                    TextFormField(
                      controller: memberNameController,
                      decoration: const InputDecoration(
                        labelText: 'Thành viên đạt giải',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên thành viên';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    
                    TextFormField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        labelText: 'Ngày đạt giải',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng chọn ngày';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    
                    TextFormField(
                      controller: noteController,
                      decoration: const InputDecoration(
                        labelText: 'Ghi chú',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.note),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _updateAward,
                        icon: const Icon(Icons.save),
                        label: const Text(
                          'Cập nhật giải thưởng',
                          style: TextStyle(fontSize: AppConstants.fontSizeLarge),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                          padding: const EdgeInsets.all(AppConstants.paddingMedium),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _resetForm();
                            _editingAward = null;
                            _currentTitle = _titles[_selectedIndex];
                          });
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text(
                          'Hủy',
                          style: TextStyle(fontSize: AppConstants.fontSizeLarge),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(AppConstants.paddingMedium),
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

  // Reset form
  void _resetForm() {
    awardNameController.clear();
    memberNameController.clear();
    dateController.clear();
    noteController.clear();
    setState(() {
      selectedAwardType = 'Giải nhất';
    });
  }

  // Select date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // Update award
  void _updateAward() {
    if (_formKey.currentState!.validate() && _editingAward != null) {
      final updatedAward = _editingAward!.copyWith(
        tenGiaiThuong: awardNameController.text,
        loaiGiai: selectedAwardType,
        thanhVienDatGiai: memberNameController.text,
        ngayDatGiai: _convertDateFormat(dateController.text),
        ghiChu: noteController.text,
      );

      _awardService.updateAward(updatedAward);
      _loadAwards();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Đã cập nhật thông tin giải thưởng',
            style: TextStyle(fontSize: AppConstants.fontSizeLarge),
          ),
          backgroundColor: Colors.green,
        ),
      );

      _resetForm();
      setState(() {
        _editingAward = null;
        _selectedIndex = 0;
        _currentTitle = _titles[0];
      });
    }
  }

  // Convert date format
  String _convertDateFormat(String dateStr) {
    final parts = dateStr.split('/');
    if (parts.length == 3) {
      return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
    }
    return dateStr;
  }

  // Show award details (need to add edit button)
  void _showAwardDetails(BuildContext context, Award award) {
    final Color awardColor = _getAwardTypeColor(award.loaiGiai);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  decoration: BoxDecoration(
                    color: awardColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppConstants.borderRadiusLarge),
                      topRight: Radius.circular(AppConstants.borderRadiusLarge),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [awardColor, awardColor.withOpacity(0.7)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.emoji_events,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              award.tenGiaiThuong,
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeXLarge,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: awardColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                award.loaiGiai,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: AppConstants.fontSizeSmall,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(Icons.person, 'Thành viên đạt giải', award.thanhVienDatGiai),
                        const SizedBox(height: AppConstants.paddingMedium),
                        _buildDetailRow(Icons.calendar_today, 'Ngày đạt giải', _formatDate(award.ngayDatGiai)),
                        const SizedBox(height: AppConstants.paddingMedium),
                        _buildDetailRow(Icons.note, 'Ghi chú', award.ghiChu),
                      ],
                    ),
                  ),
                ),
                
                // Footer Actions
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(AppConstants.borderRadiusLarge),
                      bottomRight: Radius.circular(AppConstants.borderRadiusLarge),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _navigateToEditAward(award);
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text(
                            'Chỉnh sửa',
                            style: TextStyle(fontSize: AppConstants.fontSizeLarge),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                          label: const Text(
                            'Đóng',
                            style: TextStyle(fontSize: AppConstants.fontSizeLarge),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppConstants.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
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

  // Build detail row
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppConstants.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: AppConstants.paddingMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppConstants.textSecondaryColor,
                  fontSize: AppConstants.fontSizeSmall,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}