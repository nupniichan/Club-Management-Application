import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class StudentEditMemberScreen extends StatefulWidget {
  final Map<String, dynamic> member;
  final Function(Map<String, dynamic>) onMemberUpdated;

  const StudentEditMemberScreen({
    super.key, 
    required this.member,
    required this.onMemberUpdated,
  });

  @override
  State<StudentEditMemberScreen> createState() => _StudentEditMemberScreenState();
}

class _StudentEditMemberScreenState extends State<StudentEditMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController idController;
  late final TextEditingController classController;
  late String gender;
  late String role;

  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị từ dữ liệu thành viên được truyền vào
    nameController = TextEditingController(text: widget.member['name']);
    idController = TextEditingController(text: widget.member['id']);
    classController = TextEditingController(text: widget.member['class']);
    gender = widget.member['gender'];
    role = widget.member['role'];
  }

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
        title: const Text('Chỉnh sửa thông tin thành viên'),
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
                  readOnly: true, // Không cho phép sửa mã số
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
                  onPressed: _updateMember,
                  icon: const Icon(Icons.save),
                  label: const Text('Lưu thay đổi'),
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
  
  void _updateMember() {
    if (_formKey.currentState!.validate()) {
      // Tạo đối tượng thành viên đã cập nhật
      final updatedMember = {
        'id': idController.text,
        'name': nameController.text,
        'gender': gender,
        'class': classController.text,
        'role': role,
      };
      
      // Truyền thành viên đã cập nhật về màn hình chính
      widget.onMemberUpdated(updatedMember);
      
      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã cập nhật thông tin thành viên'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Quay lại màn hình danh sách
      Navigator.of(context).pop();
    }
  }
}
