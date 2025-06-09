import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/student/student_drawer_widget.dart';
import '../../widgets/student/student_app_bar_widget.dart';
import '../../models/event.dart';
import '../../services/event_data_service.dart';

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

  final EventDataService _eventService = EventDataService();
  List<Event> _events = [];

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
  Event? _editingEvent;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    setState(() {
      _events = _eventService.getAllEvents();
    });
  }

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
      final newEvent = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        ten: eventNameController.text,
        ngayToChuc: _convertDateFormat(dateController.text),
        thoiGianBatDau: '08:00',
        thoiGianKetThuc: '17:00',
        diaDiem: 'Phòng học',
        noiDung: 'Sự kiện mới được tạo',
        nguoiPhuTrach: trainerController.text,
        khachMoi: [],
        club: '67160c5ad55fc5f816de7644',
        trangThai: 'choPheDuyet',
      );

      _eventService.addEvent(newEvent);
      _loadEvents();

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
      final updatedEvent = _editingEvent!.copyWith(
        ten: eventNameController.text,
        ngayToChuc: _convertDateFormat(dateController.text),
        nguoiPhuTrach: trainerController.text,
        thoiGianBatDau: startTimeController.text,
        thoiGianKetThuc: endTimeController.text,
        diaDiem: locationController.text,
        noiDung: contentController.text,
        khachMoi: guestController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      );

      _eventService.updateEvent(updatedEvent);
      _loadEvents();

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
  void _navigateToEditEvent(BuildContext context, Event event) {
    // Kiểm tra trạng thái sự kiện
    if (event.trangThai != 'choPheDuyet') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chỉ có thể chỉnh sửa sự kiện đang chờ phê duyệt'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    eventNameController.text = event.ten;
    dateController.text = _formatDate(event.ngayToChuc);
    trainerController.text = event.nguoiPhuTrach;
    startTimeController.text = event.thoiGianBatDau;
    endTimeController.text = event.thoiGianKetThuc;
    locationController.text = event.diaDiem;
    contentController.text = event.noiDung;
    guestController.text = event.khachMoi.join(', ');

    setState(() {
      _editingEvent = event;
      _selectedIndex = 3;
      _currentTitle = _titles[3];
    });
  }

  // Show event details in a dialog
  void _showEventDetails(BuildContext context, Event event) {
    final String statusText = _getStatusText(event.trangThai);
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
                            event.ten[0].toUpperCase(),
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
                          event.ten,
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
                                  child: _buildDetailCard(Icons.calendar_today, 'Ngày', _formatDate(event.ngayToChuc)),
                                ),
                                const SizedBox(width: AppConstants.paddingSmall),
                                Expanded(
                                  child: _buildDetailCard(Icons.schedule, 'Thời gian', '${event.thoiGianBatDau} - ${event.thoiGianKetThuc}'),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppConstants.paddingSmall),
                            _buildDetailCard(Icons.person, 'Người phụ trách', event.nguoiPhuTrach),
                            const SizedBox(height: AppConstants.paddingSmall),
                            _buildDetailCard(Icons.location_on, 'Địa điểm', event.diaDiem),
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
                        
                        if (event.noiDung.isNotEmpty) ...[
                          const SizedBox(height: AppConstants.paddingMedium),
                          _buildDetailCard(Icons.description, 'Nội dung', event.noiDung),
                        ],
                        
                        if (event.khachMoi.isNotEmpty) ...[
                          const SizedBox(height: AppConstants.paddingMedium),
                          _buildDetailCard(Icons.people, 'Khách mời', event.khachMoi.join(', ')),
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
  void _showDeleteConfirmation(BuildContext context, Event event) {
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
            'Bạn có chắc chắn muốn xóa sự kiện "${event.ten}" không?',
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
                _eventService.deleteEvent(event.id);
                _loadEvents();
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

  List<Event> get _filteredEvents {
    return _events.where((event) {
      return _searchQuery.isEmpty ||
          event.ten.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.ngayToChuc.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.nguoiPhuTrach.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.trangThai.toLowerCase().contains(_searchQuery.toLowerCase());
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
                  Icons.event,
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
                      'Quản lý sự kiện',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    Text(
                      'Tổng số: ${_events.length} sự kiện',
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
                  '${_events.length}',
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
          child: _events.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Chưa có sự kiện nào',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hãy thêm sự kiện đầu tiên của bạn',
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
                  itemCount: _events.length,
                  itemBuilder: (context, index) {
                    final event = _events[index];
                    final Color statusColor = _getStatusColor(_getStatusText(event.trangThai));
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
                                        event.ten[0].toUpperCase(),
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
                                          event.ten,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Phụ trách: ${event.nguoiPhuTrach}',
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
                                        onPressed: () => _showEventDetails(context, event),
                                        tooltip: 'Xem chi tiết',
                                      ),
                                      const SizedBox(width: 8),
                                      if (event.trangThai == 'choPheDuyet') ...[
                                        _buildActionButton(
                                          icon: Icons.edit,
                                          color: Colors.green,
                                          onPressed: () => _navigateToEditEvent(context, event),
                                          tooltip: 'Chỉnh sửa',
                                        ),
                                        const SizedBox(width: 8),
                                        _buildActionButton(
                                          icon: Icons.delete,
                                          color: Colors.red,
                                          onPressed: () => _showDeleteConfirmation(context, event),
                                          tooltip: 'Xóa',
                                        ),
                                      ],
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
                                      child: _buildEventStat(
                                        'Ngày',
                                        _formatDate(event.ngayToChuc),
                                        Icons.calendar_today,
                                        AppConstants.primaryColor,
                                      ),
                                    ),
                                    Container(
                                      width: 1,
                                      height: 40,
                                      color: Colors.grey[300],
                                    ),
                                    Expanded(
                                      child: _buildEventStat(
                                        'Trạng thái',
                                        _getStatusText(event.trangThai),
                                        Icons.circle,
                                        statusColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppConstants.paddingMedium),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_formatDate(event.ngayToChuc)} | ${event.thoiGianBatDau} - ${event.thoiGianKetThuc}',
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
                            'Tìm kiếm & Lọc sự kiện',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeXLarge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tìm kiếm và lọc sự kiện theo tiêu chí',
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
                      _buildDropdownField('Người phụ trách', [
                        'Tất cả',
                        ..._events.map((e) => e.nguoiPhuTrach).toSet().toList(),
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
                              'Kết quả tìm kiếm: ${_filteredEvents.length} sự kiện',
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
                        child: _filteredEvents.isEmpty
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
                                      'Không tìm thấy sự kiện',
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
                                itemCount: _filteredEvents.length,
                                itemBuilder: (context, index) {
                                  final event = _filteredEvents[index];
                                  final String statusText = _getStatusText(event.trangThai);
                                  final Color statusColor = _getStatusColor(statusText);
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
                                                      event.ten[0].toUpperCase(),
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
                                                        event.ten,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        'Phụ trách: ${event.nguoiPhuTrach}',
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
                                                      onPressed: () => _showEventDetails(context, event),
                                                      tooltip: 'Xem chi tiết',
                                                    ),
                                                    if (event.trangThai == 'choPheDuyet') ...[
                                                      const SizedBox(width: 6),
                                                      _buildActionButton(
                                                        icon: Icons.edit,
                                                        color: Colors.green,
                                                        onPressed: () => _navigateToEditEvent(context, event),
                                                        tooltip: 'Chỉnh sửa',
                                                      ),
                                                    ],
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
                                                        Icon(Icons.calendar_today, size: 16, color: AppConstants.primaryColor),
                                                        const SizedBox(width: 4),
                                                        Flexible(
                                                          child: Text(
                                                            _formatDate(event.ngayToChuc),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                              color: AppConstants.primaryColor,
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
                                                        Icon(Icons.circle, size: 16, color: statusColor),
                                                        const SizedBox(width: 4),
                                                        Flexible(
                                                          child: Text(
                                                            statusText,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                              color: statusColor,
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

  Widget _buildEventStat(String label, String value, IconData icon, Color color) {
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