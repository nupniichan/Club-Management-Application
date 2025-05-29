# 📚 Ứng Dụng Quản Lý Câu Lạc Bộ

Ứng dụng Flutter để quản lý câu lạc bộ với giao diện đăng nhập đẹp và cấu trúc code được tổ chức chuyên nghiệp.

## 🏗️ Cấu Trúc Thư Mục

```
lib/
├── main.dart                 # Entry point của ứng dụng
├── constants/               # Các hằng số và cấu hình
│   └── app_constants.dart   # Màu sắc, kích thước, theme
├── models/                  # Data models
│   └── user.dart           # Model User
├── screens/                 # Các màn hình UI
│   ├── login_screen.dart   # Màn hình đăng nhập
│   └── student_dashboard_screen.dart # Màn hình chính
├── services/               # Business logic và API
│   └── auth_service.dart   # Service xử lý đăng nhập
├── utils/                  # Utility functions
│   └── validators.dart     # Validation functions
└── widgets/                # Reusable UI components
    └── custom_text_field.dart # Custom text field widget
```

## 👥 Tài Khoản Mẫu

### Quản Lý
- **Email:** `quanly@club.com`
- **Mật khẩu:** `123456`
- **Quyền:** Toàn quyền

### Học Sinh
- **Email:** `hocsinh@club.com`
- **Mật khẩu:** `123456`
- **Quyền:** Xem thành viên, xem hoạt động

## 🛠️ Cài Đặt và Chạy

### Yêu Cầu
- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)


## 🏛️ Kiến Trúc Code

### 📁 Constants
- `AppConstants`: Chứa tất cả hằng số (màu sắc, kích thước, text)
- `AppTheme`: Cấu hình theme cho toàn ứng dụng

### 📁 Models
- `User`: Model đại diện cho người dùng
- Hỗ trợ JSON serialization/deserialization
- Có các method tiện ích như `copyWith`, `toString`

### 📁 Services
- `AuthService`: Singleton service xử lý authentication
- `AuthResult`: Class trả về kết quả đăng nhập
- Hỗ trợ permission checking

### 📁 Utils
- `Validators`: Các function validation cho form
- Hỗ trợ validation email, password, tên, số điện thoại, v.v.

### 📁 Widgets
- `CustomTextField`: Text field tùy chỉnh với styling thống nhất
- Có thể mở rộng thêm các widget khác

### 📁 Screens
- `LoginScreen`: Màn hình đăng nhập
- `DashboardScreen`: Màn hình chính
- Mỗi screen tập trung vào UI và gọi service để xử lý logic

## 🎨 Design System ( sẽ có thay đổi sau )

### Màu Sắc
- **Primary:** Blue
- **Error:** Red
- **Success:** Green
- **Warning:** Orange

### Typography
- **Title:** 32px
- **Large:** 16px
- **Medium:** 14px
- **Small:** 12px

### Spacing
- **Small:** 8px
- **Medium:** 16px
- **Large:** 24px
- **XLarge:** 32px