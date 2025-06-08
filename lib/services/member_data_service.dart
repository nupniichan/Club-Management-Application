import '../models/member.dart';

class MemberDataService {
  static final MemberDataService _instance = MemberDataService._internal();
  factory MemberDataService() => _instance;
  MemberDataService._internal();

  final List<Member> _members = [
    Member(
      id: 'HS24123456',
      name: 'Nguyễn Văn A',
      gender: 'Nam',
      className: '12A16',
      role: 'THÀNH VIÊN',
    ),
    Member(
      id: 'HS24123457',
      name: 'Nguyễn Văn B',
      gender: 'Nam',
      className: '10A11',
      role: 'THÀNH VIÊN',
    ),
    Member(
      id: 'HS24123465',
      name: 'Trần Văn C',
      gender: 'Nam',
      className: '12A7',
      role: 'PHÓ CÂU LẠC BỘ',
    ),
  ];

  List<Member> getAllMembers() => List.from(_members);

  Member? getMemberById(String id) {
    try {
      return _members.firstWhere((member) => member.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Member> getMembersByRole(String role) {
    return _members.where((member) => member.role == role).toList();
  }

  List<Member> getMembersByClass(String className) {
    return _members.where((member) => member.className == className).toList();
  }

  List<Member> getMembersByGender(String gender) {
    return _members.where((member) => member.gender == gender).toList();
  }

  void addMember(Member member) {
    _members.add(member);
  }

  void updateMember(Member updatedMember) {
    final index = _members.indexWhere((member) => member.id == updatedMember.id);
    if (index != -1) {
      _members[index] = updatedMember;
    }
  }

  void deleteMember(String id) {
    _members.removeWhere((member) => member.id == id);
  }

  List<Member> searchMembers(String query) {
    if (query.isEmpty) return getAllMembers();
    
    final lowerQuery = query.toLowerCase();
    return _members.where((member) =>
      member.name.toLowerCase().contains(lowerQuery) ||
      member.id.toLowerCase().contains(lowerQuery) ||
      member.className.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  List<Member> filterMembers({String? role, String? className, String? gender}) {
    var filtered = getAllMembers();
    
    if (role != null && role != 'Tất cả') {
      filtered = filtered.where((member) => member.role == role).toList();
    }
    
    if (className != null && className != 'Tất cả') {
      filtered = filtered.where((member) => member.className == className).toList();
    }
    
    if (gender != null && gender != 'Tất cả') {
      filtered = filtered.where((member) => member.gender == gender).toList();
    }
    
    return filtered;
  }
} 