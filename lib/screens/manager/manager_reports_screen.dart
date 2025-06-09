// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/manager/manager_drawer_widget.dart';
import '../../widgets/manager/manager_app_bar_widget.dart';
import '../../models/report.dart';
import '../../services/report_data_service.dart';

class ManagerReportsScreen extends StatefulWidget {
  const ManagerReportsScreen({super.key});

  @override
  State<ManagerReportsScreen> createState() => _ManagerReportsScreenState();
}

class _ManagerReportsScreenState extends State<ManagerReportsScreen> {
  int _selectedIndex = 0;

  final ReportDataService _reportService = ReportDataService();
  List<Report> _reports = [];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    setState(() {
      _reports = _reportService.getAllManagerReports();
    });
  }

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

  Widget _buildReportCard(Report report) {
    
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
                        report.tenBaoCao[0].toUpperCase(),
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
                          report.tenBaoCao,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${report.id.substring(0, 8)} • CLB: ${report.club.substring(0, 8)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${report.nhanSuPhuTrach} • ${_formatDate(report.ngayBaoCao)}',
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
                                _formatDate(report.ngayBaoCao),
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
                                '${report.danhSachSuKien.length}',
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
                report.ketQuaDatDuoc,
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

  void _viewReport(Report report) {
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
                  color: Colors.blue.withAlpha((0.1 * 255).round()),
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
                        color: Colors.blue.withAlpha(51),
                      ),
                      child: Center(
                        child: Text(
                          report.tenBaoCao[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.blue,
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
                            report.tenBaoCao,
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
                              color: Colors.blue.withAlpha(51),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _formatDate(report.ngayBaoCao),
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeSmall,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
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
                      _buildReportDetailRow(
                        Icons.description, 
                        'Tên báo cáo', 
                        report.tenBaoCao
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      Row(
                        children: [
                          Expanded(
                            child: _buildReportDetailRow(
                              Icons.calendar_today, 
                              'Ngày báo cáo', 
                              _formatDate(report.ngayBaoCao)
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingSmall),
                          Expanded(
                            child: _buildReportDetailRow(
                              Icons.attach_money, 
                              'Chi tiêu', 
                              _formatCurrency(report.tongNganSachChiTieu)
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      Row(
                        children: [
                          Expanded(
                            child: _buildReportDetailRow(
                              Icons.person, 
                              'Nhân sự phụ trách', 
                              report.nhanSuPhuTrach
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingSmall),
                          Expanded(
                            child: _buildReportDetailRow(
                              Icons.account_balance_wallet, 
                              'Tổng thu', 
                              _formatCurrency(report.tongThu)
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      Row(
                        children: [
                          Expanded(
                            child: _buildReportDetailRow(
                              Icons.event, 
                              'Số sự kiện', 
                              '${report.danhSachSuKien.length} sự kiện'
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingSmall),
                          Expanded(
                            child: _buildReportDetailRow(
                              Icons.star, 
                              'Số giải thưởng', 
                              '${report.danhSachGiai.length} giải thưởng'
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppConstants.paddingMedium),
                      const Text(
                        'Kết quả đạt được',
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
                          report.ketQuaDatDuoc,
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeMedium,
                            height: 1.5,
                          ),
                        ),
                      ),
                      
                      if (report.danhSachSuKien.isNotEmpty) ...[
                        const SizedBox(height: AppConstants.paddingMedium),
                        const Text(
                          'Danh sách sự kiện',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeLarge,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        ...report.danhSachSuKien.map<Widget>((event) => Container(
                          margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
                          padding: const EdgeInsets.all(AppConstants.paddingMedium),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                            border: Border.all(color: Colors.blue.withOpacity(0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.ten,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppConstants.fontSizeMedium,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('Người phụ trách: ${event.nguoiPhuTrach}'),
                              Text('Ngày: ${_formatDate(event.ngayToChuc)}'),
                              Text('Địa điểm: ${event.diaDiem}'),
                            ],
                          ),
                        )),
                      ],
                      
                      if (report.danhSachGiai.isNotEmpty) ...[
                        const SizedBox(height: AppConstants.paddingMedium),
                        const Text(
                          'Danh sách giải thưởng',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeLarge,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        ...report.danhSachGiai.map<Widget>((award) => Container(
                          margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
                          padding: const EdgeInsets.all(AppConstants.paddingMedium),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                            border: Border.all(color: Colors.amber.withOpacity(0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                award.tenGiai,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppConstants.fontSizeMedium,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('Loại giải: ${award.loaiGiai}'),
                              Text('Ngày đạt giải: ${_formatDate(award.ngayDatGiai)}'),
                              Text('Thành viên: ${award.thanhVienDatGiai}'),
                            ],
                          ),
                        )),
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
      ),
    );
  }

  Widget _buildReportDetailRow(IconData icon, String label, String value) {
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
}
