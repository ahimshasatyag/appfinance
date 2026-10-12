import '../../domain/entities/transaction_entity.dart';

abstract class TransactionHistoryState {
  const TransactionHistoryState();
}

class TransactionHistoryInitial extends TransactionHistoryState {
  const TransactionHistoryInitial();
}

class TransactionHistoryLoading extends TransactionHistoryState {
  const TransactionHistoryLoading();
}

class TransactionHistoryLoaded extends TransactionHistoryState {
  final List<TransactionEntity> allTransactions;
  final List<TransactionEntity> filteredTransactions;
  final String selectedType;
  final String selectedCategory;
  final String searchQuery;

  const TransactionHistoryLoaded({
    required this.allTransactions,
    required this.filteredTransactions,
    this.selectedType = 'All',
    this.selectedCategory = 'All',
    this.searchQuery = '',
  });

  double get totalIncome {
    return filteredTransactions
        .where((t) => t.type.toLowerCase() == 'income' && t.status.toLowerCase() == 'success')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalExpense {
    return filteredTransactions
        .where((t) => t.type.toLowerCase() == 'expense' && t.status.toLowerCase() == 'success')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  TransactionHistoryLoaded copyWith({
    List<TransactionEntity>? allTransactions,
    List<TransactionEntity>? filteredTransactions,
    String? selectedType,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return TransactionHistoryLoaded(
      allTransactions: allTransactions ?? this.allTransactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      selectedType: selectedType ?? this.selectedType,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class TransactionHistoryError extends TransactionHistoryState {
  final String message;

  const TransactionHistoryError(this.message);
}
