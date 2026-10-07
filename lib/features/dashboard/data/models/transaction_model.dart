import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.id,
    required super.title,
    required super.date,
    required super.amount,
    required super.isExpense,
    required super.iconUrl,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      amount: (json['amount'] as num).toDouble(),
      isExpense: json['isExpense'] ?? true,
      iconUrl: json['iconUrl'] ?? '',
    );
  }
}
