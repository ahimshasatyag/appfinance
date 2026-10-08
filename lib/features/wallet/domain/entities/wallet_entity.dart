class WalletSummaryEntity {
  final double totalBalance;
  final double totalAssets;
  final double totalDebt;
  final double netWorth;
  final double incomeThisMonth;
  final double expenseThisMonth;
  final double balanceChangePercentage;

  const WalletSummaryEntity({
    required this.totalBalance,
    required this.totalAssets,
    required this.totalDebt,
    required this.netWorth,
    required this.incomeThisMonth,
    required this.expenseThisMonth,
    required this.balanceChangePercentage,
  });
}

class WalletEntity {
  final String id;
  final String name;
  final String type; 
  final String accountNumber; 
  final double balance;
  final double percentage; 
  final String currency;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final String status; 
  final bool isDefault;
  final WalletActivityEntity? lastActivity;

  const WalletEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.accountNumber,
    required this.balance,
    required this.percentage,
    required this.currency,
    required this.createdAt,
    required this.lastUpdated,
    required this.status,
    required this.isDefault,
    this.lastActivity,
  });
}

class WalletActivityEntity {
  final String title;
  final double amount;
  final DateTime date;
  final String type; 

  const WalletActivityEntity({
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
  });
}

class WalletDataEntity {
  final WalletSummaryEntity summary;
  final List<WalletEntity> wallets;

  const WalletDataEntity({
    required this.summary,
    required this.wallets,
  });
}

class ReceiptEntity {
  final String id;
  final String type; // Image, PDF
  final String url; // remote or local path
  final String merchant;
  final DateTime date;
  final double total;
  final String paymentMethod;

  const ReceiptEntity({
    required this.id,
    required this.type,
    required this.url,
    required this.merchant,
    required this.date,
    required this.total,
    required this.paymentMethod,
  });
}

class WalletTransactionEntity {
  final String id;
  final String name;
  final String category;
  final String categoryIcon; // food, transport, shopping, etc.
  final DateTime date;
  final double amount;
  final String type; // Income, Expense, Transfer
  final String merchant;
  final String paymentMethod;
  final String notes;
  final ReceiptEntity? receipt;

  const WalletTransactionEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryIcon,
    required this.date,
    required this.amount,
    required this.type,
    required this.merchant,
    required this.paymentMethod,
    required this.notes,
    this.receipt,
  });
}

class WalletDetailEntity {
  final WalletEntity wallet;
  final double initialBalance;
  final double totalIncome;
  final double totalExpense;
  final double totalTransfer;
  final List<BalanceHistoryPoint> balanceHistory;
  final double highestBalance;
  final double lowestBalance;
  final int totalTransactions;
  final int incomeTransactions;
  final int expenseTransactions;
  final int transferTransactions;
  final double averageMonthlyIncome;
  final double averageMonthlyExpense;
  final List<WalletTransactionEntity> transactions;

  const WalletDetailEntity({
    required this.wallet,
    required this.initialBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.totalTransfer,
    required this.balanceHistory,
    required this.highestBalance,
    required this.lowestBalance,
    required this.totalTransactions,
    required this.incomeTransactions,
    required this.expenseTransactions,
    required this.transferTransactions,
    required this.averageMonthlyIncome,
    required this.averageMonthlyExpense,
    required this.transactions,
  });
}

class BalanceHistoryPoint {
  final DateTime date;
  final double balance;

  const BalanceHistoryPoint({
    required this.date,
    required this.balance,
  });
}
