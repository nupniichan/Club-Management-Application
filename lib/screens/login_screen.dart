import 'package:flutter/material.dart';
import 'student/dashboard_screen.dart';
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

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final result = await _authService.login(email, password);

      if (!mounted) return; // Check if widget is still mounted

      if (result.isSuccess && result.user != null) {
        // Đăng nhập thành công - điều hướng dựa trên role
        if (result.user!.role == AppConstants.roleManager) {
          // Manager -> ManagerMainScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ManagerMainScreen(
                userName: result.user!.name,
                userRole: result.user!.role,
              ),
            ),
          );        } else {
          // Student -> DashboardScreen
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
        // Đăng nhập thất bại
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? AppConstants.unknownErrorMessage),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2196F3), // Blue
              Color(0xFF1976D2), // Darker blue
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo hoặc Icon ứng dụng
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 60,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingXLarge),

                  // Tiêu đề
                  const Text(
                    'Chào mừng trở lại!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  const Text(
                    'Đăng nhập để quản lý câu lạc bộ',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingXLarge),

                  // Form đăng nhập
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Email field
                          CustomTextField(
                            label: 'Email',
                            hintText: 'Nhập email của bạn',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.validateEmail,
                          ),
                          const SizedBox(height: AppConstants.paddingLarge),

                          // Password field
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
                          const SizedBox(height: AppConstants.paddingXLarge),

                          // Login button
                          SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                                ),
                                elevation: 2,
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
                                  : const Text(
                                      'ĐĂNG NHẬP',
                                      style: TextStyle(
                                        fontSize: AppConstants.fontSizeLarge,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),

                  // Tài khoản mẫu button
                  TextButton.icon(
                    onPressed: () {
                      _showSampleAccounts();
                    },
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.white70,
                      size: 20,
                    ),
                    label: const Text(
                      'Xem tài khoản mẫu',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: AppConstants.fontSizeMedium,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          title: Row(
            children: [
              Icon(
                Icons.account_circle,
                color: AppConstants.primaryColor,
                size: 28,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              const Text(
                'Tài khoản mẫu',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: sampleAccounts.map((account) {
              return Container(
                margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppConstants.fontSizeMedium,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Row(
                      children: [
                        const Icon(Icons.email, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            account['email']!,
                            style: const TextStyle(fontSize: AppConstants.fontSizeSmall),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.lock, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          account['password']!,
                          style: const TextStyle(fontSize: AppConstants.fontSizeSmall),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          account['role']!,
                          style: const TextStyle(fontSize: AppConstants.fontSizeSmall),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Đóng',
                style: TextStyle(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
} 