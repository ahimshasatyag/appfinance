import '../../domain/entities/wallet_entity.dart';

class WalletSummaryModel extends WalletSummaryEntity {
  const WalletSummaryModel({
    required super.totalBalance,
    required super.totalAssets,
    required super.totalDebt,
    required super.netWorth,
    required super.incomeThisMonth,
    required super.expenseThisMonth,
    required super.balanceChangePercentage,
  });

  factory WalletSummaryModel.fromJson(Map<String, dynamic> json) {
    return WalletSummaryModel(
      totalBalance: (json['totalBalance'] ?? 0).toDouble(),
      totalAssets: (json['totalAssets'] ?? 0).toDouble(),
      totalDebt: (json['totalDebt'] ?? 0).toDouble(),
      netWorth: (json['netWorth'] ?? 0).toDouble(),
      incomeThisMonth: (json['incomeThisMonth'] ?? 0).toDouble(),
      expenseThisMonth: (json['expenseThisMonth'] ?? 0).toDouble(),
      balanceChangePercentage: (json['balanceChangePercentage'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBalance': totalBalance,
      'totalAssets': totalAssets,
      'totalDebt': totalDebt,
      'netWorth': netWorth,
      'incomeThisMonth': incomeThisMonth,
      'expenseThisMonth': expenseThisMonth,
      'balanceChangePercentage': balanceChangePercentage,
    };
  }
}

class WalletModel extends WalletEntity {
  const WalletModel({
    required super.id,
    required super.name,
    required super.type,
    required super.accountNumber,
    required super.balance,
    required super.percentage,
    required super.currency,
    required super.createdAt,
    required super.lastUpdated,
    required super.status,
    required super.isDefault,
    super.lastActivity,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      percentage: (json['percentage'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'IDR',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      lastUpdated: json['lastUpdated'] != null ? DateTime.parse(json['lastUpdated']) : DateTime.now(),
      status: json['status'] ?? 'Active',
      isDefault: json['isDefault'] ?? false,
      lastActivity: json['lastActivity'] != null 
          ? WalletActivityModel.fromJson(json['lastActivity']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'accountNumber': accountNumber,
      'balance': balance,
      'percentage': percentage,
      'currency': currency,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'status': status,
      'isDefault': isDefault,
      'lastActivity': (lastActivity as WalletActivityModel?)?.toJson(),
    };
  }
}

class WalletActivityModel extends WalletActivityEntity {
  const WalletActivityModel({
    required super.title,
    required super.amount,
    required super.date,
    required super.type,
  });

  factory WalletActivityModel.fromJson(Map<String, dynamic> json) {
    return WalletActivityModel(
      title: json['title'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type,
    };
  }
}

class WalletDataModel extends WalletDataEntity {
  const WalletDataModel({
    required super.summary,
    required super.wallets,
  });

  factory WalletDataModel.fromJson(Map<String, dynamic> json) {
    return WalletDataModel(
      summary: WalletSummaryModel.fromJson(json['summary'] ?? {}),
      wallets: (json['wallets'] as List? ?? [])
          .map((w) => WalletModel.fromJson(w))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': (summary as WalletSummaryModel).toJson(),
      'wallets': wallets.map((w) => (w as WalletModel).toJson()).toList(),
    };
  }
}

class ReceiptModel extends ReceiptEntity {
  const ReceiptModel({
    required super.id,
    required super.type,
    required super.url,
    required super.merchant,
    required super.date,
    required super.total,
    required super.paymentMethod,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    return ReceiptModel(
      id: json['id'] ?? '',
      type: json['type'] ?? 'Image',
      url: json['url'] ?? '',
      merchant: json['merchant'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      total: (json['total'] ?? 0).toDouble(),
      paymentMethod: json['paymentMethod'] ?? '',
    );
  }
}

class WalletTransactionModel extends WalletTransactionEntity {
  const WalletTransactionModel({
    required super.id,
    required super.name,
    required super.category,
    required super.categoryIcon,
    required super.date,
    required super.amount,
    required super.type,
    required super.merchant,
    required super.paymentMethod,
    required super.notes,
    super.receipt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      categoryIcon: json['categoryIcon'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      amount: (json['amount'] ?? 0).toDouble(),
      type: json['type'] ?? '',
      merchant: json['merchant'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      notes: json['notes'] ?? '',
      receipt: json['receipt'] != null ? ReceiptModel.fromJson(json['receipt']) : null,
    );
  }
}

class WalletDetailModel extends WalletDetailEntity {
  const WalletDetailModel({
    required super.wallet,
    required super.initialBalance,
    required super.totalIncome,
    required super.totalExpense,
    required super.totalTransfer,
    required super.balanceHistory,
    required super.highestBalance,
    required super.lowestBalance,
    required super.totalTransactions,
    required super.incomeTransactions,
    required super.expenseTransactions,
    required super.transferTransactions,
    required super.averageMonthlyIncome,
    required super.averageMonthlyExpense,
    required super.transactions,
  });

  factory WalletDetailModel.fromJson(Map<String, dynamic> json) {
    return WalletDetailModel(
      wallet: WalletModel.fromJson(json['wallet'] ?? {}),
      initialBalance: (json['initialBalance'] ?? 0).toDouble(),
      totalIncome: (json['totalIncome'] ?? 0).toDouble(),
      totalExpense: (json['totalExpense'] ?? 0).toDouble(),
      totalTransfer: (json['totalTransfer'] ?? 0).toDouble(),
      balanceHistory: (json['balanceHistory'] as List? ?? [])
          .map((h) => BalanceHistoryPointModel.fromJson(h))
          .toList(),
      highestBalance: (json['highestBalance'] ?? 0).toDouble(),
      lowestBalance: (json['lowestBalance'] ?? 0).toDouble(),
      totalTransactions: json['totalTransactions'] ?? 0,
      incomeTransactions: json['incomeTransactions'] ?? 0,
      expenseTransactions: json['expenseTransactions'] ?? 0,
      transferTransactions: json['transferTransactions'] ?? 0,
      averageMonthlyIncome: (json['averageMonthlyIncome'] ?? 0).toDouble(),
      averageMonthlyExpense: (json['averageMonthlyExpense'] ?? 0).toDouble(),
      transactions: (json['transactions'] as List? ?? [])
          .map((t) => WalletTransactionModel.fromJson(t))
          .toList(),
    );
  }
}

class BalanceHistoryPointModel extends BalanceHistoryPoint {
  const BalanceHistoryPointModel({
    required super.date,
    required super.balance,
  });

  factory BalanceHistoryPointModel.fromJson(Map<String, dynamic> json) {
    return BalanceHistoryPointModel(
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }
}
