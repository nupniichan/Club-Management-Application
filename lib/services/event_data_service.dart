import '../models/event.dart';

class EventDataService {
  static final EventDataService _instance = EventDataService._internal();
  factory EventDataService() => _instance;
  EventDataService._internal();

  final List<Event> _events = [
    Event(
      id: '673c5d577f6aae48b37a856b',
      ten: 'IT Day',
      ngayToChuc: '2024-11-22',
      thoiGianBatDau: '12:00',
      thoiGianKetThuc: '15:00',
      diaDiem: 'Sân trường',
      noiDung: 'Sự kiện IT Day được tổ chức nhằm giới thiệu cho mọi người về thế giới công nghệ thông tin',
      nguoiPhuTrach: 'Nguyễn Phi Quốc Bảo',
      khachMoi: ['Doanh nghiệp MemoryZone', 'Doanh nghiệp máy tính AnPhat'],
      club: '67160c5ad55fc5f816de7644',
      trangThai: 'daDuyet',
    ),
    Event(
      id: '673c5d577f6aae48b37a856c',
      ten: 'Hackathon X',
      ngayToChuc: '2024-12-15',
      thoiGianBatDau: '08:00',
      thoiGianKetThuc: '18:00',
      diaDiem: 'Phòng máy tính A101',
      noiDung: 'Cuộc thi lập trình 24h dành cho sinh viên đam mê coding',
      nguoiPhuTrach: 'Trần Văn B',
      khachMoi: ['Công ty FPT Software', 'Công ty TMA Solutions'],
      club: '67160c5ad55fc5f816de7644',
      trangThai: 'choPheDuyet',
    ),
    Event(
      id: '673c5d577f6aae48b37a856d',
      ten: 'Workshop AI',
      ngayToChuc: '2024-10-30',
      thoiGianBatDau: '14:00',
      thoiGianKetThuc: '17:00',
      diaDiem: 'Hội trường lớn',
      noiDung: 'Workshop về trí tuệ nhân tạo và machine learning cơ bản',
      nguoiPhuTrach: 'Lê Thị C',
      khachMoi: ['Tiến sĩ Nguyễn Văn A', 'Chuyên gia AI Google'],
      club: '67160c5ad55fc5f816de7644',
      trangThai: 'hoanThanh',
    ),
  ];

  List<Event> getAllEvents() => List.from(_events);

  Event? getEventById(String id) {
    try {
      return _events.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Event> getEventsByClub(String clubId) {
    return _events.where((event) => event.club == clubId).toList();
  }

  List<Event> getEventsByStatus(String status) {
    return _events.where((event) => event.trangThai == status).toList();
  }

  List<Event> getEventsByDateRange(DateTime startDate, DateTime endDate) {
    return _events.where((event) {
      final eventDate = DateTime.parse(event.ngayToChuc);
      return eventDate.isAfter(startDate.subtract(Duration(days: 1))) &&
             eventDate.isBefore(endDate.add(Duration(days: 1)));
    }).toList();
  }

  void addEvent(Event event) {
    _events.add(event);
  }

  void updateEvent(Event updatedEvent) {
    final index = _events.indexWhere((event) => event.id == updatedEvent.id);
    if (index != -1) {
      _events[index] = updatedEvent;
    }
  }

  void deleteEvent(String id) {
    _events.removeWhere((event) => event.id == id);
  }

  List<Event> searchEvents(String query) {
    if (query.isEmpty) return getAllEvents();
    
    final lowerQuery = query.toLowerCase();
    return _events.where((event) =>
      event.ten.toLowerCase().contains(lowerQuery) ||
      event.nguoiPhuTrach.toLowerCase().contains(lowerQuery) ||
      event.diaDiem.toLowerCase().contains(lowerQuery) ||
      event.noiDung.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  List<Event> filterEvents({String? status, String? club}) {
    var filtered = getAllEvents();
    
    if (status != null && status != 'Tất cả') {
      filtered = filtered.where((event) => event.trangThai == status).toList();
    }
    
    if (club != null && club != 'Tất cả') {
      filtered = filtered.where((event) => event.club == club).toList();
    }
    
    return filtered;
  }
} 