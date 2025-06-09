import 'package:flutter/material.dart';
import '../login_screen.dart';
import '../../constants/app_constants.dart';
import '../../services/auth_service.dart';
import '../../services/member_data_service.dart';
import '../../services/budget_data_service.dart';
import '../../services/event_data_service.dart';
import '../../services/award_data_service.dart';
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
  int _selectedIndex = 0;
  
  final List<String> _titles = [
    'Dashboard',
    'Quản lý thông tin CLB',
  ];

  final MemberDataService _memberService = MemberDataService();
  final BudgetDataService _budgetService = BudgetDataService();
  final EventDataService _eventService = EventDataService();
  final AwardDataService _awardService = AwardDataService();

  int _totalMembers = 0;
  int _totalBudget = 0;
  int _totalEvents = 0;
  int _totalAwards = 0;
  String _clubName = 'Câu lạc bộ tin học';
  String _clubField = 'Công Nghệ';
  String _clubLogo = '/uploads/d034915e14df6c0d63b832c64483d6f6';
  String _establishedDate = '21/10/2024';
  String _responsibleTeacher = 'Thầy Nguyễn Văn A';
  String _description = 'Câu lạc bộ tin học là nơi dành cho các bạn đam mê công nghệ và lập trình...';
  String _regulations = 'Phải có mặt vào cuối tuần';
  String _clubLeader = 'HS123456';
  String _status = 'Còn hoạt động';
  int _budget = 2000000;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    final members = _memberService.getAllMembers();
    final budgets = _budgetService.getAllBudgets();
    final events = _eventService.getAllEvents();
    final awards = _awardService.getAllAwards();

    setState(() {
      _totalMembers = members.length;
      _totalBudget = budgets.fold<int>(0, (sum, budget) => sum + budget.nguonThu);
      _totalEvents = events.length;
      _totalAwards = awards.length;
    });
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
                          widget.userRole == 'Quản lý' 
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
                    value: _clubName,
                    icon: Icons.business,
                    color: AppConstants.primaryColor,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: StatsCardWidget(
                    title: 'Tổng Thành Viên',
                    value: '$_totalMembers',
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
                    title: 'Ngân Sách Hiện Tại',
                    value: '${(_totalBudget / 1000000).toStringAsFixed(1)}M VNĐ',
                    icon: Icons.monetization_on,
                    color: AppConstants.warningColor,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: StatsCardWidget(
                    title: 'Lĩnh vực',
                    value: _clubField,
                    icon: Icons.computer,
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
              child: const DashboardChartWidget(
                title: 'Hoạt động/Sự kiện',
                chartType: ChartType.events,
                color: AppConstants.primaryColor,
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
              child: const DashboardChartWidget(
                title: 'Giải thưởng',
                chartType: ChartType.awards,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // New Members Section
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
                            '${_memberService.getAllMembers().length} thành viên',
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
                    child: Column(
                      children: [
                        // Member Cards
                        ..._memberService.getAllMembers().take(4).map(
                          (member) => _buildMemberCard(
                            member.ten,
                            member.id.toString(),
                            member.lop,
                            member.vaiTro,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingMedium),
                        // View All Button
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Navigate to all members page
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: _showEditClubInfoDialog,
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 24,
                          ),
                          tooltip: 'Chỉnh sửa thông tin',
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
                      // Thông tin cơ bản (không thể sửa)
                      _buildInfoRow(Icons.badge, 'Tên câu lạc bộ', _clubName, canEdit: false),
                      _buildInfoRow(Icons.category, 'Lĩnh vực', _clubField, canEdit: false),
                      _buildInfoRow(Icons.calendar_today, 'Ngày thành lập', _establishedDate, canEdit: false),
                      _buildInfoRow(Icons.info, 'Tình trạng', _status, canEdit: false),
                      
                      _buildSectionDivider('Thông tin có thể chỉnh sửa'),
                      
                      // Thông tin có thể chỉnh sửa
                      _buildInfoRow(Icons.image, 'Logo CLB', 'Hình ảnh đại diện', canEdit: true),
                      _buildInfoRow(Icons.person_outline, 'Giáo viên phụ trách', _responsibleTeacher, canEdit: true),
                      _buildInfoRow(Icons.description, 'Miêu tả', _description.length > 50 ? '${_description.substring(0, 50)}...' : _description, canEdit: true),
                      _buildInfoRow(Icons.rule, 'Quy định', _regulations, canEdit: true),
                      _buildInfoRow(Icons.supervisor_account, 'Trưởng ban CLB', _clubLeader, canEdit: true),
                      
                      _buildSectionDivider('Thống kê tự động'),
                      
                      // Thông tin thống kê (không thể sửa)
                      _buildInfoRow(Icons.people, 'Tổng thành viên', '$_totalMembers người', canEdit: false),
                      _buildInfoRow(Icons.monetization_on, 'Ngân sách', '${(_budget / 1000000).toStringAsFixed(1)}M VNĐ', canEdit: false),
                      _buildInfoRow(Icons.event, 'Tổng sự kiện', '$_totalEvents sự kiện', canEdit: false),
                      _buildInfoRow(Icons.emoji_events, 'Tổng giải thưởng', '$_totalAwards giải thưởng', canEdit: false),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          
          // Quick Actions
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
                    Icon(
                      Icons.flash_on,
                      color: AppConstants.primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
          const Text(
                      'Thao tác nhanh',
            style: TextStyle(
                        fontSize: AppConstants.fontSizeXXLarge,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                
                _buildActionButton(
                  Icons.refresh,
                  'Làm mới dữ liệu',
                  'Cập nhật thống kê mới nhất',
                  () => _loadDashboardData(),
                ),
                _buildActionButton(
                  Icons.info_outline,
                  'Thông tin ứng dụng',
                  'Xem thông tin phiên bản',
                  () => _showAppInfo(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool canEdit = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: canEdit ? Colors.blue[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(
          color: canEdit ? Colors.blue[200]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: canEdit ? Colors.blue[100] : AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: canEdit ? Colors.blue[700] : AppConstants.primaryColor,
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
              style: TextStyle(
                fontSize: AppConstants.fontSizeLarge,
                color: canEdit ? Colors.blue[800] : AppConstants.textSecondaryColor,
                fontWeight: canEdit ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          if (canEdit)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.edit,
                size: 16,
                color: Colors.blue[700],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingSmall),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                ),
                child: Icon(
                  icon,
                  color: AppConstants.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.textPrimaryColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        color: AppConstants.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAppInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info, color: AppConstants.primaryColor),
            SizedBox(width: AppConstants.paddingSmall),
            Text('Thông tin ứng dụng'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ứng dụng quản lý câu lạc bộ'),
            SizedBox(height: AppConstants.paddingSmall),
            Text('Phiên bản: 1.0.0'),
            SizedBox(height: AppConstants.paddingSmall),
            Text('Phát triển bởi: Team Development'),
          ],
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

  Widget _buildMemberCard(
    String name,
    String studentId,
    String className,
    String role,
  ) {
    Color roleColor = _getRoleColor(role);
    IconData roleIcon = _getRoleIcon(role);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: roleColor.withAlpha((0.15 * 255).round()),
            child: Icon(
              roleIcon,
              color: roleColor,
              size: 20,
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          
          // Name and info section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textPrimaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 6),
                
                // MSHS + Class info with better styling
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withAlpha((0.1 * 255).round()),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.badge,
                            size: 10,
                            color: AppConstants.primaryColor,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            studentId,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha((0.1 * 255).round()),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.school,
                            size: 10,
                            color: Colors.blue[700],
                          ),
                          const SizedBox(width: 3),
                          Text(
                            className,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
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
          
          // Role Badge - moved to the right
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: roleColor.withAlpha((0.15 * 255).round()),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: roleColor.withAlpha((0.3 * 255).round()),
                width: 1,
              ),
            ),
            child: Text(
              role,
              style: TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                fontWeight: FontWeight.w700,
                color: roleColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'quản lý':
      case 'admin':
        return AppConstants.warningColor;
      case 'phó quản lý':
      case 'vice admin':
        return Colors.orange;
      case 'thành viên':
      case 'member':
        return AppConstants.primaryColor;
      default:
        return AppConstants.successColor;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'quản lý':
      case 'admin':
        return Icons.admin_panel_settings;
      case 'phó quản lý':
      case 'vice admin':
        return Icons.supervisor_account;
      case 'thành viên':
      case 'member':
        return Icons.person;
      default:
        return Icons.school;
    }
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppConstants.primaryColor.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildSectionDivider(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppConstants.paddingLarge),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppConstants.primaryColor.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppConstants.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                fontWeight: FontWeight.w600,
                color: AppConstants.primaryColor,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstants.primaryColor.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditClubInfoDialog() {
    final TextEditingController teacherController = TextEditingController(text: _responsibleTeacher);
    final TextEditingController descriptionController = TextEditingController(text: _description);
    final TextEditingController regulationsController = TextEditingController(text: _regulations);
    final TextEditingController leaderController = TextEditingController(text: _clubLeader);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.edit,
                  color: AppConstants.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              const Text(
                'Chỉnh sửa thông tin CLB',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo upload section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.image, size: 40, color: Colors.blue[700]),
                        const SizedBox(height: AppConstants.paddingSmall),
                        Text(
                          'Logo CLB',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700],
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Chức năng upload đang phát triển')),
                            );
                          },
                          icon: const Icon(Icons.upload),
                          label: const Text('Chọn ảnh mới'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[100],
                            foregroundColor: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  
                  TextField(
                    controller: teacherController,
                    decoration: InputDecoration(
                      labelText: 'Giáo viên phụ trách',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                      ),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  
                  TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Miêu tả',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                      ),
                      prefixIcon: const Icon(Icons.description),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  
                  TextField(
                    controller: regulationsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Quy định',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                      ),
                      prefixIcon: const Icon(Icons.rule),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  
                  TextField(
                    controller: leaderController,
                    decoration: InputDecoration(
                      labelText: 'Trưởng ban CLB (MSHS)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                      ),
                      prefixIcon: const Icon(Icons.supervisor_account),
                      hintText: 'Ví dụ: HS123456',
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange[700], size: 20),
                        const SizedBox(width: AppConstants.paddingSmall),
                        Expanded(
                          child: Text(
                            'Chỉ có thể chỉnh sửa: Logo, Giáo viên phụ trách, Miêu tả, Quy định và Trưởng ban CLB.',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeSmall,
                              color: Colors.orange[700],
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
                setState(() {
                  _responsibleTeacher = teacherController.text;
                  _description = descriptionController.text;
                  _regulations = regulationsController.text;
                  _clubLeader = leaderController.text;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã cập nhật thông tin câu lạc bộ'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
              ),
              child: const Text(
                'Lưu thay đổi',
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
