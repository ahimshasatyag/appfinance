import '../../domain/entities/analytics_entity.dart';
import '../../domain/entities/filter_entity.dart';

abstract class AnalyticsRemoteDataSource {
  Future<AnalyticsEntity> getAnalytics(FilterEntity filter);
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  @override
  Future<AnalyticsEntity> getAnalytics(FilterEntity filter) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Returning mock data for UI presentation based on the requirements
    return AnalyticsEntity(
      totalBalance: 24850000,
      balanceChangePercentage: 12.5,
      totalIncome: 18500000,
      incomeChangePercentage: 8.2,
      totalExpense: 11250000,
      expenseChangePercentage: -4.8,
      netCashFlow: 7250000,
      netCashFlowChangePercentage: 15.4,
      expenseBreakdown: [
        CategoryExpense(categoryName: 'Food & Dining', percentage: 32, amount: 3600000, colorHex: 'FF6384'),
        CategoryExpense(categoryName: 'Transportation', percentage: 18, amount: 2025000, colorHex: '36A2EB'),
        CategoryExpense(categoryName: 'Shopping', percentage: 15, amount: 1687500, colorHex: 'FFCE56'),
        CategoryExpense(categoryName: 'Bills & Utilities', percentage: 14, amount: 1575000, colorHex: '4BC0C0'),
        CategoryExpense(categoryName: 'Entertainment', percentage: 9, amount: 1012500, colorHex: '9966FF'),
        CategoryExpense(categoryName: 'Others', percentage: 12, amount: 1350000, colorHex: 'C9CBCF'),
      ],
      incomeSources: [
        IncomeSource(sourceName: 'Salary', percentage: 72, amount: 13320000, colorHex: '4BC0C0'),
        IncomeSource(sourceName: 'Freelance', percentage: 15, amount: 2775000, colorHex: '36A2EB'),
        IncomeSource(sourceName: 'Investment', percentage: 13, amount: 2405000, colorHex: 'FFCE56'),
      ],
      monthlyComparison: [
        MonthlyComparison(month: 'Jan', income: 15000000, expense: 9500000),
        MonthlyComparison(month: 'Feb', income: 16500000, expense: 10200000),
        MonthlyComparison(month: 'Mar', income: 18000000, expense: 11000000),
        MonthlyComparison(month: 'Apr', income: 17500000, expense: 10500000),
        MonthlyComparison(month: 'May', income: 19000000, expense: 12000000),
        MonthlyComparison(month: 'Jun', income: 18500000, expense: 11250000),
      ],
      cashFlowAnalysis: [
        CashFlowData(month: 'Jan', moneyIn: 15000000, moneyOut: 9500000),
        CashFlowData(month: 'Feb', moneyIn: 16500000, moneyOut: 10200000),
        CashFlowData(month: 'Mar', moneyIn: 18000000, moneyOut: 11000000),
      ],
      dailyTrend: [
        DailyTrend(date: DateTime.now().subtract(const Duration(days: 6)), amount: 150000),
        DailyTrend(date: DateTime.now().subtract(const Duration(days: 5)), amount: 320000),
        DailyTrend(date: DateTime.now().subtract(const Duration(days: 4)), amount: 50000),
        DailyTrend(date: DateTime.now().subtract(const Duration(days: 3)), amount: 750000),
        DailyTrend(date: DateTime.now().subtract(const Duration(days: 2)), amount: 120000),
        DailyTrend(date: DateTime.now().subtract(const Duration(days: 1)), amount: 210000),
        DailyTrend(date: DateTime.now(), amount: 95000),
      ],
      insights: AnalyticsInsights(
        spendingChangePercentage: -8.4,
        spendingDifference: 950000,
        incomeChangePercentage: 12.5,
        topExpenseCategory: 'Food & Dining',
        topExpensePercentage: 32,
        savingsRate: 39.2,
      ),
      savingsAnalysis: SavingsAnalysis(
        monthlySavings: 7250000,
        savingsRate: 39.2,
        savingsGoal: 10000000,
        goals: [
          FinancialGoal(name: 'Emergency Fund', currentAmount: 35000000, targetAmount: 50000000),
          FinancialGoal(name: 'Vacation', currentAmount: 850000, targetAmount: 15000000),
          FinancialGoal(name: 'New Laptop', currentAmount: 12000000, targetAmount: 20000000),
        ],
      ),
      recentTransactions: [
        TransactionEntity(id: '1', date: DateTime.now(), description: 'Salary', category: 'Income', account: 'Bank Account', type: 'Income', amount: 15000000),
        TransactionEntity(id: '2', date: DateTime.now().subtract(const Duration(days: 1)), description: 'Restaurant', category: 'Food & Dining', account: 'Credit Card', type: 'Expense', amount: 350000),
        TransactionEntity(id: '3', date: DateTime.now().subtract(const Duration(days: 2)), description: 'Electricity Bill', category: 'Bills', account: 'Bank Account', type: 'Expense', amount: 750000),
      ],
      upcomingBills: [
        UpcomingBillEntity(id: '1', name: 'Spotify Premium', dueDate: DateTime.now().add(const Duration(days: 2)), amount: 54900, category: 'Entertainment', status: 'Pending'),
        UpcomingBillEntity(id: '2', name: 'Apartment Rent', dueDate: DateTime.now().add(const Duration(days: 5)), amount: 3500000, category: 'Housing', status: 'Pending'),
        UpcomingBillEntity(id: '3', name: 'Internet Bill', dueDate: DateTime.now().add(const Duration(days: 12)), amount: 450000, category: 'Bills', status: 'Pending'),
      ],
    );
  }
}
