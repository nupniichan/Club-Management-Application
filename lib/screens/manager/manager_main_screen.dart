import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import 'manager_dashboard_screen.dart';
import 'manager_settings_screen.dart';
import '../../widgets/manager/manager_drawer_widget.dart';
import '../../widgets/manager/manager_app_bar_widget.dart';

class ManagerMainScreen extends StatefulWidget {
  final String userName;
  final String userRole;

  const ManagerMainScreen({
    super.key,
    required this.userName,
    required this.userRole,
  });

  @override
  State<ManagerMainScreen> createState() => _ManagerMainScreenState();
}

class _ManagerMainScreenState extends State<ManagerMainScreen> {
  int _selectedIndex = 0;
  String _currentTitle = 'Dashboard';

  final List<Widget> _screens = [
    const ManagerDashboardScreen(),
    const ManagerSettingsScreen(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Cài đặt',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ManagerAppBarWidget(title: _currentTitle),
      drawer: ManagerDrawerWidget(
        currentPage: 'dashboard',
        userName: widget.userName,
        userRole: widget.userRole,
      ),
      body: _screens[_selectedIndex],
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
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }


} 