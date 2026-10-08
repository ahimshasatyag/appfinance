import '../../domain/entities/wallet_entity.dart';

abstract class WalletRemoteDataSource {
  Future<WalletDataEntity> getWalletData();
  Future<WalletDetailEntity> getWalletDetail(String id);
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  @override
  Future<WalletDataEntity> getWalletData() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    final wallets = [
      WalletEntity(
        id: '1',
        name: 'BCA',
        type: 'Bank Account',
        accountNumber: '•••• 2389',
        balance: 8500000,
        percentage: 34.2,
        currency: 'IDR',
        createdAt: DateTime(2026, 1, 12),
        lastUpdated: DateTime(2026, 10, 8),
        status: 'Active',
        isDefault: true,
        lastActivity: WalletActivityEntity(
          title: 'Salary',
          amount: 8500000,
          date: DateTime(2026, 10, 8),
          type: 'Income',
        ),
      ),
      WalletEntity(
        id: '2',
        name: 'Mandiri',
        type: 'Bank Account',
        accountNumber: '•••• 7821',
        balance: 5250000,
        percentage: 21.1,
        currency: 'IDR',
        createdAt: DateTime(2025, 5, 20),
        lastUpdated: DateTime(2026, 10, 5),
        status: 'Active',
        isDefault: false,
        lastActivity: WalletActivityEntity(
          title: 'Grocery',
          amount: 750000,
          date: DateTime(2026, 10, 5),
          type: 'Expense',
        ),
      ),
      WalletEntity(
        id: '3',
        name: 'GoPay',
        type: 'E-Wallet',
        accountNumber: '•••• 9988',
        balance: 750000,
        percentage: 3.0,
        currency: 'IDR',
        createdAt: DateTime(2025, 8, 15),
        lastUpdated: DateTime(2026, 10, 7),
        status: 'Active',
        isDefault: false,
        lastActivity: WalletActivityEntity(
          title: 'Food Delivery',
          amount: 150000,
          date: DateTime(2026, 10, 7),
          type: 'Expense',
        ),
      ),
      WalletEntity(
        id: '4',
        name: 'Cash',
        type: 'Cash',
        accountNumber: '',
        balance: 1500000,
        percentage: 6.0,
        currency: 'IDR',
        createdAt: DateTime(2024, 1, 1),
        lastUpdated: DateTime(2026, 10, 1),
        status: 'Active',
        isDefault: false,
      ),
      WalletEntity(
        id: '5',
        name: 'Stocks',
        type: 'Investment',
        accountNumber: 'IDX',
        balance: 8850000,
        percentage: 35.6,
        currency: 'IDR',
        createdAt: DateTime(2025, 2, 10),
        lastUpdated: DateTime(2026, 10, 8),
        status: 'Active',
        isDefault: false,
      ),
    ];

    return WalletDataEntity(
      summary: WalletSummaryEntity(
        totalBalance: 24850000,
        totalAssets: 30500000,
        totalDebt: 5650000,
        netWorth: 24850000,
        incomeThisMonth: 8500000,
        expenseThisMonth: 3250000,
        balanceChangePercentage: 21.5,
      ),
      wallets: wallets,
    );
  }

  @override
  Future<WalletDetailEntity> getWalletDetail(String id) async {
    await Future.delayed(const Duration(seconds: 1)); 
    final data = await getWalletData();
    final wallet = data.wallets.firstWhere((w) => w.id == id, orElse: () => data.wallets.first);
    
    // Generate mock history
    final history = <BalanceHistoryPoint>[];
    double tempBal = wallet.balance - 2000000;
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      history.add(BalanceHistoryPoint(
        date: DateTime(now.year, now.month - i, 1),
        balance: tempBal,
      ));
      tempBal += (i % 2 == 0) ? 500000 : 200000;
    }
    
    // Generate mock transactions
    final transactions = [
      WalletTransactionEntity(
        id: '1',
        name: 'Salary',
        category: 'Bank Transfer',
        categoryIcon: 'bank',
        date: DateTime(now.year, now.month, now.day, 9, 15),
        amount: 8500000,
        type: 'Income',
        merchant: 'Company XYZ',
        paymentMethod: 'Bank Transfer',
        notes: 'Monthly salary',
      ),
      WalletTransactionEntity(
        id: '2',
        name: 'Lunch',
        category: 'Food & Restaurant',
        categoryIcon: 'food',
        date: DateTime(now.year, now.month, now.day, 12, 45),
        amount: 750000,
        type: 'Expense',
        merchant: 'McDonalds',
        paymentMethod: 'Debit Card',
        notes: 'Lunch with team',
      ),
      WalletTransactionEntity(
        id: '3',
        name: 'Coffee Shop',
        category: 'Food & Beverage',
        categoryIcon: 'coffee',
        date: DateTime(now.year, now.month, now.day, 15, 20),
        amount: 85000,
        type: 'Expense',
        merchant: 'Starbucks',
        paymentMethod: 'Debit Card',
        notes: 'Afternoon coffee',
        receipt: ReceiptEntity(
          id: 'RCT-20261008-00124',
          type: 'Image',
          url: 'https://via.placeholder.com/600x800.png?text=Receipt+Image',
          merchant: 'Starbucks',
          date: DateTime(now.year, now.month, now.day, 15, 20),
          total: 85000,
          paymentMethod: 'BCA •••• 2389'
        )
      ),
      WalletTransactionEntity(
        id: '4',
        name: 'Transfer to DANA',
        category: 'Transfer',
        categoryIcon: 'transfer',
        date: DateTime(now.year, now.month, now.day - 1, 18, 30),
        amount: 500000,
        type: 'Transfer',
        merchant: 'DANA E-Wallet',
        paymentMethod: 'Bank Transfer',
        notes: 'Top up',
      ),
    ];
    
    return WalletDetailEntity(
      wallet: wallet,
      initialBalance: wallet.balance - 3500000,
      totalIncome: 12500000,
      totalExpense: 9000000,
      totalTransfer: 1500000,
      balanceHistory: history,
      highestBalance: wallet.balance + 750000,
      lowestBalance: wallet.balance - 2750000,
      totalTransactions: 124,
      incomeTransactions: 35,
      expenseTransactions: 82,
      transferTransactions: 7,
      averageMonthlyIncome: 8250000,
      averageMonthlyExpense: 3150000,
      transactions: transactions,
    );
  }
}
