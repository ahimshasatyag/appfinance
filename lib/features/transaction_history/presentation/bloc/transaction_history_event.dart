abstract class TransactionHistoryEvent {
  const TransactionHistoryEvent();
}

class LoadTransactionHistory extends TransactionHistoryEvent {
  final String? type;
  final String? category;
  final String? status;
  final String? searchQuery;

  const LoadTransactionHistory({
    this.type,
    this.category,
    this.status,
    this.searchQuery,
  });
}

class FilterTransactionHistory extends TransactionHistoryEvent {
  final String? type;
  final String? category;
  final String? status;

  const FilterTransactionHistory({
    this.type,
    this.category,
    this.status,
  });
}

class SearchTransactionHistory extends TransactionHistoryEvent {
  final String query;

  const SearchTransactionHistory(this.query);
}

class RefreshTransactionHistory extends TransactionHistoryEvent {
  const RefreshTransactionHistory();
}
