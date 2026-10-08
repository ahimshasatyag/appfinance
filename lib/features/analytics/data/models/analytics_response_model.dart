import '../../domain/entities/analytics_entity.dart';

class AnalyticsResponseModel extends AnalyticsEntity {
  AnalyticsResponseModel({
    required super.totalBalance,
    required super.balanceChangePercentage,
    required super.totalIncome,
    required super.incomeChangePercentage,
    required super.totalExpense,
    required super.expenseChangePercentage,
    required super.netCashFlow,
    required super.netCashFlowChangePercentage,
    required super.expenseBreakdown,
    required super.incomeSources,
    required super.monthlyComparison,
    required super.cashFlowAnalysis,
    required super.dailyTrend,
    required super.insights,
    required super.savingsAnalysis,
    required super.recentTransactions,
    required super.upcomingBills,
  });

  factory AnalyticsResponseModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsResponseModel(
      totalBalance: json['totalBalance']?.toDouble() ?? 0.0,
      balanceChangePercentage: json['balanceChangePercentage']?.toDouble() ?? 0.0,
      totalIncome: json['totalIncome']?.toDouble() ?? 0.0,
      incomeChangePercentage: json['incomeChangePercentage']?.toDouble() ?? 0.0,
      totalExpense: json['totalExpense']?.toDouble() ?? 0.0,
      expenseChangePercentage: json['expenseChangePercentage']?.toDouble() ?? 0.0,
      netCashFlow: json['netCashFlow']?.toDouble() ?? 0.0,
      netCashFlowChangePercentage: json['netCashFlowChangePercentage']?.toDouble() ?? 0.0,
      expenseBreakdown: [],
      incomeSources: [],
      monthlyComparison: [],
      cashFlowAnalysis: [],
      dailyTrend: [],
      insights: AnalyticsInsights(
        spendingChangePercentage: 0,
        spendingDifference: 0,
        incomeChangePercentage: 0,
        topExpenseCategory: '',
        topExpensePercentage: 0,
        savingsRate: 0,
      ),
      savingsAnalysis: SavingsAnalysis(
        monthlySavings: 0,
        savingsRate: 0,
        savingsGoal: 0,
        goals: [],
      ),
      recentTransactions: [],
      upcomingBills: [],
    );
  }
}
