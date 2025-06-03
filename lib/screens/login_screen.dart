import 'package:flutter/material.dart';
import 'student/student_dashboard_screen.dart';
import 'manager/manager_main_screen.dart';
import '../services/auth_service.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_text_field.dart';
import '../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  
  List<Map<String, String>> _accountsList = [];
  String? _selectedEmail;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _accountsList = _authService.getSampleAccounts();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }
  
  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final result = await _authService.login(email, password);

      if (!mounted) return;

      if (result.isSuccess && result.user != null) {
        if (result.user!.role == AppConstants.roleManager) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ManagerMainScreen(
                userName: result.user!.name,
                userRole: result.user!.role,
              ),
            ),
          );        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(
                userName: result.user!.name,
                userRole: result.user!.role,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? AppConstants.unknownErrorMessage),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });    }
  }
  
  void _onAccountSelected(String? email) {
    setState(() {
      _selectedEmail = email;
      _emailController.text = email ?? '';
      
      if (email != null) {
        final selectedAccount = _accountsList.firstWhere(
          (account) => account['email'] == email,
          orElse: () => {'password': ''},
        );
        _passwordController.text = selectedAccount['password'] ?? '';
      } else {
        _passwordController.text = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E3A8A), // Deep blue (academic)
              Color(0xFF3B82F6), // Bright blue
              Color(0xFF6366F1), // Indigo
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background decorative elements
              Positioned(
                top: 50,
                right: -20,
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(
                    Icons.school,
                    size: 120,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                left: -30,
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(
                    Icons.menu_book,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 200,
                left: 50,
                child: Opacity(
                  opacity: 0.05,
                  child: Icon(
                    Icons.groups,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
              
              // Main content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // School-themed header
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                // Logo with academic theme
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: const Image(
                                      image: AssetImage('assets/logos/logo-removebg.png'),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // School name and title
                                const Text(
                                  'Trường THPT',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'HỆ THỐNG QUẢN LÝ CÂU LẠC BỘ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Welcome message
                          const Text(
                            'Chào mừng trở lại!',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Đăng nhập để quản lý các hoạt động câu lạc bộ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Login form
                          Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 25,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Account selection
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.people_alt,
                                            size: 16,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Chọn tài khoản mẫu (tùy chọn)',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.grey.shade300),
                                          color: Colors.grey.shade50,
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: _selectedEmail,
                                            hint: Row(
                                              children: [
                                                Icon(
                                                  Icons.account_circle,
                                                  size: 20,
                                                  color: Colors.grey[600],
                                                ),
                                                const SizedBox(width: 8),
                                                const Text('Chọn tài khoản demo'),
                                              ],
                                            ),
                                            items: [
                                              const DropdownMenuItem<String>(
                                                value: null,
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.clear, size: 16),
                                                    SizedBox(width: 8),
                                                    Text('-- Nhập thủ công --'),
                                                  ],
                                                ),
                                              ),
                                              ..._accountsList.map((account) => DropdownMenuItem<String>(
                                                value: account['email'],
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      account['role'] == 'Manager' 
                                                          ? Icons.admin_panel_settings 
                                                          : Icons.school,
                                                      size: 16,
                                                      color: account['role'] == 'Manager'
                                                          ? Colors.orange
                                                          : Colors.blue,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        '${account['title']}',
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                            ],
                                            onChanged: _onAccountSelected,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      CustomTextField(
                                        label: 'Email',
                                        hintText: 'Nhập email của bạn',
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        validator: Validators.validateEmail,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppConstants.paddingLarge),

                                  CustomTextField(
                                    label: 'Mật khẩu',
                                    hintText: 'Nhập mật khẩu',
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    validator: Validators.validatePassword,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 32),

                                  // Login button
                                  SizedBox(
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _login,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF1E3A8A),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        elevation: 3,
                                        shadowColor: const Color(0xFF1E3A8A).withOpacity(0.3),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.login, size: 20),
                                                SizedBox(width: 8),
                                                Text(
                                                  'ĐĂNG NHẬP HỆ THỐNG',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Sample accounts button
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: TextButton.icon(
                              onPressed: () {
                                _showSampleAccounts();
                              },
                              icon: const Icon(
                                Icons.info_outline,
                                color: Colors.white,
                                size: 18,
                              ),
                              label: const Text(
                                'Xem danh sách tài khoản demo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSampleAccounts() {
    final sampleAccounts = _authService.getSampleAccounts();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Color(0xFF1E3A8A),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Tài khoản Demo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                ),
              ],
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: sampleAccounts.map((account) {
                final isManager = account['role'] == 'Manager';
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isManager
                          ? [Colors.orange.shade50, Colors.orange.shade100]
                          : [Colors.blue.shade50, Colors.blue.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isManager ? Colors.orange.shade200 : Colors.blue.shade200,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isManager ? Icons.admin_panel_settings : Icons.school,
                            color: isManager ? Colors.orange.shade700 : Colors.blue.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              account['title']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isManager ? Colors.orange.shade800 : Colors.blue.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildAccountInfoRow(Icons.email, account['email']!),
                      const SizedBox(height: 4),
                      _buildAccountInfoRow(Icons.lock, account['password']!),
                      const SizedBox(height: 4),
                      _buildAccountInfoRow(Icons.person, account['role']!),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Đóng',
                style: TextStyle(
                  color: Color(0xFF1E3A8A),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAccountInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
} 