import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/manager/manager_drawer_widget.dart';
import '../../widgets/manager/manager_app_bar_widget.dart';
import '../../models/budget_allocation.dart';
import '../../services/budget_allocation_data_service.dart';

class ManagerBudgetAllocationScreen extends StatefulWidget {
  const ManagerBudgetAllocationScreen({super.key});

  @override
  State<ManagerBudgetAllocationScreen> createState() =>
      _ManagerBudgetAllocationScreenState();
}

class _ManagerBudgetAllocationScreenState
    extends State<ManagerBudgetAllocationScreen> {
  int _selectedIndex = 0;
  String _currentTitle = 'Phân bổ ngân sách';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _titles = [
    'Phân bổ ngân sách',
    'Thêm phân bổ',
    'Tìm kiếm & Lọc',
  ];

  final BudgetAllocationDataService _allocationService = BudgetAllocationDataService();
  List<BudgetAllocation> _allocations = [];
  List<BudgetAllocation> _filteredAllocations = [];

  final _formKey = GlobalKey<FormState>();
  final _clubController = TextEditingController();
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllocations();
  }

  void _loadAllocations() {
    setState(() {
      _allocations = _allocationService.getAllAllocations();
      _filteredAllocations = _allocations;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _clubController.dispose();
    _amountController.dispose();
    _purposeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatCurrency(int amount) {
    return '${(amount / 1000000).toStringAsFixed(1)}M VNĐ';
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _updateFilteredAllocations() {
    setState(() {
      _filteredAllocations = _allocationService.searchAllocations(_searchQuery);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _saveAllocation() {
    if (_formKey.currentState!.validate()) {
      final newAllocation = BudgetAllocation(
        id: _allocationService.getNextId(),
        club: '67160c5ad55fc5f816de7644',
        clubName: _clubController.text,
        amount: int.parse(_amountController.text.replaceAll(',', '')),
        purpose: _purposeController.text,
        allocationDate: _dateController.text.split('/').reversed.join('-'),
      );

      _allocationService.addAllocation(newAllocation);
      _loadAllocations();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã thêm phân bổ ngân sách mới'),
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

  void _resetForm() {
    _clubController.clear();
    _amountController.clear();
    _purposeController.clear();
    _dateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ManagerAppBarWidget(title: _currentTitle),
      drawer: const ManagerDrawerWidget(
        currentPage: 'budget_allocation',
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
          BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: 'Danh sách'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Thêm'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildAllocationList();
      case 1:
        return _buildAddAllocation();
      case 2:
        return _buildSearchAndFilter();
      default:
        return _buildAllocationList();
    }
  }

  Widget _buildAllocationList() {
    final totalAmount = _allocationService.getTotalAllocatedAmount();
    
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
                  Icons.account_balance,
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
                      'Phân bổ ngân sách',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    Text(
                      'Tổng số: ${_allocations.length} phân bổ • ${_formatCurrency(totalAmount)}',
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
                  '${_allocations.length}',
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
          child: _allocations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Chưa có phân bổ nào',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hãy thêm phân bổ ngân sách đầu tiên',
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
                  itemCount: _allocations.length,
                  itemBuilder: (context, index) {
                    final allocation = _allocations[index];
                    
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
                              Colors.blue.withOpacity(0.02),
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
                                          Colors.blue,
                                          Colors.blue.withOpacity(0.7),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.account_balance,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppConstants.paddingMedium),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          allocation.clubName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'ID: ${allocation.id} • ${_formatDate(allocation.allocationDate)}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12, 
                                      vertical: 6
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.green.withOpacity(0.3)
                                      ),
                                    ),
                                    child: Text(
                                      _formatCurrency(allocation.amount),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.description,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Mục đích:',
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
                                      allocation.purpose,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppConstants.paddingMedium),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () => _showAllocationDetails(context, allocation),
                                    icon: const Icon(Icons.visibility, size: 16),
                                    label: const Text('Xem chi tiết'),
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
                                    onPressed: () => _showDeleteConfirmation(context, allocation),
                                    icon: const Icon(Icons.delete, size: 16),
                                    label: const Text('Xóa'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.red,
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
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAddAllocation() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thêm phân bổ ngân sách',
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
                      controller: _clubController,
                      decoration: const InputDecoration(
                        labelText: 'Tên câu lạc bộ',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.group),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên câu lạc bộ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Số tiền (VNĐ)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập số tiền';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    TextFormField(
                      controller: _purposeController,
                      decoration: const InputDecoration(
                        labelText: 'Mục đích',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mục đích';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: 'Ngày phân bổ',
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
                    const SizedBox(height: AppConstants.paddingLarge),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _saveAllocation,
                        icon: const Icon(Icons.save),
                        label: const Text('Thêm phân bổ'),
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
                        'Tìm kiếm phân bổ',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeXLarge,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tìm kiếm theo câu lạc bộ hoặc mục đích',
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
                hintText: 'Tìm kiếm theo tên câu lạc bộ, mục đích...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: AppConstants.primaryColor),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                            _updateFilteredAllocations();
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
                  _updateFilteredAllocations();
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
                    'Kết quả tìm kiếm: ${_filteredAllocations.length} phân bổ',
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
            child: _filteredAllocations.isEmpty && _searchQuery.isNotEmpty
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
                          'Không tìm thấy phân bổ',
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
                    itemCount: _searchQuery.isEmpty ? 0 : _filteredAllocations.length,
                    itemBuilder: (context, index) {
                      final allocation = _filteredAllocations[index];
                      
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
                                colors: [Colors.blue, Colors.blue.withOpacity(0.7)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.account_balance,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          title: Text(
                            allocation.clubName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            '${_formatDate(allocation.allocationDate)} • ${_formatCurrency(allocation.amount)}',
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
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _formatCurrency(allocation.amount),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios, 
                                   size: 16, color: Colors.grey[400]),
                            ],
                          ),
                          onTap: () => _showAllocationDetails(context, allocation),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAllocationDetails(BuildContext context, BudgetAllocation allocation) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                  color: Colors.green.withAlpha((0.1 * 255).round()),
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
                        color: Colors.green.withAlpha(51),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.account_balance,
                          color: Colors.green,
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
                            allocation.clubName,
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
                              color: Colors.green.withAlpha(51),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _formatCurrency(allocation.amount),
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeSmall,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
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
                      Row(
                        children: [
                          Expanded(
                            child: _buildAllocationDetailRow(
                              Icons.tag, 
                              'ID phân bổ', 
                              allocation.id.toString()
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingSmall),
                          Expanded(
                            child: _buildAllocationDetailRow(
                              Icons.calendar_today, 
                              'Ngày phân bổ', 
                              _formatDate(allocation.allocationDate)
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      Row(
                        children: [
                          Expanded(
                            child: _buildAllocationDetailRow(
                              Icons.group, 
                              'Club ID', 
                              allocation.club.substring(0, 8) + '...'
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingSmall),
                          Expanded(
                            child: _buildAllocationDetailRow(
                              Icons.attach_money, 
                              'Số tiền', 
                              _formatCurrency(allocation.amount)
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppConstants.paddingMedium),
                      const Text(
                        'Mục đích phân bổ',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeLarge,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppConstants.paddingMedium),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Text(
                          allocation.purpose,
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeMedium,
                            height: 1.5,
                          ),
                        ),
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
                child: Row(
                  children: [
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
      ),
    );
  }

  Widget _buildAllocationDetailRow(IconData icon, String label, String value) {
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
        children: [
          Icon(
            icon,
            color: AppConstants.primaryColor,
            size: 20,
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
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, BudgetAllocation allocation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc chắn muốn xóa phân bổ cho "${allocation.clubName}" không?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                _allocationService.deleteAllocation(allocation.id);
                _loadAllocations();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa phân bổ ngân sách'),
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
} 