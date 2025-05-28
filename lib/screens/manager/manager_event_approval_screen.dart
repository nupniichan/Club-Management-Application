import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/auth_service.dart';
import '../login_screen.dart';
import '../../widgets/manager/manager_drawer_widget.dart';

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

  // Sample event data
  final List<Map<String, dynamic>> _events = [
    {
      'id': 1,
      'title': 'Giải bóng đá liên trường',
      'description': 'Giải đấu bóng đá thường niên giữa các trường',
      'club': 'Câu lạc bộ Bóng đá',
      'date': '25/02/2024',
      'time': '14:00',
      'location': 'Sân bóng trường',
      'status': 'Chờ duyệt',
      'participants': 50,
      'budget': '5,000,000 VNĐ',
      'submittedDate': '15/02/2024',
    },
    {
      'id': 2,
      'title': 'Đêm nhạc acoustic',
      'description': 'Buổi biểu diễn âm nhạc acoustic của CLB',
      'club': 'Câu lạc bộ Âm nhạc',
      'date': '20/02/2024',
      'time': '19:00',
      'location': 'Hội trường A',
      'status': 'Đã duyệt',
      'participants': 30,
      'budget': '2,000,000 VNĐ',
      'submittedDate': '10/02/2024',
    },
    {
      'id': 3,
      'title': 'Workshop lập trình AI',
      'description': 'Hội thảo về trí tuệ nhân tạo và machine learning',
      'club': 'Câu lạc bộ Tin học',
      'date': '28/02/2024',
      'time': '09:00',
      'location': 'Phòng máy tính 1',
      'status': 'Chờ duyệt',
      'participants': 25,
      'budget': '1,500,000 VNĐ',
      'submittedDate': '18/02/2024',
    },
    {
      'id': 4,
      'title': 'Triển lãm tranh sinh viên',
      'description': 'Triển lãm các tác phẩm nghệ thuật của sinh viên',
      'club': 'Câu lạc bộ Mỹ thuật',
      'date': '15/02/2024',
      'time': '08:00',
      'location': 'Thư viện trường',
      'status': 'Đã duyệt',
      'participants': 40,
      'budget': '3,000,000 VNĐ',
      'submittedDate': '05/02/2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTitle),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
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
        filteredEvents = _events.where((event) => event['status'] == 'Chờ duyệt').toList();
        break;
      case 2:
        filteredEvents = _events.where((event) => event['status'] == 'Đã duyệt').toList();
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
                  '${_events.where((e) => e['status'] == 'Chờ duyệt').length}',
                  Icons.pending,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: _buildStatsCard(
                  'Đã duyệt',
                  '${_events.where((e) => e['status'] == 'Đã duyệt').length}',
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

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    event['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppConstants.fontSizeLarge,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: event['status'] == 'Đã duyệt' ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    event['status'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            
            Text(
              event['description'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: AppConstants.fontSizeMedium,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            
            Row(
              children: [
                Icon(Icons.business, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(event['club']),
              ],
            ),
            const SizedBox(height: 4),
            
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${event['date']} - ${event['time']}'),
                const SizedBox(width: AppConstants.paddingMedium),
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(event['location']),
              ],
            ),
            const SizedBox(height: 4),
            
            Row(
              children: [
                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${event['participants']} người tham gia'),
                const SizedBox(width: AppConstants.paddingMedium),
                Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(event['budget']),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nộp ngày: ${event['submittedDate']}',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: Colors.grey[500],
                  ),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => _showEventDetails(event),
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('Chi tiết'),
                    ),
                    if (event['status'] == 'Chờ duyệt') ...[
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () => _approveEvent(event),
                        icon: const Icon(Icons.check, size: 16),
                        label: const Text('Duyệt'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(80, 32),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () => _rejectEvent(event),
                        icon: const Icon(Icons.close, size: 16),
                        label: const Text('Từ chối'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(80, 32),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEventDetails(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event['title']),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mô tả: ${event['description']}'),
              const SizedBox(height: 8),
              Text('Câu lạc bộ: ${event['club']}'),
              const SizedBox(height: 8),
              Text('Ngày: ${event['date']}'),
              const SizedBox(height: 8),
              Text('Thời gian: ${event['time']}'),
              const SizedBox(height: 8),
              Text('Địa điểm: ${event['location']}'),
              const SizedBox(height: 8),
              Text('Số người tham gia: ${event['participants']}'),
              const SizedBox(height: 8),
              Text('Ngân sách: ${event['budget']}'),
              const SizedBox(height: 8),
              Text('Trạng thái: ${event['status']}'),
              const SizedBox(height: 8),
              Text('Ngày nộp: ${event['submittedDate']}'),
            ],
          ),
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

  void _approveEvent(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận duyệt sự kiện'),
        content: Text('Bạn có chắc chắn muốn duyệt sự kiện "${event['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                event['status'] = 'Đã duyệt';
              });
              Navigator.pop(context);
              _showSuccessDialog('Đã duyệt sự kiện "${event['title']}"');
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
            Text('Bạn có chắc chắn muốn từ chối sự kiện "${event['title']}"?'),
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
                event['status'] = 'Từ chối';
              });
              Navigator.pop(context);
              _showSuccessDialog('Đã từ chối sự kiện "${event['title']}"');
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

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.notifications, color: AppConstants.primaryColor),
            const SizedBox(width: AppConstants.paddingSmall),
            const Text('Thông báo'),
          ],
        ),
        content: const Text('Chưa có thông báo mới.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        title: Row(
          children: [
            Icon(
              Icons.logout,
              color: AppConstants.warningColor,
              size: 28,
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            const Text(
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
          style: TextStyle(fontSize: AppConstants.fontSizeMedium),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Hủy',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
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
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
} 