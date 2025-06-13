import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
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
  
  // API Configuration
  static const String apiUrl = 'https://club-management-application.onrender.com/api';
  
  // State variables
  List<dynamic> _events = [];
  List<dynamic> _allEvents = [];
  List<dynamic> _clubs = [];
  List<dynamic> _students = [];
  List<dynamic> _filteredStudents = [];
  Map<String, dynamic>? _managedClub;
  bool _isLoading = true;
  bool _isDialogOpen = false;
  bool _isDetailDialogOpen = false;
  bool _showStudentDropdown = false;
  String? _editingEventId;
  Map<String, dynamic>? _detailEvent;
  
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _locationController = TextEditingController();
  final _contentController = TextEditingController();
  final _responsiblePersonController = TextEditingController();
  final _guestController = TextEditingController();
  final _searchController = TextEditingController();
  
  // State for guests
  List<String> _guests = [];
  
  // Filter states
  String _statusFilter = 'all';
  String _searchTerm = '';
  Map<String, String> _dateFilter = {'from': '', 'to': ''};
  
  // Pagination
  int _currentPage = 1;
  static const int _itemsPerPage = 10;
  
  // Form validation errors
  Map<String, String> _errors = {};
  
  // Tab state
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  
  // Calendar variables
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _locationController.dispose();
    _contentController.dispose();
    _responsiblePersonController.dispose();
    _guestController.dispose();
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    try {
      setState(() => _isLoading = true);

      final prefs = await SharedPreferences.getInstance();
      final managedClubsString = prefs.getString('managedClubs');
      
      if (managedClubsString != null) {
        final managedClubs = jsonDecode(managedClubsString) as List;
        if (managedClubs.isNotEmpty) {
          _managedClub = managedClubs[0];
          await Future.wait([
            _fetchEvents(_managedClub!['_id']),
            _fetchAllEvents(),
            _fetchMembersByClub(_managedClub!['_id']),
          ]);
        }
      }
      
      await _fetchClubs();
      
    } catch (error) {
      _showError('Lỗi khi tải dữ liệu: $error');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchEvents(String clubId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/get-events-by-club/$clubId'));
      if (response.statusCode == 200) {
        setState(() => _events = jsonDecode(response.body));
      }
    } catch (error) {
      _showError('Lỗi khi tải sự kiện: $error');
    }
  }

  Future<void> _fetchAllEvents() async {
    try {
      print('🔄 Fetching all events from API...');
      final response = await http.get(Uri.parse('$apiUrl/get-events'));
      print('📡 API Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('📊 Received ${data.length} events from API');
        if (data.isNotEmpty) {
          print('📋 Sample event: ${data.first}');
        }
        setState(() => _allEvents = data);
      } else {
        print('❌ API returned error: ${response.statusCode}');
        print('📝 Response body: ${response.body}');
      }
    } catch (error) {
      print('❌ Error fetching all events: $error');
    }
  }

  Future<void> _fetchClubs() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/get-clubs'));
      if (response.statusCode == 200) {
        setState(() => _clubs = jsonDecode(response.body));
      }
    } catch (error) {
      print('Error fetching clubs: $error');
    }
  }

    Future<void> _fetchMembersByClub(String clubId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/get-members-by-club/$clubId'));
      if (response.statusCode == 200) {
        final members = jsonDecode(response.body) as List;
        setState(() {
          _students = members.map((member) => {
            '_id': member['_id'],
            'hoTen': member['hoTen'],
            'mssv': member['maSoHocSinh'],
    }).toList();
          _filteredStudents = List.from(_students);
        });
      }
    } catch (error) {
      print('Error fetching members: $error');
    }
  }

  void _onBottomNavTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StudentAppBarWidget(title: _getAppBarTitle()),
      drawer: StudentDrawerWidget(
        currentPage: 'event_management',
        userName: widget.userName!,
        userRole: widget.userRole!,
      ),
      body: _isLoading ? _buildLoadingWidget() : _buildMainContent(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Danh sách',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Lịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Tìm kiếm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Thêm / sửa',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEventTab(),
        backgroundColor: AppConstants.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0: return 'Danh sách sự kiện';
      case 1: return 'Lịch sự kiện';
      case 2: return 'Tìm kiếm sự kiện';
      case 3: return _editingEventId != null ? 'Chỉnh sửa sự kiện' : 'Thêm sự kiện mới';
      default: return 'Quản lý sự kiện';
    }
  }

  Widget _buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildMainContent() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) => setState(() => _selectedIndex = index),
      children: [
        _buildEventListTab(),
        _buildCalendarTab(),
        _buildSearchTab(),
        _buildAddEventTab(),
      ],
    );
  }

  // Tab 1: Event List
  Widget _buildEventListTab() {
    return Column(
      children: [
        _buildHeader(),
        _buildQuickFilters(),
        Expanded(
          child: _filteredEvents.isEmpty ? _buildEmptyState() : _buildEventList(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
            child: Icon(Icons.event, size: 20, color: AppConstants.primaryColor),
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
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildQuickFilters() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('Tất cả', 'all'),
            _buildFilterChip('Chờ duyệt', 'choDuyet'),
            _buildFilterChip('Đã duyệt', 'daDuyet'),
            _buildFilterChip('Đã từ chối', 'tuChoi'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _statusFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) => setState(() {
          _statusFilter = value;
          _currentPage = 1;
        }),
        backgroundColor: Colors.grey[200],
        selectedColor: AppConstants.primaryColor.withOpacity(0.2),
        checkmarkColor: AppConstants.primaryColor,
      ),
    );
  }

  Widget _buildEventList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            itemCount: _currentPageEvents.length,
            itemBuilder: (context, index) => _buildEventCard(_currentPageEvents[index]),
          ),
        ),
        if (_totalPages > 1) _buildPagination(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Chưa có sự kiện nào',
            style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hãy thêm sự kiện đầu tiên của bạn',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final statusColor = _getStatusColor(event['trangThai']);
    
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(AppConstants.paddingLarge),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
            // Header với tên sự kiện và actions
                              Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                      colors: [AppConstants.primaryColor, AppConstants.primaryColor.withOpacity(0.7)],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                      event['ten'][0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppConstants.paddingMedium),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                        event['ten'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                          overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                        'Phụ trách: ${event['nguoiPhuTrach']}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                _buildActionButtons(event),
              ],
            ),
            
                        const SizedBox(height: AppConstants.paddingLarge),
            
                        // Nội dung chi tiết
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ngày và thời gian cùng 1 dòng
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: AppConstants.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(event['ngayToChuc']),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 20),
                    Icon(Icons.access_time, size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      '${event['thoiGianBatDau']} - ${event['thoiGianKetThuc']}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Địa điểm và status cùng 1 dòng
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.red[400]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event['diaDiem'],
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Trạng thái ở cuối dòng
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_getStatusIcon(event['trangThai']), size: 14, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            _getStatusText(event['trangThai']),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> event) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(Icons.visibility, Colors.blue, () => _openDetailDialog(event['_id']), 'Xem chi tiết'),
        const SizedBox(width: 8),
        if (event['trangThai'] == 'choDuyet') ...[
          _buildActionButton(Icons.edit, Colors.green, () => _openEditEvent(event), 'Chỉnh sửa'),
          const SizedBox(width: 8),
          _buildActionButton(Icons.delete, Colors.red, () => _handleDeleteEvent(event['_id'], event['trangThai']), 'Xóa'),
        ],
      ],
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onPressed, String tooltip) {
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

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Text('$_currentPage / $_totalPages'),
          IconButton(
            onPressed: _currentPage < _totalPages ? () => setState(() => _currentPage++) : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

    // Tab 2: Calendar View
  Widget _buildCalendarTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          // Header với gradient đẹp
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppConstants.primaryColor,
                  AppConstants.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.calendar_month, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lịch sự kiện tất cả CLB',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${_allEvents.length} sự kiện đã tải',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_allEvents.isEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: TextButton.icon(
                      onPressed: () async {
                        print('🔄 Force reloading all events...');
                        await _fetchAllEvents();
                      },
                      icon: const Icon(Icons.refresh, size: 16, color: Colors.white),
                      label: const Text('Reload', style: TextStyle(fontSize: 12, color: Colors.white)),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _focusedDay = DateTime(2025, 6, 15);
                        _selectedDay = DateTime(2025, 6, 15);
                      });
                    },
                    icon: const Icon(Icons.event, size: 16, color: Colors.white),
                    label: const Text('T6/25', style: TextStyle(fontSize: 12, color: Colors.white)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Calendar với design đẹp hơn
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: TableCalendar<Map<String, dynamic>>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: CalendarFormat.month,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  cellMargin: const EdgeInsets.all(4),
                  cellPadding: const EdgeInsets.all(8),
                  weekendTextStyle: TextStyle(color: Colors.red[400], fontSize: 15, fontWeight: FontWeight.w500),
                  defaultTextStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  selectedTextStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  todayTextStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  markerDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppConstants.primaryColor, AppConstants.primaryColor.withOpacity(0.7)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppConstants.primaryColor, AppConstants.primaryColor.withOpacity(0.8)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.primaryColor.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  todayDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppConstants.primaryColor.withOpacity(0.6), AppConstants.primaryColor.withOpacity(0.4)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  markersMaxCount: 3,
                  markerSize: 7,
                  markerMargin: const EdgeInsets.symmetric(horizontal: 1),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                  headerPadding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.05),
                  ),
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                  formatButtonTextStyle: TextStyle(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  formatButtonDecoration: BoxDecoration(
                    border: Border.all(color: AppConstants.primaryColor, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left, color: AppConstants.primaryColor),
                  rightChevronIcon: Icon(Icons.chevron_right, color: AppConstants.primaryColor),
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() => _calendarFormat = format);
                },
                onPageChanged: (focusedDay) {
                  setState(() => _focusedDay = focusedDay);
                },
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Events for selected day
          _buildEventsForSelectedDay(),
        ],
      ),
    );
  }

    Widget _buildEventsForSelectedDay() {
    final eventsForDay = _getEventsForDay(_selectedDay);
    
    if (eventsForDay.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.event_busy, size: 48, color: Colors.grey[400]),
                ),
                const SizedBox(height: 20),
                Text(
                  'Không có sự kiện nào',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ngày ${_formatDate(_selectedDay.toIso8601String())}',
                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tổng: ${_allEvents.length} sự kiện đã tải',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppConstants.primaryColor.withOpacity(0.1),
                  AppConstants.primaryColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.event, color: AppConstants.primaryColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sự kiện ngày ${_formatDate(_selectedDay.toIso8601String())}',
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                      Text(
                        '${eventsForDay.length} sự kiện',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Events list
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: eventsForDay.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final event = eventsForDay[index];
                final isMyClubEvent = _managedClub != null && 
                    event['club'] != null && 
                    ((event['club'] is Map && event['club']['_id'] == _managedClub!['_id']) ||
                     (event['club'] is String && event['club'] == _managedClub!['_id']));
                final clubName = _getClubName(event['club']) ?? 'CLB khác';
                
                return Container(
                  decoration: BoxDecoration(
                    gradient: isMyClubEvent 
                        ? LinearGradient(
                            colors: [
                              AppConstants.primaryColor.withOpacity(0.1),
                              AppConstants.primaryColor.withOpacity(0.05),
                            ],
                          )
                        : LinearGradient(
                            colors: [Colors.grey[50]!, Colors.grey[25]!],
                          ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isMyClubEvent 
                          ? AppConstants.primaryColor.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: isMyClubEvent
                            ? LinearGradient(
                                colors: [AppConstants.primaryColor, AppConstants.primaryColor.withOpacity(0.8)],
                              )
                            : LinearGradient(
                                colors: [Colors.grey[400]!, Colors.grey[500]!],
                              ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isMyClubEvent ? AppConstants.primaryColor : Colors.grey).withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        (event['ten']?.toString() ?? 'SK')[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    title: Text(
                      event['ten']?.toString() ?? 'Sự kiện',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '${event['thoiGianBatDau'] ?? '--:--'} - ${event['thoiGianKetThuc'] ?? '--:--'}',
                                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  event['diaDiem']?.toString() ?? 'Chưa xác định',
                                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.group, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  clubName,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isMyClubEvent ? AppConstants.primaryColor : Colors.grey[700],
                                    fontWeight: isMyClubEvent ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing: Container(
                      constraints: const BoxConstraints(maxWidth: 70),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(event['trangThai']).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        _getStatusIcon(event['trangThai']),
                        color: _getStatusColor(event['trangThai']),
                        size: 16,
                      ),
                    ),
                    onTap: isMyClubEvent && event['_id'] != null ? () => _openDetailDialog(event['_id']) : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Tab 3: Search Tab
  Widget _buildSearchTab() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            children: [
          TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
              hintText: 'Tìm kiếm theo tên sự kiện, người phụ trách...',
                    prefixIcon: Icon(Icons.search, color: AppConstants.primaryColor),
              suffixIcon: _searchTerm.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() {
                        _searchTerm = '';
                                _searchController.clear();
                        _currentPage = 1;
                      }),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
            ),
            onChanged: (value) => setState(() {
              _searchTerm = value;
              _currentPage = 1;
            }),
          ),
          
                    const SizedBox(height: AppConstants.paddingMedium),
          
                      Row(
                        children: [
                          Expanded(
                child: TextField(
                      decoration: const InputDecoration(
                    labelText: 'Từ ngày',
                        border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                  onTap: () => _selectFilterDate('from'),
                  controller: TextEditingController(text: _dateFilter['from']),
                ),
              ),
              const SizedBox(width: AppConstants.paddingSmall),
                          Expanded(
                child: TextField(
                      decoration: const InputDecoration(
                    labelText: 'Đến ngày',
                        border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectFilterDate('to'),
                  controller: TextEditingController(text: _dateFilter['to']),
                            ),
                          ),
                        ],
                      ),
          
          const SizedBox(height: AppConstants.paddingMedium),
          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Tất cả', 'all'),
                _buildFilterChip('Chờ duyệt', 'choDuyet'),
                _buildFilterChip('Đã duyệt', 'daDuyet'),
                _buildFilterChip('Đã từ chối', 'tuChoi'),
              ],
            ),
          ),
          
                    const SizedBox(height: AppConstants.paddingMedium),
          
          if (_searchTerm.isNotEmpty || _statusFilter != 'all' || _dateFilter['from']!.isNotEmpty || _dateFilter['to']!.isNotEmpty)
            ElevatedButton.icon(
              onPressed: () => setState(() {
                _searchTerm = '';
                _searchController.clear();
                _statusFilter = 'all';
                _dateFilter = {'from': '', 'to': ''};
                _currentPage = 1;
              }),
              icon: const Icon(Icons.clear),
              label: const Text('Xóa bộ lọc'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          
          const SizedBox(height: AppConstants.paddingMedium),
          
          Container(
                          padding: const EdgeInsets.all(AppConstants.paddingMedium),
                        decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                Icon(Icons.filter_list, color: AppConstants.primaryColor),
                            const SizedBox(width: 8),
                            Text(
                  'Kết quả: ${_filteredEvents.length} sự kiện',
                              style: TextStyle(
                    fontWeight: FontWeight.bold,
                                color: AppConstants.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
          
                      const SizedBox(height: AppConstants.paddingMedium),
                      
          Expanded(
            child: _filteredEvents.isEmpty 
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: _filteredEvents.length,
                    itemBuilder: (context, index) => _buildCompactEventCard(_filteredEvents[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactEventCard(Map<String, dynamic> event) {
    final statusColor = _getStatusColor(event['trangThai']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openDetailDialog(event['_id']),
        child: Padding(
          padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppConstants.primaryColor, AppConstants.primaryColor.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        event['ten'][0].toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
          Expanded(
                child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        Text(
                          event['ten'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Phụ trách: ${event['nguoiPhuTrach']}',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  // Status badge ở góc phải
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_getStatusIcon(event['trangThai']), size: 12, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          _getStatusText(event['trangThai']),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Thông tin chi tiết
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: AppConstants.primaryColor),
                        const SizedBox(width: 6),
                        Text(
                          _formatDate(event['ngayToChuc']),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.access_time, size: 14, color: Colors.orange),
                        const SizedBox(width: 6),
                        Text(
                          '${event['thoiGianBatDau']} - ${event['thoiGianKetThuc']}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.red[400]),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            event['diaDiem'],
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Action buttons nếu có thể chỉnh sửa
              if (event['trangThai'] == 'choDuyet') ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _openDetailDialog(event['_id']),
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('Xem chi tiết'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _openEditEvent(event),
                        icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                        label: const Text('Chỉnh sửa', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                    onPressed: () => _openDetailDialog(event['_id']),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('Xem chi tiết'),
                        style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
              ],
                  ],
                ),
              ),
      ),
    );
  }

  // Tab 4: Add/Edit Event Tab
  Widget _buildAddEventTab() {
    return SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Form(
        key: _formKey,
          child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            _buildSectionHeader(
              _editingEventId != null ? 'Chỉnh sửa sự kiện' : 'Thêm sự kiện mới',
              Icons.edit,
              _editingEventId != null ? 'Cập nhật thông tin sự kiện' : 'Tạo sự kiện mới cho câu lạc bộ',
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            
            _buildFormField(
              controller: _eventNameController,
              label: 'Tên sự kiện',
              icon: Icons.event,
              validator: (value) => value?.trim().isEmpty == true ? 'Vui lòng nhập tên sự kiện' : null,
              errorText: _errors['ten'],
            ),
            
              const SizedBox(height: AppConstants.paddingMedium),

            _buildDateField(),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            Row(
                    children: [
                Expanded(child: _buildTimeField(true)),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(child: _buildTimeField(false)),
              ],
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            _buildFormField(
              controller: _locationController,
              label: 'Địa điểm',
              icon: Icons.location_on,
              validator: (value) => value?.trim().isEmpty == true ? 'Vui lòng nhập địa điểm' : null,
              errorText: _errors['diaDiem'],
            ),
            
                      const SizedBox(height: AppConstants.paddingMedium),
            
            _buildResponsiblePersonField(),
            
                      const SizedBox(height: AppConstants.paddingMedium),
            
            _buildFormField(
              controller: _contentController,
              label: 'Nội dung sự kiện',
              icon: Icons.description,
              maxLines: 4,
              validator: (value) => value?.trim().isEmpty == true ? 'Vui lòng nhập nội dung' : null,
              errorText: _errors['noiDung'],
            ),
            
                      const SizedBox(height: AppConstants.paddingMedium),
            
            _buildGuestSection(),
            
                      const SizedBox(height: AppConstants.paddingLarge),
            
            if (_errors['conflict'] != null) ...[
              _buildConflictWarning(),
              const SizedBox(height: AppConstants.paddingLarge),
            ],
            
                      Row(
                        children: [
                if (_editingEventId != null) ...[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                        _resetForm();
                                setState(() {
                          _editingEventId = null;
                          _selectedIndex = 0;
                                });
                        _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                              },
                      child: const Text('Hủy'),
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingMedium),
                ],
                          Expanded(
                            child: ElevatedButton(
                    onPressed: _editingEventId != null ? _handleUpdateEvent : _handleAddEvent,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      _editingEventId != null ? 'Cập nhật' : 'Thêm sự kiện',
                      style: const TextStyle(color: Colors.white),
                    ),
                              ),
                            ),
                          ],
                        ),
            
            const SizedBox(height: 100), // Space for bottom nav
                                  ],
                                ),
                              ),
    );
  }

  // Navigation methods
  Future<void> _navigateToAddEventTab() async {
    _resetForm(); // Clear form when navigating to add tab
    setState(() => _selectedIndex = 3);
    _pageController.animateToPage(
      3,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _openDetailDialog(String eventId) {
    final event = _events.firstWhere((e) => e['_id'] == eventId);
    setState(() {
      _detailEvent = event;
      _isDetailDialogOpen = true;
    });
    _showDetailDialog();
  }

    void _showDetailDialog() {
    if (_detailEvent == null) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header với gradient
              Container(
                padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                    colors: [AppConstants.primaryColor, AppConstants.primaryColor.withOpacity(0.8)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                                            children: [
                                              Container(
                      width: 50,
                      height: 50,
                                                decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Center(
                                                  child: Text(
                          _detailEvent!['ten'][0].toUpperCase(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                            fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                    const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                            _detailEvent!['ten'],
                                                      style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                            maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getStatusColor(_detailEvent!['trangThai']).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Text(
                              _getStatusText(_detailEvent!['trangThai']),
                              style: const TextStyle(
                                color: Colors.white,
                                                        fontSize: 12,
                                fontWeight: FontWeight.w500,
                                                      ),
                            ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() => _isDetailDialogOpen = false);
                      },
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thông tin cơ bản
                      _buildDetailSection(
                        'Thông tin sự kiện',
                        Icons.info_outline,
                        [
                          _buildDetailItem(Icons.calendar_today, 'Ngày tổ chức', _formatDate(_detailEvent!['ngayToChuc']), AppConstants.primaryColor),
                          _buildDetailItem(Icons.access_time, 'Thời gian', '${_detailEvent!['thoiGianBatDau']} - ${_detailEvent!['thoiGianKetThuc']}', Colors.orange),
                          _buildDetailItem(Icons.location_on, 'Địa điểm', _detailEvent!['diaDiem'], Colors.red),
                          _buildDetailItem(Icons.person, 'Người phụ trách', _detailEvent!['nguoiPhuTrach'], Colors.blue),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Nội dung sự kiện
                      _buildDetailSection(
                        'Nội dung sự kiện',
                        Icons.description,
                        [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Text(
                              _detailEvent!['noiDung'],
                              style: const TextStyle(fontSize: 14, height: 1.5),
                            ),
                                              ),
                                            ],
                                          ),
                      
                      // Khách mời (nếu có)
                      if (_detailEvent!['khachMoi'] != null && (_detailEvent!['khachMoi'] as List).isNotEmpty) ...[
                        const SizedBox(height: 20),
                        _buildDetailSection(
                          'Khách mời (${(_detailEvent!['khachMoi'] as List).length})',
                          Icons.people,
                          [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: (_detailEvent!['khachMoi'] as List).map((guest) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                  color: AppConstants.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppConstants.primaryColor.withOpacity(0.3)),
                                ),
                                                        child: Text(
                                  guest.toString(),
                                                          style: TextStyle(
                                                            color: AppConstants.primaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                                          ),
                                                        ),
                              )).toList(),
                                                      ),
                                                    ],
                                                  ),
                      ],
                    ],
                                                ),
                ),
              ),
              
              // Footer actions
                                                Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                                                  child: Row(
                                                    children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() => _isDetailDialogOpen = false);
                        },
                        icon: const Icon(Icons.close),
                        label: const Text('Đóng'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    if (_detailEvent!['trangThai'] == 'choDuyet') ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() => _isDetailDialogOpen = false);
                            _openEditEvent(_detailEvent!);
                          },
                          icon: const Icon(Icons.edit, color: Colors.white),
                          label: const Text('Chỉnh sửa', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
  }

  Widget _buildDetailSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppConstants.primaryColor, size: 20),
            const SizedBox(width: AppConstants.paddingMedium),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
                            ),
                    ],
                  ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: iconColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        ],
      ),
    );
  }

  

  Future<void> _handleDeleteEvent(String eventId, String trangThai) async {
    if (trangThai == 'daDuyet') {
      _showError('Không thể xóa sự kiện đã được duyệt!');
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa sự kiện này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        final checkResponse = await http.get(Uri.parse('$apiUrl/check-event-in-reports/$eventId'));
        if (checkResponse.statusCode == 200) {
          final checkData = jsonDecode(checkResponse.body);
          if (checkData['exists']) {
            _showError('Không thể xóa sự kiện này vì nó đã được sử dụng trong báo cáo!');
            return;
          }
        }

        final response = await http.delete(Uri.parse('$apiUrl/delete-event/$eventId'));
        if (response.statusCode == 200) {
          _showSuccess('Đã xóa sự kiện');
          await _fetchEvents(_managedClub!['_id']);
          await _fetchAllEvents();
        } else {
          final errorData = jsonDecode(response.body);
          _showError('Lỗi khi xóa sự kiện: ${errorData['message'] ?? 'Không xác định'}');
        }
      } catch (error) {
        _showError('Lỗi khi xóa sự kiện: $error');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  // Helper methods
  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    // Chỉ debug khi có data và user chọn ngày cụ thể
    if (_allEvents.isEmpty && day.day == 15 && day.month == 6) {
      print('⚠️ _allEvents is empty! API might not be working.');
    }
    
    return _allEvents.where((event) {
      try {
        final eventDateStr = event['ngayToChuc'].toString();
        DateTime eventDate = DateTime.parse(eventDateStr);
        
        final eventLocalDate = DateTime(eventDate.year, eventDate.month, eventDate.day);
        final selectedLocalDate = DateTime(day.year, day.month, day.day);
        
        return eventLocalDate.isAtSameMomentAs(selectedLocalDate);
      } catch (e) {
        return false;
      }
    }).cast<Map<String, dynamic>>().toList();
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'daDuyet': return 'Đã duyệt';
      case 'tuChoi': return 'Đã từ chối';
      case 'choDuyet': return 'Chờ duyệt';
      default: return 'Không xác định';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'daDuyet': return Colors.green;
      case 'tuChoi': return Colors.red;
      case 'choDuyet': return Colors.orange;
      default: return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'daDuyet': return Icons.check_circle;
      case 'tuChoi': return Icons.cancel;
      case 'choDuyet': return Icons.access_time;
      default: return Icons.help;
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _getClubName(dynamic clubData) {
    try {
      if (clubData == null) return 'CLB khác';
      
      // Nếu clubData là object thì lấy trực tiếp
      if (clubData is Map<String, dynamic> && clubData.containsKey('ten')) {
        return clubData['ten']?.toString() ?? 'CLB khác';
      }
      // Nếu clubData là string (clubId) thì tìm trong _clubs
      if (clubData is String && _clubs.isNotEmpty) {
        final club = _clubs.firstWhere(
          (c) => c['_id'] == clubData,
          orElse: () => <String, dynamic>{},
        );
        return club['ten']?.toString() ?? 'CLB khác';
      }
      return 'CLB khác';
    } catch (e) {
      return 'CLB khác';
    }
  }

  List<dynamic> get _filteredEvents {
    var filtered = _events.where((event) {
      final nameMatch = _searchTerm.isEmpty || 
          event['ten'].toString().toLowerCase().contains(_searchTerm.toLowerCase()) ||
          event['nguoiPhuTrach'].toString().toLowerCase().contains(_searchTerm.toLowerCase());
      
      final statusMatch = _statusFilter == 'all' || event['trangThai'] == _statusFilter;
      
      final dateFromMatch = _dateFilter['from']!.isEmpty || 
          DateTime.parse(event['ngayToChuc']).isAfter(DateTime.parse(_dateFilter['from']!).subtract(const Duration(days: 1)));
      
      final dateToMatch = _dateFilter['to']!.isEmpty || 
          DateTime.parse(event['ngayToChuc']).isBefore(DateTime.parse(_dateFilter['to']!).add(const Duration(days: 1)));
      
      return nameMatch && statusMatch && dateFromMatch && dateToMatch;
    }).toList();
    
    // Sort theo ngày từ mới → cũ (descending)
    filtered.sort((a, b) {
      try {
        final dateA = DateTime.parse(a['ngayToChuc']);
        final dateB = DateTime.parse(b['ngayToChuc']);
        return dateB.compareTo(dateA); // Descending order (mới → cũ)
      } catch (e) {
        return 0;
      }
    });
    
    return filtered;
  }

  List<dynamic> get _currentPageEvents {
    final filtered = _filteredEvents;
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    
    if (startIndex >= filtered.length) return [];
    
    return filtered.sublist(
      startIndex, 
      endIndex > filtered.length ? filtered.length : endIndex
    );
  }

  int get _totalPages {
    final filtered = _filteredEvents;
    return (filtered.length / _itemsPerPage).ceil();
  }

  Future<void> _selectFilterDate(String type) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (picked != null) {
      setState(() {
        _dateFilter[type] = picked.toIso8601String().split('T')[0];
        _currentPage = 1;
      });
    }
  }

  void _resetForm() {
    _eventNameController.clear();
    _dateController.clear();
    _startTimeController.clear();
    _endTimeController.clear();
    _locationController.clear();
    _contentController.clear();
    _responsiblePersonController.clear();
    _guestController.clear();
    _guests.clear();
    _errors.clear();
    setState(() => _editingEventId = null);
  }

  void _openEditEvent(Map<String, dynamic> event) {
    setState(() {
      _editingEventId = event['_id'];
      _eventNameController.text = event['ten'];
      _dateController.text = _formatDateForInput(event['ngayToChuc']);
      _startTimeController.text = event['thoiGianBatDau'];
      _endTimeController.text = event['thoiGianKetThuc'];
      _locationController.text = event['diaDiem'];
      _contentController.text = event['noiDung'];
      _responsiblePersonController.text = event['nguoiPhuTrach'];
      _guests = List.from(event['khachMoi'] ?? []);
      _selectedIndex = 3; // Chuyển sang tab thêm/sửa
    });
    _pageController.animateToPage(3, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  String _formatDateForInput(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  void _handleAddEvent() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _errors.clear());

      // Validate time
      if (!_validateTime()) return;

      // Check for conflicts
      if (await _checkForConflicts()) return;

      final eventData = {
        'ten': _eventNameController.text.trim(),
        'ngayToChuc': _dateController.text,
        'thoiGianBatDau': _startTimeController.text.trim(),
        'thoiGianKetThuc': _endTimeController.text.trim(),
        'diaDiem': _locationController.text.trim(),
        'noiDung': _contentController.text.trim(),
        'nguoiPhuTrach': _responsiblePersonController.text.trim(),
        'khachMoi': _guests,
        'club': _managedClub!['_id'],
        'trangThai': 'choDuyet',
      };

      final response = await http.post(
        Uri.parse('$apiUrl/add-event'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(eventData),
      );

      if (response.statusCode == 201) {
        _showSuccess('Đã thêm sự kiện thành công');
        _resetForm();
        await _fetchEvents(_managedClub!['_id']);
        await _fetchAllEvents();
        setState(() => _selectedIndex = 0);
        _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      } else {
        final errorData = jsonDecode(response.body);
        _showError('Lỗi khi thêm sự kiện: ${errorData['message'] ?? 'Không xác định'}');
      }
    } catch (error) {
      _showError('Lỗi khi thêm sự kiện: $error');
    }
  }

  void _handleUpdateEvent() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _errors.clear());

      // Validate time
      if (!_validateTime()) return;

      // Check for conflicts (excluding current event)
      if (await _checkForConflicts(excludeEventId: _editingEventId)) return;

      final eventData = {
        'ten': _eventNameController.text.trim(),
        'ngayToChuc': _dateController.text,
        'thoiGianBatDau': _startTimeController.text.trim(),
        'thoiGianKetThuc': _endTimeController.text.trim(),
        'diaDiem': _locationController.text.trim(),
        'noiDung': _contentController.text.trim(),
        'nguoiPhuTrach': _responsiblePersonController.text.trim(),
        'khachMoi': _guests,
      };

      final response = await http.put(
        Uri.parse('$apiUrl/update-event/$_editingEventId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(eventData),
      );

      if (response.statusCode == 200) {
        _showSuccess('Đã cập nhật sự kiện thành công');
        _resetForm();
        await _fetchEvents(_managedClub!['_id']);
        await _fetchAllEvents();
        setState(() => _selectedIndex = 0);
        _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      } else {
        final errorData = jsonDecode(response.body);
        _showError('Lỗi khi cập nhật sự kiện: ${errorData['message'] ?? 'Không xác định'}');
      }
    } catch (error) {
      _showError('Lỗi khi cập nhật sự kiện: $error');
    }
  }

  bool _validateTime() {
    final startTime = _startTimeController.text;
    final endTime = _endTimeController.text;

    if (startTime.isEmpty || endTime.isEmpty) {
      setState(() => _errors['thoiGianBatDau'] = 'Vui lòng nhập đầy đủ thời gian');
      return false;
    }

    try {
      final start = TimeOfDay(
        hour: int.parse(startTime.split(':')[0]),
        minute: int.parse(startTime.split(':')[1]),
      );
      final end = TimeOfDay(
        hour: int.parse(endTime.split(':')[0]),
        minute: int.parse(endTime.split(':')[1]),
      );

      if (start.hour < 6 || start.hour > 20 || end.hour < 6 || end.hour > 20) {
        setState(() => _errors['thoiGianBatDau'] = 'Thời gian phải trong khoảng 6:00 - 20:00');
        return false;
      }

      final startMinutes = start.hour * 60 + start.minute;
      final endMinutes = end.hour * 60 + end.minute;

      if (endMinutes <= startMinutes) {
        setState(() => _errors['thoiGianBatDau'] = 'Thời gian kết thúc phải sau thời gian bắt đầu');
        return false;
      }

      if (endMinutes - startMinutes < 45) {
        setState(() => _errors['thoiGianBatDau'] = 'Sự kiện phải kéo dài ít nhất 45 phút');
        return false;
      }

      return true;
    } catch (e) {
      setState(() => _errors['thoiGianBatDau'] = 'Định dạng thời gian không hợp lệ');
      return false;
    }
  }

  Future<bool> _checkForConflicts({String? excludeEventId}) async {
    try {
      final eventDate = _dateController.text;
      final startTime = _startTimeController.text;
      final endTime = _endTimeController.text;
      final location = _locationController.text.trim();

      final conflictingEvents = _allEvents.where((event) {
        if (excludeEventId != null && event['_id'] == excludeEventId) {
          return false;
        }

        final eventDateStr = DateTime.parse(event['ngayToChuc']).toIso8601String().split('T')[0];
        if (eventDateStr != eventDate) return false;

        if (event['diaDiem'] == location) {
          final eventStart = event['thoiGianBatDau'];
          final eventEnd = event['thoiGianKetThuc'];

          return _timeOverlaps(startTime, endTime, eventStart, eventEnd);
        }

        return false;
      }).toList();

      if (conflictingEvents.isNotEmpty) {
        final conflictDetails = conflictingEvents.map((e) => 
          '• ${e['ten']} (${_getClubName(e['club'])}) - ${e['thoiGianBatDau']}-${e['thoiGianKetThuc']}'
        ).join('\n');
        
        final action = excludeEventId != null ? 'cập nhật' : 'tạo';
        setState(() => _errors['conflict'] = 
          'Không thể $action sự kiện! Đã có sự kiện khác tồn tại cùng ngày, địa điểm và trùng thời gian:\n\n$conflictDetails\n\nVui lòng chọn thời gian hoặc địa điểm khác.');
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  bool _timeOverlaps(String start1, String end1, String start2, String end2) {
    try {
      final s1 = _timeToMinutes(start1);
      final e1 = _timeToMinutes(end1);
      final s2 = _timeToMinutes(start2);
      final e2 = _timeToMinutes(end2);

      return (s1 < e2) && (s2 < e1);
    } catch (e) {
      return false;
    }
  }

  int _timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  Widget _buildSectionHeader(String title, IconData icon, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppConstants.primaryColor, size: 24),
            const SizedBox(width: AppConstants.paddingMedium),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    String? errorText,
    int? maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            border: const OutlineInputBorder(),
            errorText: errorText,
          ),
          validator: validator,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppConstants.paddingSmall),
        Text(
            errorText,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildDateField() {
    return _buildFormField(
      controller: _dateController,
      label: 'Ngày tổ chức',
      icon: Icons.calendar_today,
      validator: (value) => value?.trim().isEmpty == true ? 'Vui lòng chọn ngày tổ chức' : null,
      errorText: _errors['ngayToChuc'],
      readOnly: true,
      onTap: () => _selectDate(),
    );
  }

  Widget _buildTimeField(bool isStartTime) {
    return _buildFormField(
      controller: isStartTime ? _startTimeController : _endTimeController,
      label: isStartTime ? 'Thời gian bắt đầu' : 'Thời gian kết thúc',
      icon: Icons.access_time,
      validator: (value) => value?.trim().isEmpty == true ? 'Vui lòng chọn thời gian' : null,
      errorText: isStartTime ? _errors['thoiGianBatDau'] : _errors['thoiGianKetThuc'],
      readOnly: true,
      onTap: () => _selectTime(isStartTime),
    );
  }

  Widget _buildResponsiblePersonField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Người phụ trách',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        Stack(
          children: [
            TextFormField(
              controller: _responsiblePersonController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
                hintText: 'Nhập tên người phụ trách',
                suffixIcon: IconButton(
                  icon: Icon(_showStudentDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                  onPressed: () => setState(() => _showStudentDropdown = !_showStudentDropdown),
                ),
                errorText: _errors['nguoiPhuTrach'],
              ),
              validator: (value) => value?.trim().isEmpty == true ? 'Vui lòng chọn người phụ trách' : null,
              onChanged: (value) => _filterStudents(value),
            ),
            if (_showStudentDropdown && _filteredStudents.isNotEmpty)
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredStudents.length,
                      itemBuilder: (context, index) {
                        final student = _filteredStudents[index];
                        return ListTile(
                          title: Text(student['hoTen']),
                          subtitle: Text('MSSV: ${student['mssv']}'),
                          onTap: () {
                            _responsiblePersonController.text = student['hoTen'];
                            setState(() => _showStudentDropdown = false);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildGuestSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Khách mời',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: _showAddGuestDialog,
              icon: const Icon(Icons.add),
              label: const Text('Thêm'),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        if (_guests.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Chưa có khách mời nào',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _guests.map((guest) => Chip(
              label: Text(guest),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () => setState(() => _guests.remove(guest)),
            )).toList(),
          ),
      ],
    );
  }

  Widget _buildConflictWarning() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.red[600]),
              const SizedBox(width: 8),
              Text(
                'Cảnh báo xung đột!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            _errors['conflict']!,
            style: TextStyle(color: Colors.red[700]),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _dateController.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
        _errors.remove('ngayToChuc');
      });
    }
  }

  Future<void> _selectTime(bool isStartTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: isStartTime ? 8 : 10,
        minute: 0,
      ),
    );
    
    if (picked != null) {
      final timeString = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setState(() {
        if (isStartTime) {
          _startTimeController.text = timeString;
        } else {
          _endTimeController.text = timeString;
        }
        _errors.remove('thoiGianBatDau');
        _errors.remove('thoiGianKetThuc');
      });
    }
  }

  void _filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStudents = List.from(_students);
      } else {
        _filteredStudents = _students.where((student) =>
          student['hoTen'].toLowerCase().contains(query.toLowerCase()) ||
          student['mssv'].toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }

  void _showAddGuestDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm khách mời'),
        content: TextField(
          controller: _guestController,
          decoration: const InputDecoration(
            hintText: 'Nhập tên khách mời',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              if (_guestController.text.trim().isNotEmpty) {
                setState(() {
                  _guests.add(_guestController.text.trim());
                  _guestController.clear();
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }
}