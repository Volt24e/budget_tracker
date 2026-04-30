class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String type;
  final DateTime date;
  final String userId;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'type': type,
      'date': date.toIso8601String().split('T')[0],
      'user_id': userId,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      type: map['type'] ?? 'expense',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      userId: map['user_id'] ?? '',
    );
  }
}
