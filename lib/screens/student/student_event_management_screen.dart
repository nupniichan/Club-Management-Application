import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/student/student_drawer_widget.dart';
import '../../widgets/student/student_app_bar_widget.dart';

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
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final locationController = TextEditingController();
  final contentController = TextEditingController();
  final guestController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Variable to store the event being edited
  Map<String, dynamic>? _editingEvent;

  // Updated mock data based on MongoDB structure
  final List<Map<String, dynamic>> _events = [
    {
      '_id': '673c5d577f6aae48b37a856b',
      'ten': 'IT Day',
      'ngayToChuc': '2024-11-22',
      'thoiGianBatDau': '12:00',
      'thoiGianKetThuc': '15:00',
      'diaDiem': 'Sân trường',
      'noiDung': 'Sự kiện IT Day được tổ chức nhằm giới thiệu cho mọi người về thế giới công nghệ thông tin',
      'nguoiPhuTrach': 'Nguyễn Phi Quốc Bảo',
      'khachMoi': ['Doanh nghiệp MemoryZone', 'Doanh nghiệp máy tính AnPhat'],
      'club': '67160c5ad55fc5f816de7644',
      'trangThai': 'daDuyet',
    },
    {
      '_id': '673c5d577f6aae48b37a856c',
      'ten': 'Hackathon X',
      'ngayToChuc': '2024-12-15',
      'thoiGianBatDau': '08:00',
      'thoiGianKetThuc': '18:00',
      'diaDiem': 'Phòng máy tính A101',
      'noiDung': 'Cuộc thi lập trình 24h dành cho sinh viên đam mê coding',
      'nguoiPhuTrach': 'Trần Văn B',
      'khachMoi': ['Công ty FPT Software', 'Công ty TMA Solutions'],
      'club': '67160c5ad55fc5f816de7644',
      'trangThai': 'choPheDuyet',
    },
    {
      '_id': '673c5d577f6aae48b37a856d',
      'ten': 'Workshop AI',
      'ngayToChuc': '2024-10-30',
      'thoiGianBatDau': '14:00',
      'thoiGianKetThuc': '17:00',
      'diaDiem': 'Hội trường lớn',
      'noiDung': 'Workshop về trí tuệ nhân tạo và machine learning cơ bản',
      'nguoiPhuTrach': 'Lê Thị C',
      'khachMoi': ['Tiến sĩ Nguyễn Văn A', 'Chuyên gia AI Google'],
      'club': '67160c5ad55fc5f816de7644',
      'trangThai': 'hoanThanh',
    },
  ];

  @override
  void dispose() {
    eventNameController.dispose();
    dateController.dispose();
    trainerController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    locationController.dispose();
    contentController.dispose();
    guestController.dispose();
    _searchController.dispose();
    super.dispose();
  }



  // Reset form to default state
  void _resetForm() {
    eventNameController.clear();
    dateController.clear();
    trainerController.clear();
    startTimeController.clear();
    endTimeController.clear();
    locationController.clear();
    contentController.clear();
    guestController.clear();
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

  // Show time picker for start time
  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        startTimeController.text = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  // Show time picker for end time
  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        endTimeController.text = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  // Save a new event
  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      final newEvent = {
        '_id': DateTime.now().millisecondsSinceEpoch.toString(),
        'ten': eventNameController.text,
        'ngayToChuc': _convertDateFormat(dateController.text),
        'thoiGianBatDau': '08:00',
        'thoiGianKetThuc': '17:00',
        'diaDiem': 'Phòng học',
        'noiDung': 'Sự kiện mới được tạo',
        'nguoiPhuTrach': trainerController.text,
        'khachMoi': [],
        'club': '67160c5ad55fc5f816de7644',
        'trangThai': 'choPheDuyet',
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

  String _convertDateFormat(String dateStr) {
    // Convert from DD/MM/YYYY to YYYY-MM-DD
    final parts = dateStr.split('/');
    if (parts.length == 3) {
      return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
    }
    return dateStr;
  }

  // Update an existing event
  void _updateEvent() {
    if (_formKey.currentState!.validate() && _editingEvent != null) {
      final updatedEvent = Map<String, dynamic>.from(_editingEvent!);
      updatedEvent['ten'] = eventNameController.text;
      updatedEvent['ngayToChuc'] = _convertDateFormat(dateController.text);
      updatedEvent['nguoiPhuTrach'] = trainerController.text;
      updatedEvent['thoiGianBatDau'] = startTimeController.text;
      updatedEvent['thoiGianKetThuc'] = endTimeController.text;
      updatedEvent['diaDiem'] = locationController.text;
      updatedEvent['noiDung'] = contentController.text;
      updatedEvent['khachMoi'] = guestController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      setState(() {
        final index = _events.indexWhere(
          (e) => e['_id'] == _editingEvent!['_id'],
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
    // Kiểm tra trạng thái sự kiện
    if (event['trangThai'] != 'choPheDuyet') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chỉ có thể chỉnh sửa sự kiện đang chờ phê duyệt'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    eventNameController.text = event['ten'];
    dateController.text = _formatDate(event['ngayToChuc']);
    trainerController.text = event['nguoiPhuTrach'];
    startTimeController.text = event['thoiGianBatDau'];
    endTimeController.text = event['thoiGianKetThuc'];
    locationController.text = event['diaDiem'];
    contentController.text = event['noiDung'];
    guestController.text = event['khachMoi'].join(', ');

    setState(() {
      _editingEvent = Map<String, dynamic>.from(event);
      _selectedIndex = 3;
      _currentTitle = _titles[3];
    });
  }

  // Show event details in a dialog
  void _showEventDetails(BuildContext context, Map<String, dynamic> event) {
    final String statusText = _getStatusText(event['trangThai']);
    final Color statusColor = _getStatusColor(statusText);

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
                    color: AppConstants.primaryColor.withAlpha((0.05 * 255).round()),
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
                            event['ten'][0].toUpperCase(),
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
                          event['ten'],
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
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDetailCard(Icons.calendar_today, 'Ngày', _formatDate(event['ngayToChuc'])),
                                ),
                                const SizedBox(width: AppConstants.paddingSmall),
                                Expanded(
                                  child: _buildDetailCard(Icons.schedule, 'Thời gian', '${event['thoiGianBatDau']} - ${event['thoiGianKetThuc']}'),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppConstants.paddingSmall),
                            _buildDetailCard(Icons.person, 'Người phụ trách', event['nguoiPhuTrach']),
                            const SizedBox(height: AppConstants.paddingSmall),
                            _buildDetailCard(Icons.location_on, 'Địa điểm', event['diaDiem']),
                          ],
                        ),
                        
                        const SizedBox(height: AppConstants.paddingMedium),
                        
                        // Status
                        _buildDetailCard(
                          Icons.check_circle,
                          'Trạng thái',
                          statusText,
                          textColor: statusColor,
                        ),
                        
                        if (event['noiDung'] != null && event['noiDung'].isNotEmpty) ...[
                          const SizedBox(height: AppConstants.paddingMedium),
                          _buildDetailCard(Icons.description, 'Nội dung', event['noiDung']),
                        ],
                        
                        if (event['khachMoi'] != null && event['khachMoi'].isNotEmpty) ...[
                          const SizedBox(height: AppConstants.paddingMedium),
                          _buildDetailCard(Icons.people, 'Khách mời', event['khachMoi'].join(', ')),
                        ],
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
                            _navigateToEditEvent(context, event);
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

  // Build detail card for dialog
  Widget _buildDetailCard(IconData icon, String label, String value,
      {Color? iconColor, Color? textColor}) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? AppConstants.primaryColor,
                size: 18,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppConstants.textSecondaryColor,
                    fontSize: AppConstants.fontSizeSmall,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            value,
            style: TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              fontWeight: FontWeight.w600,
              color: textColor ?? AppConstants.textPrimaryColor,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
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
          title: const Text(
            'Xác nhận xóa',
            style: TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Bạn có chắc chắn muốn xóa sự kiện "${event['ten']}" không?',
            style: const TextStyle(fontSize: AppConstants.fontSizeLarge),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Hủy',
                style: TextStyle(fontSize: AppConstants.fontSizeLarge),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() {
                  _events.removeWhere((e) => e['_id'] == event['_id']);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Đã xóa sự kiện',
                      style: TextStyle(fontSize: AppConstants.fontSizeLarge),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text(
                'Xóa',
                style: TextStyle(fontSize: AppConstants.fontSizeLarge),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> get _filteredEvents {
    return _events.where((event) {
      return _searchQuery.isEmpty ||
          event['ten'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event['ngayToChuc'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event['nguoiPhuTrach'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event['trangThai'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // Get color based on status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Đã duyệt':
        return Colors.green;
      case 'Chờ phê duyệt':
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

  String _getStatusText(String status) {
    switch (status) {
      case 'daDuyet':
        return 'Đã duyệt';
      case 'choPheDuyet':
        return 'Chờ phê duyệt';
      case 'hoanThanh':
        return 'Hoàn thành';
      case 'daHuy':
        return 'Đã hủy';
      case 'dangDienRa':
        return 'Đang diễn ra';
      default:
        return status;
    }
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StudentAppBarWidget(title: _currentTitle),
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppConstants.primaryColor.withOpacity(0.1),
                AppConstants.primaryColor.withOpacity(0.05),
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingMedium,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.event, 
                  size: 20, 
                  color: AppConstants.primaryColor
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Text(
                'Tổng số: ${_filteredEvents.length} sự kiện',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppConstants.fontSizeLarge,
                  color: AppConstants.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredEvents.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      const Text(
                        'Không tìm thấy sự kiện',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeXLarge,
                          color: AppConstants.textSecondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      const Text(
                        'Hãy thêm sự kiện mới hoặc thay đổi bộ lọc',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          color: AppConstants.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = _filteredEvents[index];
                    final Color statusColor = _getStatusColor(_getStatusText(event['trangThai']));
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingMedium,
                        vertical: AppConstants.paddingSmall / 2,
                      ),
                      elevation: 3,
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppConstants.paddingMedium),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    event['ten'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppConstants.fontSizeXLarge,
                                      color: AppConstants.textPrimaryColor,
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
                            Wrap(
                              spacing: AppConstants.paddingSmall,
                              runSpacing: AppConstants.paddingSmall,
                              children: [
                                _buildInfoChip(
                                  Icons.calendar_today,
                                  'Ngày: ${_formatDate(event['ngayToChuc'])}',
                                ),
                                _buildInfoChip(
                                  Icons.person,
                                  'Người phụ trách: ${event['nguoiPhuTrach']}',
                                ),
                              ],
                            ),
                            const SizedBox(height: AppConstants.paddingSmall),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingMedium,
                                vertical: AppConstants.paddingSmall,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                                border: Border.all(
                                  color: statusColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 8,
                                    color: statusColor,
                                  ),
                                  const SizedBox(width: AppConstants.paddingSmall),
                                  Text(
                                    _getStatusText(event['trangThai']),
                                    style: TextStyle(
                                      fontSize: AppConstants.fontSizeMedium,
                                      fontWeight: FontWeight.w600,
                                      color: statusColor,
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: startTimeController,
                            decoration: const InputDecoration(
                              labelText: 'Thời gian bắt đầu',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.access_time),
                            ),
                            readOnly: true,
                            onTap: () => _selectStartTime(context),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng chọn thời gian bắt đầu';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Expanded(
                          child: TextFormField(
                            controller: endTimeController,
                            decoration: const InputDecoration(
                              labelText: 'Thời gian kết thúc',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.access_time_filled),
                            ),
                            readOnly: true,
                            onTap: () => _selectEndTime(context),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng chọn thời gian kết thúc';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    TextFormField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: 'Địa điểm',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập địa điểm';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    TextFormField(
                      controller: trainerController,
                      decoration: const InputDecoration(
                        labelText: 'Người phụ trách',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập người phụ trách';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    TextFormField(
                      controller: contentController,
                      decoration: const InputDecoration(
                        labelText: 'Nội dung',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập nội dung sự kiện';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    TextFormField(
                      controller: guestController,
                      decoration: const InputDecoration(
                        labelText: 'Khách mời (phân cách bởi dấu phẩy)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.people),
                        hintText: 'Ví dụ: Doanh nghiệp A, Công ty B',
                      ),
                      maxLines: 2,
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
                fontSize: AppConstants.fontSizeXXLarge,
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimaryColor,
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
                      _buildDropdownField('Người phụ trách', [
                        'Tất cả',
                        ..._events.map((e) => e['nguoiPhuTrach']).toSet().toList(),
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
                                  final String statusText = _getStatusText(event['trangThai']);
                                  final Color statusColor = _getStatusColor(statusText);
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: AppConstants.primaryColor.withAlpha(51),
                                      child: Text(
                                        event['ten'][0].toUpperCase(),
                                        style: TextStyle(
                                          color: AppConstants.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      event['ten'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    subtitle: Text(
                                      'Ngày: ${_formatDate(event['ngayToChuc'])} - ${event['nguoiPhuTrach']}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
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
                                        statusText,
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon, 
            size: 16, 
            color: AppConstants.primaryColor
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: AppConstants.textPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}