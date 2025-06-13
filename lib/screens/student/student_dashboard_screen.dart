import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_screen.dart';
import '../../constants/app_constants.dart';
import '../../services/auth_service.dart';
import '../../widgets/student/dashboard_chart_widget.dart';
import '../../widgets/student/stats_card_widget.dart';
import '../../widgets/student/student_drawer_widget.dart';

class DashboardScreen extends StatefulWidget {
  final String userName;
  final String userRole;

  const DashboardScreen({
    super.key,
    required this.userName,
    required this.userRole,
  });
  
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthService _authService = AuthService();
  
  int _selectedIndex = 0;
  bool _isLoading = true;
  
  final List<String> _titles = [
    'Dashboard',
    'Quản lý thông tin CLB',
  ];

  // Dashboard data
  Map<String, dynamic>? _dashboardData;
  Map<String, dynamic>? _managedClub;
  List<dynamic> _recentMembers = [];
  int _currentBudget = 0;
  int _totalMembers = 0;
  int _totalAwards = 0;
  
  List<int> _eventStats = List.filled(12, 0);
  List<int> _awardStats = List.filled(12, 0);

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

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      
      if (userId == null) {
        _showError('Không tìm thấy thông tin người dùng');
        return;
      }

      // Fetch dashboard data for student
      final response = await http.get(
        Uri.parse('https://club-management-application.onrender.com/api/dashboard/student/$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        setState(() {
          _dashboardData = data;
          _managedClub = data['managedClubs']?.isNotEmpty == true 
              ? data['managedClubs'][0] 
              : null;
          _recentMembers = data['recentMembers'] ?? [];
          _totalAwards = data['totalAwards'] ?? 0;
          _eventStats = List<int>.from(data['eventStats'] ?? List.filled(12, 0));
          _awardStats = List<int>.from(data['awardStats'] ?? List.filled(12, 0));
        });

