import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/manager/manager_drawer_widget.dart';
import '../../widgets/manager/manager_app_bar_widget.dart';

class ManagerEventApprovalScreen extends StatefulWidget {
  const ManagerEventApprovalScreen({super.key});

  @override
  State<ManagerEventApprovalScreen> createState() => _ManagerEventApprovalScreenState();
}

class _ManagerEventApprovalScreenState extends State<ManagerEventApprovalScreen> {
  int _selectedIndex = 0;
  String _currentTitle = 'Tất cả sự kiện';

  final List<String> _titles = [
    'Tất cả sự kiện',
    'Chờ duyệt',
    'Đã duyệt',
  ];

  // Updated event data based on MongoDB structure
  final List<Map<String, dynamic>> _events = [
    {
      '_id': '673c5d577f6aae48b37a856b',
      'ten': 'IT Day',
      'ngayToChuc': '2024-11-22T00:00:00.000Z',
      'thoiGianBatDau': '12:00',
      'thoiGianKetThuc': '15:00',
      'diaDiem': 'Sân trường',
      'noiDung': 'Sự kiện IT Day được tổ chức nhằm giới thiệu cho mọi người về thế giới công nghệ thông tin hiện đại',
      'nguoiPhuTrach': 'Nguyễn Phi Quốc Bảo',
      'khachMoi': ['Công ty ABC', 'Trường ĐH XYZ'],
      'club': '67160c5ad55fc5f816de7644',
      'trangThai': 'daDuyet',
    },
    {
      '_id': '673c5d577f6aae48b37a856c',
      'ten': 'Workshop Lập trình Web',
      'ngayToChuc': '2024-12-01T00:00:00.000Z',
      'thoiGianBatDau': '08:00',
      'thoiGianKetThuc': '17:00',
      'diaDiem': 'Phòng Lab A',
      'noiDung': 'Workshop dạy lập trình web với React và Node.js dành cho sinh viên',
      'nguoiPhuTrach': 'Trần Văn A',
      'khachMoi': ['Chuyên gia IT'],
      'club': '67160c5ad55fc5f816de7644',
      'trangThai': 'choPheDuyet',
    },
    {
      '_id': '673c5d577f6aae48b37a856d',
      'ten': 'Buổi biểu diễn âm nhạc',
      'ngayToChuc': '2024-11-30T00:00:00.000Z',
      'thoiGianBatDau': '19:00',
      'thoiGianKetThuc': '21:00',
      'diaDiem': 'Hội trường chính',
      'noiDung': 'Buổi biểu diễn âm nhạc acoustic của câu lạc bộ âm nhạc',
      'nguoiPhuTrach': 'Lê Thị B',
      'khachMoi': ['Ban nhạc ABC'],
      'club': '67160c5ad55fc5f816de7645',
      'trangThai': 'daDuyet',
    },
    {
      '_id': '673c5d577f6aae48b37a856e',
      'ten': 'Giải chạy marathon',
      'ngayToChuc': '2024-12-15T00:00:00.000Z',
      'thoiGianBatDau': '06:00',
      'thoiGianKetThuc': '10:00',
      'diaDiem': 'Quanh trường học',
      'noiDung': 'Giải chạy marathon thường niên nhằm rèn luyện sức khỏe cho sinh viên',
      'nguoiPhuTrach': 'Phạm Văn C',
      'khachMoi': [],
      'club': '67160c5ad55fc5f816de7646',
      'trangThai': 'choPheDuyet',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ManagerAppBarWidget(title: _currentTitle),
      drawer: const ManagerDrawerWidget(
        currentPage: 'event_approval',
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
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tất cả',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Chờ duyệt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Đã duyệt',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    List<Map<String, dynamic>> filteredEvents;
    
    switch (_selectedIndex) {
      case 0:
        filteredEvents = _events;
        break;
      case 1:
        filteredEvents = _events.where((event) => event['trangThai'] == 'choPheDuyet').toList();
        break;
      case 2:
        filteredEvents = _events.where((event) => event['trangThai'] == 'daDuyet').toList();
        break;
      default:
        filteredEvents = _events;
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatsCard(
                  'Tổng sự kiện',
                  '${_events.length}',
                  Icons.event,
                  AppConstants.primaryColor,
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: _buildStatsCard(
                  'Chờ duyệt',
                  '${_events.where((e) => e['trangThai'] == 'choPheDuyet').length}',
                  Icons.pending,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: _buildStatsCard(
                  'Đã duyệt',
                  '${_events.where((e) => e['trangThai'] == 'daDuyet').length}',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          
          // Search bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Tìm kiếm sự kiện...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          
          // Event List
          Text(
            _currentTitle,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          
          Expanded(
            child: filteredEvents.isEmpty
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
                        Text(
                          'Không có sự kiện nào',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeLarge,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      return _buildEventCard(event);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            value,
            style: TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoDateString) {
    final date = DateTime.parse(isoDateString);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'daDuyet':
        return 'Đã duyệt';
      case 'choPheDuyet':
        return 'Chờ duyệt';
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'daDuyet':
        return Colors.green;
      case 'choPheDuyet':
        return Colors.orange;
      case 'hoanThanh':
        return Colors.blue;
      case 'daHuy':
        return Colors.red;
      case 'dangDienRa':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final statusColor = _getStatusColor(event['trangThai']);
    final statusText = _getStatusText(event['trangThai']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              statusColor.withOpacity(0.03),
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
                          statusColor,
                          statusColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: statusColor.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        event['ten'][0].toUpperCase(),
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
                          event['ten'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Người phụ trách: ${event['nguoiPhuTrach']}',
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
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
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
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ngày: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          _formatDate(event['ngayToChuc']),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${event['thoiGianBatDau']} - ${event['thoiGianKetThuc']}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Địa điểm: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            event['diaDiem'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (event['khachMoi'].isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Khách mời: ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              event['khachMoi'].join(', '),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Text(
                event['noiDung'],
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _showEventDetails(event),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('Chi tiết'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      side: const BorderSide(color: Colors.blue),
                      foregroundColor: Colors.blue,
                    ),
                  ),
                  if (event['trangThai'] == 'choPheDuyet') ...[
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: () => _approveEvent(event),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Duyệt'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: () => _rejectEvent(event),
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Từ chối'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEventDetails(Map<String, dynamic> event) {
    final statusColor = _getStatusColor(event['trangThai']);
    final statusText = _getStatusText(event['trangThai']);
    
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
                  color: statusColor.withAlpha((0.1 * 255).round()),
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
                        color: statusColor.withAlpha(51),
                      ),
                      child: Center(
                        child: Text(
                          event['ten'][0].toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: AppConstants.fontSizeXLarge,
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
                            event['ten'] ?? 'Sự kiện',
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
                              color: statusColor.withAlpha(51),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeSmall,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
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
                      _buildDetailRow(
                        Icons.calendar_today, 
                        'Ngày tổ chức', 
                        _formatDate(event['ngayToChuc'])
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      _buildDetailRow(
                        Icons.access_time, 
                        'Thời gian', 
                        '${event['thoiGianBatDau']} - ${event['thoiGianKetThuc']}'
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      _buildDetailRow(
                        Icons.location_on, 
                        'Địa điểm', 
                        event['diaDiem'] ?? 'Chưa có thông tin'
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      _buildDetailRow(
                        Icons.person, 
                        'Người phụ trách', 
                        event['nguoiPhuTrach'] ?? 'Chưa có thông tin'
                      ),
                      
                      if (event['khachMoi'] != null && event['khachMoi'].isNotEmpty) ...[
                        const SizedBox(height: AppConstants.paddingSmall),
                        _buildDetailRow(
                          Icons.people, 
                          'Khách mời', 
                          event['khachMoi'].join(', ')
                        ),
                      ],
                      
                      if (event['noiDung'] != null && event['noiDung'].isNotEmpty) ...[
                        const SizedBox(height: AppConstants.paddingMedium),
                        const Text(
                          'Nội dung sự kiện',
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
                            event['noiDung'],
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeMedium,
                              height: 1.5,
                            ),
                          ),
                        ),
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
                    if (event['trangThai'] == 'choPheDuyet') ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _rejectEvent(event);
                          },
                          icon: const Icon(Icons.close, color: Colors.red),
                          label: const Text(
                            'Từ chối',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeLarge,
                              color: Colors.red,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _approveEvent(event);
                          },
                          icon: const Icon(Icons.check),
                          label: const Text(
                            'Duyệt',
                            style: TextStyle(fontSize: AppConstants.fontSizeLarge),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
                          ),
                        ),
                      ),
                    ] else ...[
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
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

  void _approveEvent(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận duyệt sự kiện'),
        content: Text('Bạn có chắc chắn muốn duyệt sự kiện "${event['ten']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                event['trangThai'] = 'daDuyet';
              });
              Navigator.pop(context);
              _showSuccessDialog('Đã duyệt sự kiện "${event['ten']}"');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Duyệt', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _rejectEvent(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Từ chối sự kiện'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Bạn có chắc chắn muốn từ chối sự kiện "${event['ten']}"?'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Lý do từ chối',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                event['trangThai'] = 'daHuy';
              });
              Navigator.pop(context);
              _showSuccessDialog('Đã từ chối sự kiện "${event['ten']}"');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Từ chối', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Thành công'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }


} 