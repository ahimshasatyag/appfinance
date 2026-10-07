import '../../domain/entities/dashboard_data_entity.dart';
import 'transaction_model.dart';

class DashboardDataModel extends DashboardDataEntity {
  DashboardDataModel({
    required super.userName,
    required super.totalBalance,
    required super.income,
    required super.expenses,
    required super.recentTransactions,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    var list = json['recentTransactions'] as List;
    List<TransactionModel> transactionsList = list.map((i) => TransactionModel.fromJson(i)).toList();

    return DashboardDataModel(
      userName: json['userName'],
      totalBalance: (json['totalBalance'] as num).toDouble(),
      income: (json['income'] as num).toDouble(),
      expenses: (json['expenses'] as num).toDouble(),
      recentTransactions: transactionsList,
    );
  }
}