        // If student manages a club, fetch additional data
        if (_managedClub != null) {
          final clubId = _managedClub!['_id'];
          
          // Fetch club members count
          try {
            final membersResponse = await http.get(
              Uri.parse('https://club-management-application.onrender.com/api/get-members-by-club/$clubId'),
            );
            
            if (membersResponse.statusCode == 200) {
              final membersData = jsonDecode(membersResponse.body);
              setState(() {
                _totalMembers = membersData.length + 1; // +1 for the manager
              });
            }
          } catch (error) {
            print('Error fetching club members: $error');
          }

          // Fetch club budget
          try {
            final budgetResponse = await http.get(
              Uri.parse('https://club-management-application.onrender.com/api/get-club-budget/$clubId'),
            );
            
            if (budgetResponse.statusCode == 200) {
              final budgetData = jsonDecode(budgetResponse.body);
              setState(() {
                _currentBudget = budgetData['budget'] ?? 0;
              });
            }
          } catch (error) {
            print('Error fetching club budget: $error');
          }
        }
      } else {
        _showError('Không thể tải dữ liệu dashboard');
      }

    } catch (error) {
      print('Error loading dashboard data: $error');
      _showError('Lỗi khi tải dữ liệu: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppConstants.fontSizeXLarge,
          ),
        ),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Thông báo',
            onPressed: () {
              _showNotifications(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      drawer: StudentDrawerWidget(
        currentPage: 'dashboard',
        userName: widget.userName,
        userRole: widget.userRole,
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Quản lý CLB',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppConstants.primaryColor,
        ),
      );
    }

    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildSettings();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppConstants.primaryColor.withAlpha((0.1 * 255).round()),
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
                    color: Colors.black.withAlpha((0.1 * 255).round()),
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
                        backgroundColor: AppConstants.primaryColor.withAlpha((0.1 * 255).round()),
                        child: Icon(
                          widget.userRole == 'manager' 
                              ? Icons.admin_panel_settings
                              : Icons.school,
                          size: 30,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Xin chào, ${widget.userName}',
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeXLarge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.userRole,
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeMedium,
                              color: AppConstants.textSecondaryColor,
                            ),
                          ),
                        ],
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
                    title: 'CLB đang quản lý',
                    value: _managedClub?['ten'] ?? 'Chưa có CLB',
                    icon: Icons.business,
                    color: AppConstants.primaryColor,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: StatsCardWidget(
                    title: 'Ngân Sách Hiện Tại',
                    value: '${(_currentBudget / 1000000).toStringAsFixed(1)}M VNĐ',
                    icon: Icons.monetization_on,
                    color: AppConstants.warningColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            
            Row(
              children: [
                Expanded(
                  child: StatsCardWidget(
                    title: 'Tổng Thành Viên',
                    value: '$_totalMembers',
                    icon: Icons.people,
                    color: AppConstants.successColor,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: StatsCardWidget(
                    title: 'Tổng Giải Thưởng',
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
                fontSize: AppConstants.fontSizeXXLarge,
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
                    color: Colors.black.withAlpha((0.1 * 255).round()),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: DashboardChartWidget(
                title: 'Hoạt động/Sự kiện',
                chartType: ChartType.events,
                color: AppConstants.primaryColor,
                data: _eventStats,
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
                    color: Colors.black.withAlpha((0.1 * 255).round()),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: DashboardChartWidget(
                title: 'Giải thưởng',
                chartType: ChartType.awards,
                color: Colors.purple,
                data: _awardStats,
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Recent Members Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.1 * 255).round()),
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
                              Icons.people_alt,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(width: AppConstants.paddingSmall),
                            Text(
                              'Thành Viên Mới',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppConstants.fontSizeXLarge,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingSmall,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha((0.2 * 255).round()),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$_totalMembers thành viên',
                            style: const TextStyle(
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
                    child: _buildRecentMembersList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentMembersList() {
    if (_recentMembers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.people_outline,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                'Chưa có thành viên mới',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: AppConstants.fontSizeMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Member table header
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          child: Row(
            children: [
              const Expanded(
                flex: 2,
                child: Text(
                  'Họ Tên',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textSecondaryColor,
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  'MSHS',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textSecondaryColor,
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  'Lớp',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textSecondaryColor,
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  'Ngày Tham Gia',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textSecondaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        // Member rows
        ...(_recentMembers.take(4).map((member) => _buildMemberRow(member)).toList()),
        const SizedBox(height: AppConstants.paddingMedium),
        // View All Button
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chức năng đang phát triển'),
                  backgroundColor: AppConstants.primaryColor,
                ),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                side: BorderSide(
                  color: AppConstants.primaryColor.withAlpha((0.3 * 255).round()),
                  width: 1,
                ),
              ),
            ),
            child: const Text(
              'Xem tất cả thành viên',
              style: TextStyle(
                color: AppConstants.primaryColor,
                fontSize: AppConstants.fontSizeLarge,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberRow(Map<String, dynamic> member) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              member['hoTen'] ?? 'N/A',
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              member['maSoHocSinh'] ?? 'N/A',
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: AppConstants.textSecondaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              member['lop'] ?? 'N/A',
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: AppConstants.textSecondaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              _formatDate(member['ngayThamGia']),
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: AppConstants.textSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.notifications, color: AppConstants.primaryColor),
            SizedBox(width: AppConstants.paddingSmall),
            Text(
              'Thông báo',
              style: TextStyle(
                fontSize: AppConstants.fontSizeXLarge,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Chưa có thông báo mới.',
          style: TextStyle(fontSize: AppConstants.fontSizeLarge),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Đóng',
              style: TextStyle(fontSize: AppConstants.fontSizeLarge),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Club Info Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.1 * 255).round()),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with gradient background
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppConstants.primaryColor,
                        AppConstants.primaryColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppConstants.borderRadiusLarge),
                      topRight: Radius.circular(AppConstants.borderRadiusLarge),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.business,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thông tin Câu lạc bộ',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeXXLarge,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Quản lý và cập nhật thông tin CLB',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeMedium,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.badge, 'Tên câu lạc bộ', _managedClub?['ten'] ?? 'Chưa có CLB'),
                      _buildInfoRow(Icons.category, 'Lĩnh vực', _managedClub?['linhVuc'] ?? 'N/A'),
                      _buildInfoRow(Icons.people, 'Tổng thành viên', '$_totalMembers người'),
                      _buildInfoRow(Icons.monetization_on, 'Ngân sách', '${(_currentBudget / 1000000).toStringAsFixed(1)}M VNĐ'),
                      _buildInfoRow(Icons.emoji_events, 'Tổng giải thưởng', '$_totalAwards giải thưởng'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
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
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeLarge,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimaryColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeLarge,
                color: AppConstants.textSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.logout,
                color: AppConstants.warningColor,
                size: 28,
              ),
              SizedBox(width: AppConstants.paddingSmall),
              Text(
                'Đăng xuất',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng?',
            style: TextStyle(fontSize: AppConstants.fontSizeLarge),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Hủy',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: AppConstants.fontSizeLarge,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                AuthService().logout();
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.warningColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
              ),
              child: const Text(
                'Đăng xuất',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: AppConstants.fontSizeLarge,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
