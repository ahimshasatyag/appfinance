class FilterEntity {
  final String dateRange; 
  final String account; 
  final String? category;
  final String? transactionType;

  const FilterEntity({
    this.dateRange = 'This Month',
    this.account = 'All Accounts',
    this.category,
    this.transactionType,
  });

  FilterEntity copyWith({
    String? dateRange,
    String? account,
    String? category,
    String? transactionType,
  }) {
    return FilterEntity(
      dateRange: dateRange ?? this.dateRange,
      account: account ?? this.account,
      category: category ?? this.category,
      transactionType: transactionType ?? this.transactionType,
    );
  }
}
