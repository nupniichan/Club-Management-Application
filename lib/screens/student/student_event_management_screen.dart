import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/student/student_drawer_widget.dart';

class StudentEventManagementScreen extends StatefulWidget {
  final String? userName;
  final String? userRole;

  const StudentEventManagementScreen({
    super.key,
    this.userName = 'Sinh viên',
    this.userRole = 'Thành viên câu lạc bộ',
  });

  @override
  State<StudentEventManagementScreen> createState() =>
      _StudentEventManagementScreenState();
}

class _StudentEventManagementScreenState
    extends State<StudentEventManagementScreen> {
  int _selectedIndex = 0;
  String _currentTitle = 'Quản lý sự kiện & lịch trình';

  final List<String> _titles = [
    'Quản lý sự kiện',
    'Thêm sự kiện',
    'Tìm kiếm & Lọc',
    'Chỉnh sửa sự kiện',
  ];

  // Form controllers and variables
  final _formKey = GlobalKey<FormState>();
  final eventNameController = TextEditingController();
  final dateController = TextEditingController();
  final trainerController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Variable to store the event being edited
  Map<String, dynamic>? _editingEvent;

  // Mock data for events with varied statuses
  final List<Map<String, dynamic>> _events = [
    {
      'eventName': 'CodeFest',
      'date': '10/10/2024',
      'trainer': 'Nguyễn Văn A',
      'status': 'Đã duyệt',
    },
    {
      'eventName': 'Hackathon X',
      'date': '13/07/2024',
      'trainer': 'Nguyễn Văn A',
      'status': 'Đang chờ',
    },
    {
      'eventName': 'Tech Talk Series',
      'date': '05/05/2024',
      'trainer': 'Lê Thị C',
      'status': 'Hoàn thành',
    },
    {
      'eventName': 'WebDev Bootcamp',
      'date': '20/12/2023',
      'trainer': 'Nguyễn Văn A',
      'status': 'Đã hủy',
    },
    {
      'eventName': 'AI & Machine Learning Workshop',
      'date': '12/11/2023',
      'trainer': 'Trần Văn C',
      'status': 'Đang diễn ra',
    },
    {
      'eventName': 'Game Dev Jam',
      'date': '02/08/2023',
      'trainer': 'Nguyễn Văn A',
      'status': 'Đã duyệt',
    },
    {
      'eventName': 'Cloud Computing 101',
      'date': '19/06/2023',
      'trainer': 'Trần Văn C',
      'status': 'Đang chờ',
    },
    {
      'eventName': 'Data Science Marathon',
      'date': '03/02/2023',
      'trainer': 'Nguyễn Văn A',
      'status': 'Hoàn thành',
    },
    {
      'eventName': 'IT DAY',
      'date': '12/10/2022',
      'trainer': 'Lê Thị C',
      'status': 'Đã hủy',
    },
    {
      'eventName': 'CODE COMPETITIVE',
      'date': '06/07/2022',
      'trainer': 'Lê Thị C',
      'status': 'Đang diễn ra',
    },
  ];

  @override
  void dispose() {
    eventNameController.dispose();
    dateController.dispose();
    trainerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Reset form to default state
  void _resetForm() {
    eventNameController.clear();
    dateController.clear();
    trainerController.clear();
    setState(() {});
  }

  // Show date picker
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

  // Save a new event
  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      final newEvent = {
        'eventName': eventNameController.text,
        'date': dateController.text,
        'trainer': trainerController.text,
        'status': 'Đã duyệt', // Default status for new events
      };

      setState(() {
        _events.add(newEvent);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã thêm sự kiện mới'),
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

  // Update an existing event
  void _updateEvent() {
    if (_formKey.currentState!.validate() && _editingEvent != null) {
      final updatedEvent = {
        'eventName': eventNameController.text,
        'date': dateController.text,
        'trainer': trainerController.text,
        'status': _editingEvent!['status'],
      };

      setState(() {
        final index = _events.indexWhere(
          (e) => e['eventName'] == _editingEvent!['eventName'],
        );
        if (index != -1) {
          _events[index] = updatedEvent;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã cập nhật thông tin sự kiện'),
          backgroundColor: Colors.green,
        ),
      );

      _resetForm();
      setState(() {
        _editingEvent = null;
        _selectedIndex = 0;
        _currentTitle = _titles[0];
      });
    }
  }

  // Navigate to edit event
  void _navigateToEditEvent(BuildContext context, Map<String, dynamic> event) {
    eventNameController.text = event['eventName'];
    dateController.text = event['date'];
    trainerController.text = event['trainer'];

    setState(() {
      _editingEvent = Map<String, dynamic>.from(event);
      _selectedIndex = 3;
      _currentTitle = _titles[3];
    });
  }

  // Show event details in a dialog
  void _showEventDetails(BuildContext context, Map<String, dynamic> event) {
    final Color statusColor = _getStatusColor(event['status']);

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
                    color: AppConstants.primaryColor.withAlpha((0.05 * 255).round()),
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
                            event['eventName'][0].toUpperCase(),
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
                          event['eventName'],
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
                      _buildDetailItem(Icons.calendar_today, 'Ngày', event['date']),
                      const Divider(),
                      _buildDetailItem(Icons.person, 'Giảng viên', event['trainer']),
                      const Divider(),
                      _buildDetailItem(
                        Icons.check_circle,
                        'Trạng thái',
                        event['status'],
                        textColor: statusColor,
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
                    border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _navigateToEditEvent(context, event),
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

  // Build detail item for dialog
  Widget _buildDetailItem(IconData icon, String label, String value,
      {Color? iconColor, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (iconColor ?? AppConstants.primaryColor)
                  .withAlpha((0.1 * 255).round()),
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadiusMedium),
            ),
            child: Icon(icon,
                color: iconColor ?? AppConstants.primaryColor, size: 20),
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

  // Show delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context, Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc chắn muốn xóa sự kiện "${event['eventName']}" không?',
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
                  _events.removeWhere((e) => e['eventName'] == event['eventName']);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa sự kiện'),
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

  List<Map<String, dynamic>> get _filteredEvents {
    return _events.where((event) {
      return _searchQuery.isEmpty ||
          event['eventName'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event['date'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event['trainer'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event['status'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // Get color based on status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Đã duyệt':
        return Colors.green;
      case 'Đang chờ':
        return Colors.blue;
      case 'Hoàn thành':
        return Colors.orange;
      case 'Đã hủy':
        return Colors.red;
      case 'Đang diễn ra':
        return Colors.purple;
      default:
        return AppConstants.primaryColor;
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
        currentPage: 'event_management',
        userName: widget.userName!,
        userRole: widget.userRole!,
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex > 2 ? 0 : _selectedIndex,
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
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Danh sách'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Thêm sự kiện',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildEventList();
      case 1:
        return _buildAddEvent();
      case 2:
        return _buildSearchAndFilter();
      case 3:
        return _buildEditEvent();
      default:
        return _buildEventList();
    }
  }

  Widget _buildEventList() {
    return Column(
      children: [
        Container(
          color: AppConstants.primaryColor.withAlpha(40),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingSmall,
          ),
          child: Row(
            children: [
              const Icon(Icons.event, size: 16, color: Colors.grey),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                'Tổng số: ${_filteredEvents.length} sự kiện',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredEvents.isEmpty
              ? const Center(
                  child: Text(
                    'Không tìm thấy sự kiện',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = _filteredEvents[index];
                    final Color statusColor = _getStatusColor(event['status']);
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
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    event['eventName'],
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
                                      onPressed: () => _showEventDetails(context, event),
                                      tooltip: 'Xem chi tiết',
                                      iconSize: 22,
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.green,
                                      ),
                                      onPressed: () => _navigateToEditEvent(context, event),
                                      tooltip: 'Chỉnh sửa',
                                      iconSize: 22,
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _showDeleteConfirmation(context, event),
                                      tooltip: 'Xóa',
                                      iconSize: 22,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: AppConstants.paddingMedium),
                            Row(
                              children: [
                                _buildInfoChip(
                                  Icons.calendar_today,
                                  'Ngày: ${event['date']}',
                                ),
                                const SizedBox(width: AppConstants.paddingSmall),
                                _buildInfoChip(
                                  Icons.person,
                                  'Giảng viên: ${event['trainer']}',
                                ),
                              ],
                            ),
                            const SizedBox(height: AppConstants.paddingSmall),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingSmall,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withAlpha(51),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Trạng thái: ${event['status']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
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

  Widget _buildAddEvent() {
    if (_selectedIndex == 1) {
      _resetForm();
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thêm sự kiện mới',
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
                      controller: trainerController,
                      decoration: const InputDecoration(
                        labelText: 'Giảng viên',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập giảng viên';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _saveEvent,
                        icon: const Icon(Icons.save),
                        label: const Text('Thêm sự kiện'),
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

  Widget _buildEditEvent() {
    if (_editingEvent == null) {
      return const Center(
        child: Text(
          'Không có sự kiện được chọn để chỉnh sửa',
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
            'Chỉnh sửa sự kiện',
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
                      controller: trainerController,
                      decoration: const InputDecoration(
                        labelText: 'Giảng viên',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập giảng viên';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _updateEvent,
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
                            _editingEvent = null;
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
                'Tìm kiếm & Lọc sự kiện',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm sự kiện...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
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
                      _buildDropdownField('Giảng viên', [
                        'Tất cả',
                        ..._events.map((e) => e['trainer']).toSet().toList(),
                      ]),
                      const SizedBox(height: AppConstants.paddingMedium),
                      _buildDropdownField('Năm', [
                        'Tất cả',
                        '2022',
                        '2023',
                        '2024',
                        '2025',
                      ]),
                      const SizedBox(height: AppConstants.paddingMedium),
                      _buildDropdownField('Trạng thái', [
                        'Tất cả',
                        'Đã duyệt',
                        'Đang chờ',
        'Hoàn thành',
        'Đã hủy',
        'Đang diễn ra',
                      ]),
                      const SizedBox(height: AppConstants.paddingLarge),
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
                      SizedBox(
                        height: 300,
                        child: _filteredEvents.isEmpty
                            ? const Center(
                                child: Text(
                                  'Không tìm thấy sự kiện',
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: _filteredEvents.length,
                                itemBuilder: (context, index) {
                                  final event = _filteredEvents[index];
                                  final Color statusColor = _getStatusColor(event['status']);
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: AppConstants.primaryColor.withAlpha(51),
                                      child: Text(
                                        event['eventName'][0].toUpperCase(),
                                        style: TextStyle(
                                          color: AppConstants.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(event['eventName']),
                                    subtitle: Text('Ngày: ${event['date']} - ${event['trainer']}'),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withAlpha(51),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        event['status'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: statusColor,
                                        ),
                                      ),
                                    ),
                                    onTap: () => _showEventDetails(context, event),
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

  Widget _buildDropdownField(String label, List<String> items) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) {},
    );
  }

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