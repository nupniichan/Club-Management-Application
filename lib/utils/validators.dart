import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }

    if (value.length > AppConstants.maxEmailLength) {
      return 'Email quá dài (tối đa ${AppConstants.maxEmailLength} ký tự)';
    }

    // Basic email regex pattern
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Mật khẩu phải có ít nhất ${AppConstants.minPasswordLength} ký tự';
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'Mật khẩu quá dài (tối đa ${AppConstants.maxPasswordLength} ký tự)';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên';
    }

    if (value.trim().isEmpty) {
      return 'Tên không được chỉ chứa khoảng trắng';
    }

    if (value.length > AppConstants.maxNameLength) {
      return 'Tên quá dài (tối đa ${AppConstants.maxNameLength} ký tự)';
    }

    // Check if name contains only letters, spaces, and Vietnamese characters
    final nameRegex = RegExp(r'^[a-zA-ZÀ-ỹ\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'Tên chỉ được chứa chữ cái và khoảng trắng';
    }

    return null;
  }

  // Phone number validation
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }

    // Remove all spaces and special characters
    final cleanedValue = value.replaceAll(RegExp(r'[^\d]'), '');

    // Vietnamese phone number patterns
    final phoneRegex = RegExp(r'^(0[3|5|7|8|9])[0-9]{8}$');
    if (!phoneRegex.hasMatch(cleanedValue)) {
      return 'Số điện thoại không hợp lệ';
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập $fieldName';
    }

    if (value.trim().isEmpty) {
      return '$fieldName không được chỉ chứa khoảng trắng';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }

    if (value != password) {
      return 'Mật khẩu xác nhận không khớp';
    }

    return null;
  }

  // Age validation
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tuổi';
    }

    final age = int.tryParse(value);
    if (age == null) {
      return 'Tuổi phải là số';
    }

    if (age < 1 || age > 120) {
      return 'Tuổi phải từ 1 đến 120';
    }

    return null;
  }

  // Student ID validation
  static String? validateStudentId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mã sinh viên';
    }

    // Assuming student ID format: 8-10 digits
    final studentIdRegex = RegExp(r'^\d{8,10}$');
    if (!studentIdRegex.hasMatch(value)) {
      return 'Mã sinh viên phải có 8-10 chữ số';
    }

    return null;
  }

  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'
    );

    if (!urlRegex.hasMatch(value)) {
      return 'URL không hợp lệ';
    }

    return null;
  }

  // Date validation (for activities, events)
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return 'Vui lòng chọn ngày';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(value.year, value.month, value.day);

    if (selectedDate.isBefore(today)) {
      return 'Ngày không được là ngày trong quá khứ';
    }

    return null;
  }

  // Time validation
  static String? validateTime(TimeOfDay? value) {
    if (value == null) {
      return 'Vui lòng chọn giờ';
    }

    return null;
  }

  // Custom validation for specific business rules
  static String? validateClubName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên câu lạc bộ';
    }

    if (value.length < 3) {
      return 'Tên câu lạc bộ phải có ít nhất 3 ký tự';
    }

    if (value.length > 100) {
      return 'Tên câu lạc bộ quá dài (tối đa 100 ký tự)';
    }

    return null;
  }
}