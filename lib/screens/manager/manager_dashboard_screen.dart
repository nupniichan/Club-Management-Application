import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/app_constants.dart';
import '../../widgets/manager/dashboard_chart_widget.dart';
import '../../widgets/manager/stats_card_widget.dart';
import '../../services/auth_service.dart';

class ManagerDashboardScreen extends StatefulWidget {
  const ManagerDashboardScreen({super.key});

  @override
  State<ManagerDashboardScreen> createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  final AuthService _authService = AuthService();
  
  bool _isLoading = true;
  Map<String, dynamic>? _dashboardData;
  List<dynamic> _pendingEvents = [];
  
  int _totalClubs = 0;
  int _totalStudents = 0;
  int _totalEvents = 0;
  int _totalAwards = 0;
  
  List<int> _schoolEventStats = List.filled(12, 0);
  List<int> _schoolAwardsStats = List.filled(12, 0);

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Fetch dashboard data for manager
      final response = await http.get(
        Uri.parse('https://club-management-application.onrender.com/api/dashboard/teacher'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Fetch additional data for total students calculation
        try {
          // Fetch all students (accounts)
          final studentsResponse = await http.get(
            Uri.parse('https://club-management-application.onrender.com/api/students'),
          );
          final totalStudentsFromAccounts = studentsResponse.statusCode == 200 
              ? jsonDecode(studentsResponse.body).length 
              : 0;

          // Fetch all club members
          final membersResponse = await http.get(
            Uri.parse('https://club-management-application.onrender.com/api/get-members'),
          );
          final totalMembers = membersResponse.statusCode == 200 
              ? jsonDecode(membersResponse.body).length 
              : 0;

          // Calculate total participants
          final totalParticipants = totalStudentsFromAccounts + totalMembers;

          setState(() {
            _dashboardData = data;
            _totalClubs = data['totalClubs'] ?? 0;
            _totalStudents = totalParticipants;
            _totalEvents = data['totalEvents'] ?? 0;
            _totalAwards = data['totalAwards'] ?? 0;
            _schoolEventStats = List<int>.from(data['schoolEventStats'] ?? List.filled(12, 0));
            _schoolAwardsStats = List<int>.from(data['schoolAwardsStats'] ?? List.filled(12, 0));
          });
        } catch (error) {
          print('Error fetching additional data: $error');
          setState(() {
            _dashboardData = data;
            _totalClubs = data['totalClubs'] ?? 0;
            _totalStudents = data['totalStudents'] ?? 0;
            _totalEvents = data['totalEvents'] ?? 0;
            _totalAwards = data['totalAwards'] ?? 0;
            _schoolEventStats = List<int>.from(data['schoolEventStats'] ?? List.filled(12, 0));
            _schoolAwardsStats = List<int>.from(data['schoolAwardsStats'] ?? List.filled(12, 0));
          });
        }
      }

      // Fetch pending events
      final pendingResponse = await http.get(
        Uri.parse('https://club-management-application.onrender.com/api/get-pending-events'),
      );

      if (pendingResponse.statusCode == 200) {
        final pendingData = jsonDecode(pendingResponse.body);
        setState(() {
          _pendingEvents = pendingData;
          // Sort events by date (newest first)
          _pendingEvents.sort((a, b) => 
            DateTime.parse(b['ngayToChuc']).compareTo(DateTime.parse(a['ngayToChuc'])));
        });
      }

    } catch (error) {
      print('Error loading dashboard data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tải dữ liệu: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppConstants.primaryColor,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppConstants.primaryColor.withValues(alpha: 0.1),
            Colors.white,
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.admin_panel_settings,
                          size: 30,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chào mừng trở lại!',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeMedium,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              _authService.currentUser?.name ?? 'Quản lý',
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeXXLarge,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.textPrimaryColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingSmall,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppConstants.successColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Quản lý hệ thống',
                                style: TextStyle(
                                  fontSize: AppConstants.fontSizeSmall,
                                  fontWeight: FontWeight.w600,
                                  color: AppConstants.successColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(AppConstants.paddingSmall),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.today,
                              color: AppConstants.primaryColor,
                              size: 20,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateTime.now().day.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeSmall,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.primaryColor,
                              ),
                            ),
                            Text(
                              _getMonthName(DateTime.now().month),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Stats Cards Row
            Row(
              children: [
                Expanded(
                  child: StatsCardWidget(
                    title: 'Tổng Câu Lạc Bộ',
                    value: '$_totalClubs',
                    icon: Icons.business,
                    color: AppConstants.primaryColor,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: StatsCardWidget(
                    title: 'Tổng Học Sinh Tham Gia',
                    value: '$_totalStudents',
                    icon: Icons.people,
                    color: AppConstants.successColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            
            Row(
              children: [
                Expanded(
                  child: StatsCardWidget(
                    title: 'Sự Kiện Đã Tổ Chức',
                    value: '$_totalEvents',
                    icon: Icons.event,
                    color: AppConstants.warningColor,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: StatsCardWidget(
                    title: 'Giải Thưởng Đạt Được',
                    value: '$_totalAwards',
                    icon: Icons.emoji_events,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Charts Section
            const Text(
              'Thống Kê Hoạt Động',
              style: TextStyle(
                fontSize: AppConstants.fontSizeXLarge,
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimaryColor,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            // Events Chart
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: DashboardChartWidget(
                title: 'Thống Kê Sự Kiện',
                chartType: ChartType.events,
                color: AppConstants.primaryColor,
                data: _schoolEventStats,
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Awards Chart
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: DashboardChartWidget(
                title: 'Thống Kê Giải Thưởng',
                chartType: ChartType.awards,
                color: Colors.purple,
                data: _schoolAwardsStats,
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Pending Events
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    decoration: const BoxDecoration(
                      color: AppConstants.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppConstants.borderRadiusLarge),
                        topRight: Radius.circular(AppConstants.borderRadiusLarge),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.pending_actions,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(width: AppConstants.paddingSmall),
                            Text(
                              'Sự Kiện Chờ Duyệt',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppConstants.fontSizeXLarge,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO: Navigate to approve events page
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Chức năng đang phát triển'),
                                backgroundColor: AppConstants.primaryColor,
                              ),
                            );
                          },
                          child: const Text(
                            'Xem tất cả →',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppConstants.fontSizeMedium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    child: Column(
                      children: _buildPendingEventsList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      '', 'T1', 'T2', 'T3', 'T4', 'T5', 'T6',
      'T7', 'T8', 'T9', 'T10', 'T11', 'T12'
    ];
    return months[month];
  }

  List<Widget> _buildPendingEventsList() {
    if (_pendingEvents.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.event_busy,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: AppConstants.paddingSmall),
                Text(
                  'Không có sự kiện chờ duyệt',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    List<Widget> items = [];
    for (int i = 0; i < _pendingEvents.length && i < 5; i++) {
      final event = _pendingEvents[i];
      items.add(_buildEventItem(event));
      if (i < _pendingEvents.length - 1 && i < 4) {
        items.add(Divider(color: Colors.grey[200]));
      }
    }
    
    return items;
  }

  String _formatDate(String isoDateString) {
    final date = DateTime.parse(isoDateString);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildEventItem(Map<String, dynamic> event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingSmall),
            decoration: BoxDecoration(
              color: AppConstants.warningColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            ),
            child: const Icon(
              Icons.event,
              color: AppConstants.warningColor,
              size: 20,
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['ten'] ?? 'Sự kiện không tên',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  event['club']?['ten'] ?? 'CLB không xác định',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatDate(event['ngayToChuc']),
            style: TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 