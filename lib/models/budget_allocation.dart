class BudgetAllocation {
  final int id;
  final String club;
  final String clubName;
  final int amount;
  final String purpose;
  final String allocationDate;

  const BudgetAllocation({
    required this.id,
    required this.club,
    required this.clubName,
    required this.amount,
    required this.purpose,
    required this.allocationDate,
  });

  factory BudgetAllocation.fromMap(Map<String, dynamic> map) {
    return BudgetAllocation(
      id: map['_id'] ?? 0,
      club: map['club'] ?? '',
      clubName: map['clubName'] ?? '',
      amount: map['amount'] ?? 0,
      purpose: map['purpose'] ?? '',
      allocationDate: map['allocationDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'club': club,
      'clubName': clubName,
      'amount': amount,
      'purpose': purpose,
      'allocationDate': allocationDate,
    };
  }

  BudgetAllocation copyWith({
    int? id,
    String? club,
    String? clubName,
    int? amount,
    String? purpose,
    String? allocationDate,
  }) {
    return BudgetAllocation(
      id: id ?? this.id,
      club: club ?? this.club,
      clubName: clubName ?? this.clubName,
      amount: amount ?? this.amount,
      purpose: purpose ?? this.purpose,
      allocationDate: allocationDate ?? this.allocationDate,
    );
  }
} 