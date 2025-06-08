import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/student/student_drawer_widget.dart';
import '../../widgets/student/student_app_bar_widget.dart';

class StudentBudgetManagementScreen extends StatefulWidget {
  final String? userName;
  final String? userRole;

  const StudentBudgetManagementScreen({
    super.key,
    this.userName = 'Sinh viên',
    this.userRole = 'Thành viên câu lạc bộ',
  });

  @override
  State<StudentBudgetManagementScreen> createState() =>
      _StudentBudgetManagementScreenState();
}

class _StudentBudgetManagementScreenState
    extends State<StudentBudgetManagementScreen> {
  int _selectedIndex = 0;
  String _currentTitle = 'Quản lý ngân sách';

  final List<String> _titles = [
    'Quản lý ngân sách',
    'Thêm ngân sách',
    'Tìm kiếm ngân sách',
    'Chỉnh sửa ngân sách',
  ];

  // Updated mock data based on MongoDB structure
  final List<Map<String, dynamic>> _budgets = [
    {
      '_id': 18,
      'ten': 'Ngân sách tổ chức sự kiện IT Day',
      'khoanChiTieu': 4000000,
      'nguonThu': 5000000,
      'ngay': '2024-11-19',
      'thanhVienChiuTrachNhiem': 'Nguyễn Phi Quốc Bảo',
      'noiDung': 'Ngân sách thu từ việc bán vé và chi tiêu tổ chức sự kiện',
      'club': '67160c5ad55fc5f816de7644',
    },
    {
      '_id': 19,
      'ten': 'Ngân sách Hackathon X',
      'khoanChiTieu': 3500000,
      'nguonThu': 4200000,
      'ngay': '2024-12-15',
      'thanhVienChiuTrachNhiem': 'Trần Văn B',
      'noiDung': 'Ngân sách cho cuộc thi lập trình 24h',
      'club': '67160c5ad55fc5f816de7644',
    },
    {
      '_id': 20,
      'ten': 'Ngân sách Workshop AI',
      'khoanChiTieu': 2500000,
      'nguonThu': 3000000,
      'ngay': '2024-10-30',
      'thanhVienChiuTrachNhiem': 'Lê Thị C',
      'noiDung': 'Chi phí tổ chức workshop về trí tuệ nhân tạo',
      'club': '67160c5ad55fc5f816de7644',
    },
  ];

  // Form controllers and variables for budget management
  final _formKey = GlobalKey<FormState>();
  final eventNameController = TextEditingController();
  final budgetController = TextEditingController();
  final expenditureController = TextEditingController();
  final dateController = TextEditingController();
  final personInChargeController = TextEditingController();
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    eventNameController.dispose();
    budgetController.dispose();
    expenditureController.dispose();
    dateController.dispose();
    personInChargeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String _formatCurrency(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M VNĐ';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K VNĐ';
    } else {
      return '$amount VNĐ';
    }
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _convertDateFormat(String dateStr) {
    // Convert from DD/MM/YYYY to YYYY-MM-DD
    final parts = dateStr.split('/');
    if (parts.length == 3) {
      return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
    }
    return dateStr;
  }

  // Variable to store the budget being edited
  Map<String, dynamic>? _editingBudget;

  DateTime? _selectedDate;
  String? _filterPersonInCharge;
  String? _filterYear;

  // Show budget details in a dialog
  void _showBudgetDetails(BuildContext context, Map<String, dynamic> budget) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
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
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppConstants.primaryColor.withAlpha(51),
                        ),
                        child: Center(
                          child: Text(
                            budget['ten'][0].toUpperCase(),
                            style: const TextStyle(
                              color: AppConstants.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: AppConstants.fontSizeXLarge,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: Text(
                          budget['ten'],
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeXLarge,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content - Scrollable
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailCard(
                          Icons.account_balance_wallet,
                          'Ngân sách',
                          _formatCurrency(budget['nguonThu']),
                          Colors.green,
                        ),
                        const SizedBox(height: AppConstants.paddingMedium),
                        
                        _buildDetailCard(
                          Icons.money_off,
                          'Chi tiêu',
                          _formatCurrency(budget['khoanChiTieu']),
                          Colors.red,
                        ),
                        const SizedBox(height: AppConstants.paddingMedium),
                        
                        _buildDetailCard(
                          Icons.calendar_today,
                          'Ngày',
                          _formatDate(budget['ngay']),
                          AppConstants.primaryColor,
                        ),
                        const SizedBox(height: AppConstants.paddingMedium),
                        
                        _buildDetailCard(
                          Icons.person,
                          'Thành viên phụ trách',
                          budget['thanhVienChiuTrachNhiem'],
                          Colors.blue,
                        ),
                        const SizedBox(height: AppConstants.paddingMedium),
                        
                        _buildDetailCard(
                          Icons.description,
                          'Nội dung',
                          budget['noiDung'],
                          Colors.purple,
                        ),
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
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      label: const Text(
                        'Đóng',
                        style: TextStyle(fontSize: AppConstants.fontSizeLarge),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.paddingMedium,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build detail item for dialog (old style)
  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusMedium,
              ),
            ),
            child: Icon(icon, color: AppConstants.primaryColor, size: 20),
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
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textPrimaryColor,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build detail card for dialog (new style)
  Widget _buildDetailCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
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
                  maxLines: null, // Allow unlimited lines for content
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmation(
    BuildContext context,
    Map<String, dynamic> budget,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc chắn muốn xóa ngân sách cho sự kiện "${budget['ten']}" không?',
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
                  _budgets.removeWhere(
                    (b) => b['_id'] == budget['_id'],
                  );
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa ngân sách'),
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

  // Reset form to default state
  void _resetForm() {
    eventNameController.clear();
    budgetController.clear();
    expenditureController.clear();
    dateController.clear();
    personInChargeController.clear();
    setState(() {
      _searchQuery = '';
      _searchController.clear();
      _selectedDate = null;
      _filterPersonInCharge = null;
      _filterYear = null;
    });
  }

  // Add method to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // Method to save a new budget
  void _saveBudget() {
    if (_formKey.currentState!.validate()) {
      final newBudget = {
        '_id': DateTime.now().millisecondsSinceEpoch,
        'ten': eventNameController.text,
        'nguonThu': int.tryParse(budgetController.text.replaceAll(',', '')) ?? 0,
        'khoanChiTieu': int.tryParse(expenditureController.text.replaceAll(',', '')) ?? 0,
        'ngay': _convertDateFormat(dateController.text),
        'thanhVienChiuTrachNhiem': personInChargeController.text,
        'noiDung': 'Ngân sách được thêm mới',
        'club': '67160c5ad55fc5f816de7644',
      };

      setState(() {
        _budgets.add(newBudget);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã thêm ngân sách mới'),
          backgroundColor: Colors.green,
        ),
      );

      _resetForm();
      setState(() {
        _selectedIndex = 0;
        _currentTitle = _titles[0];
      });
    }
  }

  // Method to update an existing budget
  void _updateBudget() {
    if (_formKey.currentState!.validate() && _editingBudget != null) {
      final updatedBudget = Map<String, dynamic>.from(_editingBudget!);
      updatedBudget['ten'] = eventNameController.text;
      updatedBudget['nguonThu'] = int.tryParse(budgetController.text.replaceAll(',', '')) ?? 0;
      updatedBudget['khoanChiTieu'] = int.tryParse(expenditureController.text.replaceAll(',', '')) ?? 0;
      updatedBudget['ngay'] = _convertDateFormat(dateController.text);
      updatedBudget['thanhVienChiuTrachNhiem'] = personInChargeController.text;

      setState(() {
        final index = _budgets.indexWhere(
          (b) => b['_id'] == _editingBudget!['_id'],
        );
        if (index != -1) {
          _budgets[index] = updatedBudget;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã cập nhật thông tin ngân sách'),
          backgroundColor: Colors.green,
        ),
      );

      _resetForm();
      setState(() {
        _editingBudget = null;
        _selectedIndex = 0;
        _currentTitle = _titles[0];
      });
    }
  }

  // Method to navigate to edit budget
  void _navigateToEditBudget(BuildContext context, Map<String, dynamic> budget) {
    // Remove Navigator.of(context).pop() since this is called from the list, not a dialog
    eventNameController.text = budget['ten'];
    budgetController.text = budget['nguonThu'].toString();
    expenditureController.text = budget['khoanChiTieu'].toString();
    dateController.text = _formatDate(budget['ngay']);
    personInChargeController.text = budget['thanhVienChiuTrachNhiem'];

    // Parse the date string (assuming format DD/MM/YYYY)
    try {
      final dateParts = budget['date'].split('/');
      _selectedDate = DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
      );
    } catch (e) {
      _selectedDate = null;
      print("Error parsing date: $e");
    }

    setState(() {
      _editingBudget = Map<String, dynamic>.from(budget);
      _selectedIndex = 3; // Use index 3 for edit
      _currentTitle = _titles[3];
    });
    print("Navigated to edit for: ${budget['eventName']}");
  }

  // Get filtered budgets based on search query
  List<Map<String, dynamic>> get _filteredBudgets {
    return _budgets.where((budget) {
      bool matchesSearch =
          _searchQuery.isEmpty ||
          budget['ten'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          budget['thanhVienChiuTrachNhiem'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          budget['ngay'].toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesPersonInCharge =
          _filterPersonInCharge == null ||
          _filterPersonInCharge == 'Tất cả' ||
          budget['thanhVienChiuTrachNhiem'] == _filterPersonInCharge;

      bool matchesYear =
          _filterYear == null ||
          _filterYear == 'Tất cả' ||
          budget['ngay'].split('-').first == _filterYear;

      return matchesSearch && matchesPersonInCharge && matchesYear;
    }).toList();
  }

  // Build dropdown field for search and filter
  // Widget _buildDropdownField(String label, List<String> items) {
  //   return DropdownButtonFormField<String>(
  //     decoration: InputDecoration(
  //       labelText: label,
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
  //       ),
  //     ),
  //     items:
  //         items
  //             .map((item) => DropdownMenuItem(value: item, child: Text(item)))
  //             .toList(),
  //     onChanged: (value) {},
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StudentAppBarWidget(title: _currentTitle),
      drawer: StudentDrawerWidget(
        currentPage: 'budget_management',
        userName: widget.userName!,
        userRole: widget.userRole!,
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex > 2 ? 0 : _selectedIndex, // Hide edit tab
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
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Danh sách',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Thêm ngân sách',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildBudgetList();
      case 1:
        return _buildAddBudget();
      case 2:
        return _buildSearchBudget();
      case 3:
        return _buildEditBudget();
      default:
        return _buildBudgetList();
    }
  }

  Widget _buildBudgetList() {
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
                  Icons.account_balance_wallet,
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
                      'Quản lý ngân sách',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppConstants.primaryColor,
                      ),
                    ),
              Text(
                'Tổng số: ${_budgets.length} ngân sách',
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
                  '${_budgets.length}',
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
          child: _budgets.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Chưa có ngân sách nào',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hãy thêm ngân sách đầu tiên của bạn',
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
            itemCount: _budgets.length,
            itemBuilder: (context, index) {
              final budget = _budgets[index];
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
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppConstants.primaryColor,
                                          AppConstants.primaryColor.withOpacity(0.7),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                            child: Text(
                                        budget['ten'][0].toUpperCase(),
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
                              budget['ten'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Phụ trách: ${budget['thanhVienChiuTrachNhiem']}',
                                          style: TextStyle(
                                            fontSize: 14,
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
                                onPressed: () => _showBudgetDetails(context, budget),
                                tooltip: 'Xem chi tiết',
                                      ),
                                      const SizedBox(width: 8),
                                      _buildActionButton(
                                        icon: Icons.edit,
                                  color: Colors.green,
                                onPressed: () => _navigateToEditBudget(context, budget),
                                tooltip: 'Chỉnh sửa',
                                      ),
                                      const SizedBox(width: 8),
                                      _buildActionButton(
                                        icon: Icons.delete,
                                  color: Colors.red,
                                onPressed: () => _showDeleteConfirmation(context, budget),
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
                                      child: _buildBudgetStat(
                                        'Ngân sách',
                                        _formatCurrency(budget['nguonThu']),
                            Icons.account_balance_wallet,
                                        Colors.green,
                                      ),
                                    ),
                                    Container(
                                      width: 1,
                                      height: 40,
                                      color: Colors.grey[300],
                                    ),
                                    Expanded(
                                      child: _buildBudgetStat(
                                        'Chi tiêu',
                                        _formatCurrency(budget['khoanChiTieu']),
                            Icons.money_off,
                                        Colors.orange,
                                      ),
                          ),
                        ],
                      ),
                              ),
                              const SizedBox(height: AppConstants.paddingMedium),
                      Row(
                        children: [
                                  Icon(
                            Icons.calendar_today,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                            'Ngày: ${_formatDate(budget['ngay'])}',
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
                ),
              );
            },
          ),
        ),
      ],
    );
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

  Widget _buildBudgetStat(String label, String value, IconData icon, Color color) {
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

  Widget _buildAddBudget() {
    if (_selectedIndex == 1) {
      _resetForm();
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thêm ngân sách mới',
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
                      controller: eventNameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên sự kiện',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.event),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên sự kiện';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    TextFormField(
                      controller: budgetController,
                      decoration: const InputDecoration(
                        labelText: 'Ngân sách',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.account_balance_wallet),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập ngân sách';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    TextFormField(
                      controller: expenditureController,
                      decoration: const InputDecoration(
                        labelText: 'Chi tiêu',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.money_off),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập chi tiêu';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    TextFormField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        labelText: 'Ngày',
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
                      controller: personInChargeController,
                      decoration: const InputDecoration(
                        labelText: 'Thành viên phụ trách',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập thành viên phụ trách';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _saveBudget,
                        icon: const Icon(Icons.save),
                        label: const Text('Thêm ngân sách'),
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
                            _selectedIndex = 0;
                            _currentTitle = _titles[0];
                          });
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text('Hủy'),
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

  // Update _buildEditBudget to use DatePicker
  Widget _buildEditBudget() {
    if (_editingBudget == null) {
      return const Center(
        child: Text(
          'Không có ngân sách được chọn để chỉnh sửa',
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
            'Chỉnh sửa ngân sách',
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
                      controller: eventNameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên sự kiện',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.event),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên sự kiện';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    TextFormField(
                      controller: budgetController,
                      decoration: const InputDecoration(
                        labelText: 'Ngân sách',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.account_balance_wallet),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập ngân sách';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    TextFormField(
                      controller: expenditureController,
                      decoration: const InputDecoration(
                        labelText: 'Chi tiêu',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.money_off),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập chi tiêu';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    TextFormField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        labelText: 'Ngày',
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
                      controller: personInChargeController,
                      decoration: const InputDecoration(
                        labelText: 'Thành viên phụ trách',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập thành viên phụ trách';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _updateBudget,
                        icon: const Icon(Icons.save),
                        label: const Text('Cập nhật thông tin'),
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
                            _editingBudget = null;
                            _selectedIndex = 0;
                            _currentTitle = _titles[0];
                          });
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text('Hủy'),
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

  Widget _buildSearchBudget() {
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
                'Tìm kiếm & Lọc ngân sách',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tìm kiếm và lọc ngân sách theo tiêu chí',
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
                    hintText: 'Tìm kiếm theo tên sự kiện, phụ trách, ngày...',
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
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
                        value: _filterPersonInCharge,
                        decoration: InputDecoration(
                          labelText: 'Thành viên phụ trách',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium,
                            ),
                          ),
                        ),
                        items:
                            <String>[
                                  "Tất cả",
                                  ..._budgets
                                      .map(
                                        (b) => b['personInCharge'].toString(),
                                      )
                                      .toSet()
                                      .toList(),
                                ]
                                .map(
                                  (String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _filterPersonInCharge = value;
                          });
                        },
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      DropdownButtonFormField<String>(
                        value: _filterYear,
                        decoration: InputDecoration(
                          labelText: 'Năm',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium,
                            ),
                          ),
                        ),
                        items:
                            ['Tất cả', '2022', '2023', '2024', '2025']
                                .map(
                                  (item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _filterYear = value;
                          });
                        },
                      ),
                      const SizedBox(height: AppConstants.paddingLarge),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _searchController.clear();
                                  _filterPersonInCharge = null;
                                  _filterYear = null;
                                });
                              },
                              child: const Text('Xóa bộ lọc'),
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingMedium),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(
                                  () {},
                                ); // Trigger rebuild to apply filters
                              },
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
                              'Kết quả tìm kiếm: ${_filteredBudgets.length} ngân sách',
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
                        child:
                            _filteredBudgets.isEmpty
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
                                    'Không tìm thấy ngân sách',
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
                                  itemCount: _filteredBudgets.length,
                                  itemBuilder: (context, index) {
                                    final budget = _filteredBudgets[index];
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
                                                          AppConstants.primaryColor,
                                                          AppConstants.primaryColor.withOpacity(0.7),
                                                        ],
                                                      ),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Center(
                                        child: Text(
                                          budget['ten'][0].toUpperCase(),
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
                                                          budget['ten'] ?? '',
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Text(
                                                          'Phụ trách: ${budget['thanhVienChiuTrachNhiem'] ?? '-'}',
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
                                                        onPressed: () => _showBudgetDetails(context, budget),
                                                        tooltip: 'Xem chi tiết',
                                                      ),
                                                      const SizedBox(width: 6),
                                                      _buildActionButton(
                                                        icon: Icons.edit,
                                                        color: Colors.green,
                                                        onPressed: () => _navigateToEditBudget(context, budget),
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
                                                          Icon(Icons.account_balance_wallet, size: 16, color: Colors.green),
                                                          const SizedBox(width: 4),
                                                          Flexible(
                                                            child: Text(
                                                              _formatCurrency(budget['nguonThu']),
                                                              style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.green,
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
                                                          Icon(Icons.money_off, size: 16, color: Colors.orange),
                                                          const SizedBox(width: 4),
                                                          Flexible(
                                        child: Text(
                                                              _formatCurrency(budget['khoanChiTieu']),
                                          style: const TextStyle(
                                            fontSize: 12,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.orange,
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
                                                          Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                                                          const SizedBox(width: 4),
                                                          Flexible(
                                                            child: Text(
                                                              _formatDate(budget['ngay']),
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
}
