class TransactionEntity {
  final String id;
  final String title;
  final String date;
  final double amount;
  final bool isExpense;
  final String iconUrl;

  TransactionEntity({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.isExpense,
    required this.iconUrl,
  });
}
