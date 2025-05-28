import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/manager/dashboard_chart_widget.dart';
import '../../widgets/manager/stats_card_widget.dart';

class ManagerDashboardScreen extends StatelessWidget {
  const ManagerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                            const Text(
                              'Nguyễn Phi Quốc Bảo',
                              style: TextStyle(
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
                                'Quản lý câu lạc bộ',
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
                    value: '12',
                    icon: Icons.business,
                    color: AppConstants.primaryColor,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: StatsCardWidget(
                    title: 'Tổng Thành Viên',
                    value: '248',
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
                    title: 'Sự kiện đã tổ chức',
                    value: '35',
                    icon: Icons.event,
                    color: AppConstants.warningColor,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: StatsCardWidget(
                    title: 'Giải Thưởng Đạt Được',
                    value: '8',
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
              child: const DashboardChartWidget(
                title: 'Thống Kê Sự Kiện',
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
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const DashboardChartWidget(
                title: 'Thống Kê Giải Thưởng',
                chartType: ChartType.awards,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Recent Activities
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
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppConstants.borderRadiusLarge),
                        topRight: Radius.circular(AppConstants.borderRadiusLarge),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.history,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    child: Column(
                      children: [
                        _buildEventItem(
                          'Lễ trao bằng',
                          'Tin học',
                          '09/11/2001',
                          Icons.school,
                          AppConstants.warningColor,
                        ),
                        const Divider(),
                        _buildEventItem(
                          'Hội thảo AI',
                          'Công nghệ',
                          '15/11/2001',
                          Icons.computer,
                          AppConstants.primaryColor,
                        ),
                        const Divider(),
                        _buildEventItem(
                          'Cuộc thi lập trình',
                          'Tin học',
                          '20/11/2001',
                          Icons.code,
                          AppConstants.successColor,
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

  String _getMonthName(int month) {
    const months = [
      '', 'T1', 'T2', 'T3', 'T4', 'T5', 'T6',
      'T7', 'T8', 'T9', 'T10', 'T11', 'T12'
    ];
    return months[month];
  }

  Widget _buildEventItem(
    String eventName,
    String clubName,
    String date,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingSmall),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
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
                  eventName,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  clubName,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
} 