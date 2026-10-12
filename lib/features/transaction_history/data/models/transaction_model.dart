import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.date,
    required super.status,
    required super.category,
    required super.type,
    super.account = 'Cash',
    super.notes,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    if (json['date'] is String) {
      parsedDate = DateTime.tryParse(json['date']) ?? DateTime.now();
    } else if (json['date'] is int) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(json['date']);
    } else {
      parsedDate = DateTime.now();
    }

    double parsedAmount = 0.0;
    if (json['amount'] is num) {
      parsedAmount = (json['amount'] as num).toDouble();
    } else if (json['amount'] is String) {
      parsedAmount = double.tryParse(json['amount']) ?? 0.0;
    }

    return TransactionModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? '',
      amount: parsedAmount,
      date: parsedDate,
      status: json['status'] ?? 'Success',
      category: json['category'] ?? 'General',
      type: json['type'] ?? 'Expense',
      account: json['account'] ?? 'Cash',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status,
      'category': category,
      'type': type,
      'account': account,
      'notes': notes,
    };
  }
}
