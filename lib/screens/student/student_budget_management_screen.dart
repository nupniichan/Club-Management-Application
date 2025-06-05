import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/student/student_drawer_widget.dart';

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

  // Mock data for budgets (based on the image)
  final List<Map<String, dynamic>> _budgets = [
    {
      'eventName': 'CodeFest',
      'budget': '1,000,000 VND',
      'expenditure': '1,000,000 VND',
      'date': '10/10/2024',
      'personInCharge': 'Nguyễn Văn A',
    },
    {
      'eventName': 'Hackathon X',
      'budget': '1,000,000 VND',
      'expenditure': '1,000,000 VND',
      'date': '13/07/2024',
      'personInCharge': 'Nguyễn Văn B',
    },
    {
      'eventName': 'Tech Talk Series',
      'budget': '1,000,000 VND',
      'expenditure': '1,000,000 VND',
      'date': '05/05/2024',
      'personInCharge': 'Lê Thị T',
    },
    {
      'eventName': 'WebDev Bootcamp',
      'budget': '1,000,000 VND',
      'expenditure': '1,000,000 VND',
      'date': '20/12/2023',
      'personInCharge': 'Nguyễn Văn A',
    },
    {
      'eventName': 'AI & Machine Learning Workshop',
      'budget': '1,000,000 VND',
      'expenditure': '1,000,000 VND',
      'date': '12/11/2023',
      'personInCharge': 'Nguyễn Văn A',
    },
    {
      'eventName': 'Game Dev Jam',
      'budget': '1,000,000 VND',
      'expenditure': '1,000,000 VND',
      'date': '02/08/2023',
      'personInCharge': 'Lê Thị T',
    },
    {
      'eventName': 'Cloud Computing 101',
      'budget': '1,000,000 VND',
      'expenditure': '1,000,000 VND',
      'date': '19/06/2023',
      'personInCharge': 'Nguyễn Văn B',
    },
    {
      'eventName': 'Data Science Marathon',
      'budget': '1,000,000 VND',
      'expenditure': '1,000,000 VND',
      'date': '03/02/2023',
      'personInCharge': 'Nguyễn Văn B',
    },
    {
      'eventName': 'IT DAY',
      'budget': '1,000,000 VND',
      'expenditure': '1,000,000 VND',
      'date': '12/10/2022',
      'personInCharge': 'Triần Văn T',
    },
    {
      'eventName': 'CODE COMPETITIVE',
      'budget': '1,000,000 VND',
      'expenditure': '1,000,000 VND',
      'date': '06/07/2022',
      'personInCharge': 'Lê Thị T',
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
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppConstants.primaryColor.withAlpha(51),
                        ),
                        child: Center(
                          child: Text(
                            budget['eventName'][0].toUpperCase(),
                            style: const TextStyle(
                              color: AppConstants.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: Text(
                          budget['eventName'],
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeXLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    children: [
                      _buildDetailItem(
                        Icons.account_balance_wallet,
                        'Ngân sách',
                        budget['budget'],
                      ),
                      const Divider(),
                      _buildDetailItem(
                        Icons.money_off,
                        'Chi tiêu',
                        budget['expenditure'],
                      ),
                      const Divider(),
                      _buildDetailItem(
                        Icons.calendar_today,
                        'Ngày',
                        budget['date'],
                      ),
                      const Divider(),
                      _buildDetailItem(
                        Icons.person,
                        'Thành viên phụ trách',
                        budget['personInCharge'],
                      ),
                    ],
                  ),
                ),
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
                    mainAxisAlignment: MainAxisAlignment.end, // Align only "Đóng" to the right
                    children: [
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

  // Build detail item for dialog
  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
      child: Row(
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
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
            'Bạn có chắc chắn muốn xóa ngân sách cho sự kiện "${budget['eventName']}" không?',
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
                    (b) => b['eventName'] == budget['eventName'],
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
        'eventName': eventNameController.text,
        'budget': budgetController.text,
        'expenditure': expenditureController.text,
        'date': dateController.text,
        'personInCharge': personInChargeController.text,
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
      final updatedBudget = {
        'eventName': eventNameController.text,
        'budget': budgetController.text,
        'expenditure': expenditureController.text,
        'date': dateController.text,
        'personInCharge': personInChargeController.text,
      };

      setState(() {
        final index = _budgets.indexWhere(
          (b) => b['eventName'] == _editingBudget!['eventName'],
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
    eventNameController.text = budget['eventName'];
    budgetController.text = budget['budget'];
    expenditureController.text = budget['expenditure'];
    dateController.text = budget['date'];
    personInChargeController.text = budget['personInCharge'];

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
          budget['eventName'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          budget['personInCharge'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          budget['date'].toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesPersonInCharge =
          _filterPersonInCharge == null ||
          _filterPersonInCharge == 'Tất cả' ||
          budget['personInCharge'] == _filterPersonInCharge;

      bool matchesYear =
          _filterYear == null ||
          _filterYear == 'Tất cả' ||
          budget['date'].split('/').last == _filterYear;

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
        // Total budgets stat
        Container(
          color: AppConstants.primaryColor.withAlpha(40),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingSmall,
          ),
          child: Row(
            children: [
              const Icon(Icons.account_balance_wallet, size: 16, color: Colors.grey),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                'Tổng số: ${_budgets.length} ngân sách',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        // Budget list
        Expanded(
          child: _budgets.isEmpty
              ? const Center(
            child: Text(
              'Không tìm thấy ngân sách',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
              : ListView.builder(
            itemCount: _budgets.length,
            itemBuilder: (context, index) {
              final budget = _budgets[index];
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
                      // Event name and actions
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              budget['eventName'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                ),
                                onPressed: () => _showBudgetDetails(context, budget),
                                tooltip: 'Xem chi tiết',
                                iconSize: 22,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                                onPressed: () => _navigateToEditBudget(context, budget),
                                tooltip: 'Chỉnh sửa',
                                iconSize: 22,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _showDeleteConfirmation(context, budget),
                                tooltip: 'Xóa',
                                iconSize: 22,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      // Budget details
                      Row(
                        children: [
                          _buildInfoChip(
                            Icons.account_balance_wallet,
                            'Ngân sách: ${budget['budget']}',
                          ),
                          const SizedBox(width: AppConstants.paddingSmall),
                          _buildInfoChip(
                            Icons.money_off,
                            'Chi tiêu: ${budget['expenditure']}',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      Row(
                        children: [
                          _buildInfoChip(
                            Icons.calendar_today,
                            'Ngày: ${budget['date']}',
                          ),
                          const SizedBox(width: AppConstants.paddingSmall),
                          _buildInfoChip(
                            Icons.person,
                            'Phụ trách: ${budget['personInCharge']}',
                          ),
                        ],
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
              const Text(
                'Tìm kiếm & Lọc ngân sách',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm ngân sách...',
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
                      SizedBox(
                        height: 300,
                        child:
                            _filteredBudgets.isEmpty
                                ? const Center(
                                  child: Text(
                                    'Không tìm thấy ngân sách',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                                : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _filteredBudgets.length,
                                  itemBuilder: (context, index) {
                                    final budget = _filteredBudgets[index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: AppConstants
                                            .primaryColor
                                            .withAlpha(51),
                                        child: Text(
                                          budget['eventName'][0].toUpperCase(),
                                          style: TextStyle(
                                            color: AppConstants.primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      title: Text(budget['eventName'] ?? ''),
                                      subtitle: Text(
                                        'Ngày: ${budget['date'] ?? '-'} - Phụ trách: ${budget['personInCharge'] ?? '-'}',
                                      ),
                                      trailing: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withAlpha(51),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Text(
                                          '${budget['budget']}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      onTap:
                                          () => _showBudgetDetails(
                                            context,
                                            budget,
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

  // Build info chip for displaying budget details
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
}
