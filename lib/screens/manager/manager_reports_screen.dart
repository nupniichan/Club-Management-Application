// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/manager/manager_drawer_widget.dart';
import '../../widgets/manager/manager_app_bar_widget.dart';

class ManagerReportsScreen extends StatefulWidget {
  const ManagerReportsScreen({super.key});

  @override
  State<ManagerReportsScreen> createState() => _ManagerReportsScreenState();
}

class _ManagerReportsScreenState extends State<ManagerReportsScreen> {
  int _selectedIndex = 0;

  // Updated reports data based on MongoDB structure
  final List<Map<String, dynamic>> _reports = [
    {
      '_id': '673c6cb889b097623521cf58',
      'tenBaoCao': 'Báo cáo tháng 11',
      'ngayBaoCao': '2024-11-19T00:00:00.000Z',
      'nhanSuPhuTrach': 'Nguyễn Phi Quốc Bảo',
      'danhSachSuKien': [
        {
          'ten': 'IT Day',
          'nguoiPhuTrach': 'Nguyễn Phi Quốc Bảo',
          'ngayToChuc': '2024-11-22T00:00:00.000Z',
          'diaDiem': 'Sân trường',
        }
      ],
      'danhSachGiai': [
        {
          'tenGiai': 'Giải Nhất Lập trình',
          'loaiGiai': 'Cấp trường',
          'ngayDatGiai': '2024-11-20T00:00:00.000Z',
          'thanhVienDatGiai': 'Trần Văn A',
        }
      ],
      'tongNganSachChiTieu': 4000000,
      'tongThu': 5000000,
      'ketQuaDatDuoc': 'Sự kiện diễn ra hơn cả mong đợi, các doanh nghiệp muốn hợp tác với câu lạc bộ trong tương lai',
      'club': '67160c5ad55fc5f816de7644',
    },
    {
      '_id': '673c6cb889b097623521cf59',
      'tenBaoCao': 'Báo cáo tháng 10',
      'ngayBaoCao': '2024-10-25T00:00:00.000Z',
      'nhanSuPhuTrach': 'Trần Văn B',
      'danhSachSuKien': [
        {
          'ten': 'Workshop Lập trình Web',
          'nguoiPhuTrach': 'Trần Văn A',
          'ngayToChuc': '2024-10-20T00:00:00.000Z',
          'diaDiem': 'Phòng Lab A',
        }
      ],
      'danhSachGiai': [],
      'tongNganSachChiTieu': 2000000,
      'tongThu': 1500000,
      'ketQuaDatDuoc': 'Workshop được tổ chức thành công với sự tham gia đông đảo của sinh viên',
      'club': '67160c5ad55fc5f816de7644',
    },
    {
      '_id': '673c6cb889b097623521cf60',
      'tenBaoCao': 'Báo cáo tháng 9',
      'ngayBaoCao': '2024-09-28T00:00:00.000Z',
      'nhanSuPhuTrach': 'Lê Thị C',
      'danhSachSuKien': [
        {
          'ten': 'Buổi biểu diễn âm nhạc',
          'nguoiPhuTrach': 'Lê Thị B',
          'ngayToChuc': '2024-09-25T00:00:00.000Z',
          'diaDiem': 'Hội trường chính',
        }
      ],
      'danhSachGiai': [
        {
          'tenGiai': 'Giải Ba Ca hát',
          'loaiGiai': 'Cấp trường',
          'ngayDatGiai': '2024-09-26T00:00:00.000Z',
          'thanhVienDatGiai': 'Nguyễn Thị D',
        }
      ],
      'tongNganSachChiTieu': 1500000,
      'tongThu': 2000000,
      'ketQuaDatDuoc': 'Buổi biểu diễn thu hút được nhiều khán giả và nhận được phản hồi tích cực',
      'club': '67160c5ad55fc5f816de7645',
    },
  ];

  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ManagerAppBarWidget(title: 'Báo cáo câu lạc bộ'),
      drawer: const ManagerDrawerWidget(
        currentPage: 'reports',
        userName: 'Nguyễn Phi Quốc Bảo',
        userRole: 'Quản lý',
      ),
      body:
          _selectedIndex == 0
              ? _buildReportList(context)
              : _buildSearchPage(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Danh sách',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
        ],
      ),
    );
  }

  String _formatDate(String isoDateString) {
    final date = DateTime.parse(isoDateString);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatCurrency(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M VNĐ';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K VNĐ';
    } else {
      return '${amount} VNĐ';
    }
  }

  Widget _buildReportList(BuildContext context) {
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
                  Icons.analytics,
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
                      'Báo cáo hoạt động',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    Text(
                      'Tổng số: ${_reports.length} báo cáo',
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
                  '${_reports.length}',
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
          child: _reports.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Chưa có báo cáo nào',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Báo cáo sẽ hiển thị ở đây',
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
                  itemCount: _reports.length,
                  itemBuilder: (context, index) => _buildReportCard(_reports[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    
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
              Colors.blue.withOpacity(0.03),
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
                          Colors.blue,
                          Colors.blue.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        report['tenBaoCao'][0].toUpperCase(),
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
                          report['tenBaoCao'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${report['_id'].substring(0, 8)} • CLB: ${report['club'].substring(0, 8)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${report['nhanSuPhuTrach']} • ${_formatDate(report['ngayBaoCao'])}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    'Ngày báo cáo:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(report['ngayBaoCao']),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey[300],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.event,
                                    size: 16,
                                    color: Colors.blue[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Sự kiện:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${report['danhSachSuKien'].length}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
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
              const SizedBox(height: AppConstants.paddingMedium),
              Text(
                report['ketQuaDatDuoc'],
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
                    onPressed: () => _viewReport(report),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('Xem chi tiết'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      side: const BorderSide(color: Colors.blue),
                      foregroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tìm kiếm & Lọc báo cáo',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Tìm kiếm theo tên báo cáo',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {},
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            value: 'Tất cả CLB',
            items: const [
              DropdownMenuItem(value: 'Tất cả CLB', child: Text('Tất cả CLB')),
              DropdownMenuItem(value: 'Tin học', child: Text('Tin học')),
              DropdownMenuItem(value: 'Toán học', child: Text('Toán học')),
            ],
            onChanged: (value) {},
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Row(
            children: [
              Expanded(
                child: TextField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: 'mm/dd/yyyy',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: 'mm/dd/yyyy',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _viewReport(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
            title: Row(
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
                  report['tenBaoCao'][0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report['tenBaoCao'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _formatDate(report['ngayBaoCao']),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Thông tin cơ bản', Colors.lightBlue.shade100),
              _infoRow('Tên báo cáo', report['tenBaoCao']),
              _infoRow('Ngày báo cáo', _formatDate(report['ngayBaoCao'])),
              _infoRow('Nhân sự phụ trách', report['nhanSuPhuTrach']),
                  const SizedBox(height: 16),
              
                  _sectionTitle('Danh sách sự kiện', Colors.lightBlue.shade100),
              if (report['danhSachSuKien'].isNotEmpty) ...[
                  _tableRow([
                    'Tên sự kiện',
                    'Người phụ trách',
                    'Ngày tổ chức',
                    'Địa điểm',
                  ], isHeader: true),
                ...report['danhSachSuKien'].map<Widget>((event) => _tableRow([
                  event['ten'],
                  event['nguoiPhuTrach'],
                  _formatDate(event['ngayToChuc']),
                  event['diaDiem'],
                ])),
              ] else ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Không có sự kiện nào'),
                ),
              ],
                  const SizedBox(height: 16),
              
              _sectionTitle('Danh sách giải thưởng', Colors.purple.shade100),
              if (report['danhSachGiai'].isNotEmpty) ...[
                  _tableRow([
                    'Tên giải thưởng',
                    'Loại giải',
                    'Ngày đạt giải',
                    'Thành viên đạt giải',
                  ], isHeader: true),
                ...report['danhSachGiai'].map<Widget>((award) => _tableRow([
                  award['tenGiai'],
                  award['loaiGiai'],
                  _formatDate(award['ngayDatGiai']),
                  award['thanhVienDatGiai'],
                ])),
              ] else ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Không có giải thưởng nào'),
                ),
              ],
                  const SizedBox(height: 16),
              
                  _sectionTitle('Thông tin tài chính', Colors.green.shade100),
              _infoRow('Tổng ngân sách chi tiêu', _formatCurrency(report['tongNganSachChiTieu'])),
              _infoRow('Tổng thu', _formatCurrency(report['tongThu'])),
                  const SizedBox(height: 16),
              
                  _sectionTitle('Kết quả đạt được', Colors.yellow.shade100),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  report['ketQuaDatDuoc'],
                  style: const TextStyle(height: 1.4),
                ),
                  ),
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

  Widget _sectionTitle(String title, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      color: color,
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _infoRow(String label, String value, {Color? colorValue}) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value, 
              textAlign: TextAlign.right,
              style: TextStyle(
                color: colorValue ?? Colors.black87,
                fontWeight: colorValue != null ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableRow(List<String> cells, {bool isHeader = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
        color: isHeader ? Colors.grey.shade100 : null,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children:
            cells
                .map(
                  (cell) => Expanded(
                    child: Text(
                      cell,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight:
                            isHeader ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }


}
