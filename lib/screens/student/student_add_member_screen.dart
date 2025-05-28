import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class StudentAddMemberScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onMemberAdded;

  const StudentAddMemberScreen({
    super.key, 
    required this.onMemberAdded,
  });

  @override
  State<StudentAddMemberScreen> createState() => _StudentAddMemberScreenState();
}

class _StudentAddMemberScreenState extends State<StudentAddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final classController = TextEditingController();
  String gender = 'Nam';
  String role = 'THÀNH VIÊN';

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    classController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm thành viên mới'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Biểu mẫu nhập thông tin
                TextFormField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: 'Mã số học sinh',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mã số học sinh';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Họ tên',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập họ tên';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                
                DropdownButtonFormField<String>(
                  value: gender,
                  decoration: const InputDecoration(
                    labelText: 'Giới tính',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.wc),
                  ),
                  items: ['Nam', 'Nữ'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      gender = newValue!;
                    });
                  },
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                
                TextFormField(
                  controller: classController,
                  decoration: const InputDecoration(
                    labelText: 'Lớp',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.class_),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập lớp';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                
                DropdownButtonFormField<String>(
                  value: role,
                  decoration: const InputDecoration(
                    labelText: 'Chức vụ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.work),
                  ),
                  items: ['THÀNH VIÊN', 'PHÓ CÂU LẠC BỘ', 'CHỦ NHIỆM'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      role = newValue!;
                    });
                  },
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                
                // Nút lưu thông tin
                FilledButton.icon(
                  onPressed: _saveMember,
                  icon: const Icon(Icons.save),
                  label: const Text('Lưu thông tin'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  ),
                ),
                
                const SizedBox(height: AppConstants.paddingMedium),
                
                // Nút hủy
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.cancel),
                  label: const Text('Hủy'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _saveMember() {
    if (_formKey.currentState!.validate()) {
      // Tạo đối tượng thành viên mới
      final newMember = {
        'id': idController.text,
        'name': nameController.text,
        'gender': gender,
        'class': classController.text,
        'role': role,
      };
      
      // Truyền thành viên mới về màn hình chính
      widget.onMemberAdded(newMember);
      
      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã thêm thành viên mới'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Quay lại màn hình danh sách
      Navigator.of(context).pop();
    }
  }
}
