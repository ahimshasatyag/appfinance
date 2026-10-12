class TransactionEntity {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String status;
  final String category;
  final String type;
  final String account;
  final String? notes;

  const TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.status,
    required this.category,
    required this.type,
    this.account = 'Cash',
    this.notes,
  });

  TransactionEntity copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    String? status,
    String? category,
    String? type,
    String? account,
    String? notes,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      status: status ?? this.status,
      category: category ?? this.category,
      type: type ?? this.type,
      account: account ?? this.account,
      notes: notes ?? this.notes,
    );
  }
}
