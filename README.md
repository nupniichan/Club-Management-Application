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
│   └── dashboard_screen.dart # Màn hình chính
├── services/               # Business logic và API
│   └── auth_service.dart   # Service xử lý đăng nhập
├── utils/                  # Utility functions
│   └── validators.dart     # Validation functions
└── widgets/                # Reusable UI components
    └── custom_text_field.dart # Custom text field widget
```

## 🚀 Tính Năng

### ✅ Đã Hoàn Thành
- **Màn hình đăng nhập** với giao diện đẹp (2 cột: form + hình ảnh)
- **Validation** form đăng nhập
- **Tài khoản mẫu** cho testing
- **Màn hình Dashboard** với các chức năng cơ bản
- **Cấu trúc code** được tổ chức chuyên nghiệp
- **Theme** và constants thống nhất

### 🔄 Đang Phát Triển
- Quản lý thành viên
- Quản lý hoạt động
- Báo cáo
- Cài đặt

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

### Các Bước
1. **Clone repository:**
   ```bash
   git clone <repository-url>
   cd club-management-app
   ```

2. **Cài đặt dependencies:**
   ```bash
   flutter pub get
   ```

3. **Chạy ứng dụng:**
   ```bash
   flutter run
   ```

## 📱 Hướng Dẫn Sử Dụng

1. **Đăng nhập:**
   - Mở ứng dụng
   - Nhấn "Xem tài khoản mẫu" để xem thông tin đăng nhập
   - Nhập email và mật khẩu
   - Nhấn "ĐĂNG NHẬP"

2. **Dashboard:**
   - Xem thông tin người dùng
   - Truy cập các chức năng qua grid menu
   - Đăng xuất bằng nút logout trên AppBar

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

## 🎨 Design System

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

## 🔧 Mở Rộng

### Thêm Screen Mới
1. Tạo file trong `lib/screens/`
2. Import các dependencies cần thiết
3. Sử dụng constants và widgets có sẵn
4. Cập nhật navigation trong các screen khác

### Thêm Model Mới
1. Tạo file trong `lib/models/`
2. Implement `fromMap`, `toMap`, `copyWith`
3. Override `toString`, `==`, `hashCode`

### Thêm Service Mới
1. Tạo file trong `lib/services/`
2. Implement singleton pattern nếu cần
3. Sử dụng models để type safety

### Thêm Widget Mới
1. Tạo file trong `lib/widgets/`
2. Sử dụng constants cho styling
3. Làm cho widget reusable và configurable

## 🐛 Debug và Testing

### Logging
- Sử dụng `print()` hoặc `debugPrint()` cho development
- Có thể thêm logging service sau này

### Error Handling
- Tất cả service calls đều có try-catch
- Error messages được định nghĩa trong constants
- UI hiển thị error thông qua SnackBar

## 📈 Roadmap

### Phase 1 (Hiện tại)
- ✅ Authentication
- ✅ Basic UI structure
- ✅ Code organization

### Phase 2 (Tiếp theo)
- 🔄 Member management
- 🔄 Activity management
- 🔄 Database integration

### Phase 3 (Tương lai)
- 📊 Reports and analytics
- 🔔 Notifications
- 📱 Mobile responsive design

## 🤝 Đóng Góp

1. Fork repository
2. Tạo feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## 📄 License

MIT License - xem file LICENSE để biết thêm chi tiết.

---

**Phát triển bởi:** [Tên của bạn]  
**Phiên bản:** 1.0.0  
**Cập nhật lần cuối:** $(date)
