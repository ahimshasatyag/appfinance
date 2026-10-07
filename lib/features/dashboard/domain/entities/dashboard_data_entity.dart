import 'transaction_entity.dart';

class DashboardDataEntity {
  final String userName;
  final double totalBalance;
  final double income;
  final double expenses;
  final List<TransactionEntity> recentTransactions;

  DashboardDataEntity({
    required this.userName,
    required this.totalBalance,
    required this.income,
    required this.expenses,
    required this.recentTransactions,
  });
}
