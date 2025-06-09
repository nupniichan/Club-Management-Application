import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/manager/manager_drawer_widget.dart';
import '../../widgets/manager/manager_app_bar_widget.dart';
import '../../models/club.dart';
import '../../services/club_data_service.dart';

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

  // Constants
  static const List<String> _categories = ['Công Nghệ', 'Nghệ thuật', 'Thể thao'];
  static const List<String> _statuses = ['Còn hoạt động', 'Tạm dừng'];

  final ClubDataService _clubService = ClubDataService();
  List<Club> _clubs = [];
  List<Club> _filteredClubs = [];

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rulesController = TextEditingController();
  final _advisorController = TextEditingController();
  final _leaderController = TextEditingController();
  final _budgetController = TextEditingController();
  String? _selectedCategory;

  // Search and filter controllers
  final _searchController = TextEditingController();
  String _filterCategory = 'Tất cả';
  String _filterStatus = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _loadClubs();
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _rulesController.dispose();
    _advisorController.dispose();
    _leaderController.dispose();
    _budgetController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadClubs() {
    setState(() {
      _clubs = _clubService.getAllClubs();
      _filteredClubs = _clubs;
    });
  }

  void _performSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredClubs = _clubs.where((club) {
        final matchesSearch = query.isEmpty || 
                              club.ten.toLowerCase().contains(query) ||
                              club.linhVucHoatDong.toLowerCase().contains(query) ||
                              club.giaoVienPhuTrach.toLowerCase().contains(query);
        
        final matchesCategory = _filterCategory == 'Tất cả' || 
                                club.linhVucHoatDong == _filterCategory;
        
        final matchesStatus = _filterStatus == 'Tất cả' || 
                              (_filterStatus == 'Hoạt động' && club.tinhTrang == 'Còn hoạt động') ||
                              (_filterStatus == 'Tạm dừng' && club.tinhTrang == 'Tạm dừng');
        
        return matchesSearch && matchesCategory && matchesStatus;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _filterCategory = 'Tất cả';
      _filterStatus = 'Tất cả';
      _filteredClubs = _clubs;
    });
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _rulesController.clear();
    _advisorController.clear();
    _leaderController.clear();
    _budgetController.clear();
    setState(() {
      _selectedCategory = null;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newClub = Club(
        id: timestamp.toString(),
        clubId: timestamp,
        ten: _nameController.text,
        logo: 'assets/images/default_club_logo.png',
        linhVucHoatDong: _selectedCategory!,
        mieuTa: _descriptionController.text,
        quyDinh: _rulesController.text,
        ngayThanhLap: DateTime.now().toIso8601String(),
        giaoVienPhuTrach: _advisorController.text,
        truongBanCLB: _leaderController.text,
        thanhVien: [],
        budget: int.tryParse(_budgetController.text) ?? 0,
        tinhTrang: 'Còn hoạt động',
      );
      
      _clubService.addClub(newClub);
      _loadClubs();
      _clearForm();
      _showSuccessDialog('Thêm câu lạc bộ "${newClub.ten}" thành công!');
    } else if (_selectedCategory == null) {
      _showErrorDialog('Vui lòng chọn danh mục cho câu lạc bộ!');
    }
  }

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
    final activeClubs = _clubService.getActiveClubs().length;
    final displayClubs = _selectedIndex == 2 ? _filteredClubs : _clubs;
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  '$activeClubs',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          
          Text(
            'Danh sách câu lạc bộ (${displayClubs.length})',
            style: const TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          
          Expanded(
            child: displayClubs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.business_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Không tìm thấy câu lạc bộ nào',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: displayClubs.length,
                    itemBuilder: (context, index) {
                      final club = displayClubs[index];
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

  Widget _buildClubCard(Club club) {
    final isActive = club.tinhTrang == 'Còn hoạt động';
    final statusColor = isActive ? Colors.green : Colors.orange;
    final categoryColors = {
      'Công Nghệ': Colors.blue,
      'Nghệ thuật': Colors.purple,
      'Thể thao': Colors.red,
    };
    final categoryColor = categoryColors[club.linhVucHoatDong] ?? Colors.grey;

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
                        club.ten[0].toUpperCase(),
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
                          club.ten,
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
                                club.linhVucHoatDong,
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
                                '${club.thanhVien.length} người',
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
                                _formatCurrency(club.budget),
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
                            club.giaoVienPhuTrach,
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
                    label: const Text('Xem chi tiết'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16, 
                        vertical: 8
                      ),
                      side: const BorderSide(color: Colors.blue),
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => _showChangeStatusDialog(club),
                    icon: const Icon(Icons.swap_horiz, size: 16),
                    label: const Text('Trạng thái'),
                    style: FilledButton.styleFrom(
                      backgroundColor: club.tinhTrang == 'Còn hoạt động' ? Colors.orange : Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16, 
                        vertical: 8
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildFormField(
                      controller: _nameController,
                      label: 'Tên câu lạc bộ',
                      icon: Icons.business,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên câu lạc bộ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    _buildFormField(
                      controller: _descriptionController,
                      label: 'Mô tả',
                      icon: Icons.description,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mô tả';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    _buildFormField(
                      controller: _rulesController,
                      label: 'Quy định',
                      icon: Icons.rule,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập quy định';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    _buildCategoryDropdown(),
                    const SizedBox(height: AppConstants.paddingMedium),
                    _buildFormField(
                      controller: _advisorController,
                      label: 'Giáo viên phụ trách',
                      icon: Icons.school,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên giáo viên phụ trách';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    _buildFormField(
                      controller: _leaderController,
                      label: 'Trưởng ban câu lạc bộ',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên trưởng ban';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    _buildFormField(
                      controller: _budgetController,
                      label: 'Ngân sách (VNĐ)',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập ngân sách';
                        }
                        final amount = int.tryParse(value);
                        if (amount == null || amount < 0) {
                          return 'Ngân sách phải là số không âm';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _clearForm,
                            child: const Text('Xóa form'),
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _submitForm,
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
                  ],
                ),
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
        children: [
          // Thanh tìm kiếm
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm câu lạc bộ...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          
          // Phần có thể cuộn
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bộ lọc',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  
                  DropdownButtonFormField<String>(
                    value: _filterCategory,
                    decoration: InputDecoration(
                      labelText: 'Danh mục',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                      ),
                    ),
                    items: ['Tất cả', ..._categories].map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _filterCategory = value!;
                      });
                      _performSearch();
                    },
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  
                  DropdownButtonFormField<String>(
                    value: _filterStatus,
                    decoration: InputDecoration(
                      labelText: 'Trạng thái',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                      ),
                    ),
                    items: ['Tất cả', 'Hoạt động', 'Tạm dừng'].map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _filterStatus = value!;
                      });
                      _performSearch();
                    },
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  
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
                        Expanded(
                          child: Text(
                            'Kết quả: ${_filteredClubs.length} câu lạc bộ',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeMedium,
                              fontWeight: FontWeight.w500,
                              color: AppConstants.primaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),
                  
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _clearFilters,
                          child: const Text(
                            'Xóa bộ lọc',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 0;
                              _currentTitle = _titles[0];
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Xem kết quả',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  
                  // Kết quả tìm kiếm
                  if (_filteredClubs.isEmpty)
                    Container(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _searchController.text.isEmpty ? Icons.search : Icons.search_off,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isEmpty 
                                ? 'Nhập từ khóa để tìm kiếm'
                                : 'Không tìm thấy câu lạc bộ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _searchController.text.isEmpty
                                ? 'Tìm kiếm theo tên câu lạc bộ, lĩnh vực hoặc giáo viên'
                                : 'Thử thay đổi từ khóa tìm kiếm hoặc bộ lọc',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      children: _filteredClubs.map((club) => _buildClubCard(club)).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Danh mục',
        prefixIcon: const Icon(Icons.category),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
      items: _categories.map((category) => DropdownMenuItem(
        value: category,
        child: Text(category),
      )).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng chọn danh mục';
        }
        return null;
      },
    );
  }

  void _handleClubAction(String action, Club club) {
    switch (action) {
      case 'view':
        _showClubDetails(club);
        break;
      case 'edit':
        _showSuccessDialog('Chỉnh sửa ${club.ten}');
        break;
      case 'delete':
        _showDeleteConfirmation(club);
        break;
    }
  }

  void _showClubDetails(Club club) {
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
                  club.ten[0].toUpperCase(),
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
                    club.ten,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ID: ${club.clubId}',
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
              _buildClubDetailRow('Tên câu lạc bộ', club.ten, Icons.business),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildClubDetailRow('Lĩnh vực hoạt động', club.linhVucHoatDong, Icons.category),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildClubDetailRow('Ngày thành lập', _formatDate(club.ngayThanhLap), Icons.calendar_today),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildClubDetailRow('Giáo viên phụ trách', club.giaoVienPhuTrach, Icons.school),
              const SizedBox(height: 8),
              _buildClubDetailRow('Trưởng ban CLB', club.truongBanCLB, Icons.person),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildClubDetailRow('Số thành viên', '${club.thanhVien.length} người', Icons.people),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildClubDetailRow('Ngân sách', _formatCurrency(club.budget), Icons.attach_money, 
                      colorValue: Colors.green[700]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildClubDetailRow('Tình trạng', club.tinhTrang, Icons.info, 
                colorValue: club.tinhTrang == 'Còn hoạt động' ? Colors.green : Colors.orange),
              const SizedBox(height: 8),
              _buildClubDetailRow('Mô tả', club.mieuTa, Icons.description),
              const SizedBox(height: 8),
              _buildClubDetailRow('Quy định', club.quyDinh, Icons.rule),
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

  void _showDeleteConfirmation(Club club) {
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
                      club.ten[0].toUpperCase(),
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
                          club.ten,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${club.thanhVien.length} thành viên • ${_formatCurrency(club.budget)}',
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
              _clubService.deleteClub(club.id);
              _loadClubs();
              Navigator.pop(context);
              _showSuccessDialog('Đã xóa câu lạc bộ "${club.ten}" thành công!');
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

  void _showChangeStatusDialog(Club club) {
    final currentStatus = club.tinhTrang;
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
            Text('Bạn có muốn thay đổi trạng thái của câu lạc bộ "${club.ten}" không?'),
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
              final updatedClub = club.copyWith(tinhTrang: newStatus);
              _clubService.updateClub(updatedClub);
              _loadClubs();
              Navigator.pop(context);
              _showSuccessDialog('Đã thay đổi trạng thái câu lạc bộ "${club.ten}" thành "$newStatus"');
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('Lỗi'),
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