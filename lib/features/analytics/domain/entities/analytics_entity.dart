class AnalyticsEntity {
  final double totalBalance;
  final double balanceChangePercentage;
  final double totalIncome;
  final double incomeChangePercentage;
  final double totalExpense;
  final double expenseChangePercentage;
  final double netCashFlow;
  final double netCashFlowChangePercentage;
  final List<CategoryExpense> expenseBreakdown;
  final List<IncomeSource> incomeSources;
  final List<MonthlyComparison> monthlyComparison;
  final List<CashFlowData> cashFlowAnalysis;
  final List<DailyTrend> dailyTrend;
  final AnalyticsInsights insights;
  final SavingsAnalysis savingsAnalysis;
  final List<TransactionEntity> recentTransactions;
  final List<UpcomingBillEntity> upcomingBills;

  AnalyticsEntity({
    required this.totalBalance,
    required this.balanceChangePercentage,
    required this.totalIncome,
    required this.incomeChangePercentage,
    required this.totalExpense,
    required this.expenseChangePercentage,
    required this.netCashFlow,
    required this.netCashFlowChangePercentage,
    required this.expenseBreakdown,
    required this.incomeSources,
    required this.monthlyComparison,
    required this.cashFlowAnalysis,
    required this.dailyTrend,
    required this.insights,
    required this.savingsAnalysis,
    required this.recentTransactions,
    required this.upcomingBills,
  });
}

class CategoryExpense {
  final String categoryName;
  final double percentage;
  final double amount;
  final String colorHex;

  CategoryExpense({
    required this.categoryName,
    required this.percentage,
    required this.amount,
    required this.colorHex,
  });
}

class IncomeSource {
  final String sourceName;
  final double percentage;
  final double amount;
  final String colorHex;

  IncomeSource({
    required this.sourceName,
    required this.percentage,
    required this.amount,
    required this.colorHex,
  });
}

class MonthlyComparison {
  final String month;
  final double income;
  final double expense;

  MonthlyComparison({
    required this.month,
    required this.income,
    required this.expense,
  });
}

class CashFlowData {
  final String month;
  final double moneyIn;
  final double moneyOut;

  CashFlowData({
    required this.month,
    required this.moneyIn,
    required this.moneyOut,
  });
}

class DailyTrend {
  final DateTime date;
  final double amount;

  DailyTrend({
    required this.date,
    required this.amount,
  });
}

class AnalyticsInsights {
  final double spendingChangePercentage;
  final double spendingDifference;
  final double incomeChangePercentage;
  final String topExpenseCategory;
  final double topExpensePercentage;
  final double savingsRate;

  AnalyticsInsights({
    required this.spendingChangePercentage,
    required this.spendingDifference,
    required this.incomeChangePercentage,
    required this.topExpenseCategory,
    required this.topExpensePercentage,
    required this.savingsRate,
  });
}

class SavingsAnalysis {
  final double monthlySavings;
  final double savingsRate;
  final double savingsGoal;
  final List<FinancialGoal> goals;

  SavingsAnalysis({
    required this.monthlySavings,
    required this.savingsRate,
    required this.savingsGoal,
    required this.goals,
  });
}

class FinancialGoal {
  final String name;
  final double currentAmount;
  final double targetAmount;

  FinancialGoal({
    required this.name,
    required this.currentAmount,
    required this.targetAmount,
  });
}

class TransactionEntity {
  final String id;
  final DateTime date;
  final String description;
  final String category;
  final String account;
  final String type;
  final double amount;

  TransactionEntity({
    required this.id,
    required this.date,
    required this.description,
    required this.category,
    required this.account,
    required this.type,
    required this.amount,
  });
}

class UpcomingBillEntity {
  final String id;
  final String name;
  final DateTime dueDate;
  final double amount;
  final String category;
  final String status;

  UpcomingBillEntity({
    required this.id,
    required this.name,
    required this.dueDate,
    required this.amount,
    required this.category,
    required this.status,
  });
}
