import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/transaction_entity.dart';
import '../../domain/usecases/get_transaction_history_usecase.dart';
import 'transaction_history_event.dart';
import 'transaction_history_state.dart';

class TransactionHistoryBloc
    extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  final GetTransactionHistoryUseCase getTransactionHistoryUseCase;

  TransactionHistoryBloc({required this.getTransactionHistoryUseCase})
      : super(const TransactionHistoryInitial()) {
    on<LoadTransactionHistory>(_onLoadTransactionHistory);
    on<FilterTransactionHistory>(_onFilterTransactionHistory);
    on<SearchTransactionHistory>(_onSearchTransactionHistory);
    on<RefreshTransactionHistory>(_onRefreshTransactionHistory);
  }

  Future<void> _onLoadTransactionHistory(
    LoadTransactionHistory event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    emit(const TransactionHistoryLoading());
    try {
      final transactions = await getTransactionHistoryUseCase(
        type: event.type,
        category: event.category,
        status: event.status,
        searchQuery: event.searchQuery,
      );

      final selectedType = event.type ?? 'All';
      final selectedCategory = event.category ?? 'All';
      final searchQuery = event.searchQuery ?? '';

      final filtered = _applyFilters(
        transactions,
        type: selectedType,
        category: selectedCategory,
        query: searchQuery,
      );

      emit(TransactionHistoryLoaded(
        allTransactions: transactions,
        filteredTransactions: filtered,
        selectedType: selectedType,
        selectedCategory: selectedCategory,
        searchQuery: searchQuery,
      ));
    } catch (e) {
      emit(TransactionHistoryError(e.toString()));
    }
  }

  void _onFilterTransactionHistory(
    FilterTransactionHistory event,
    Emitter<TransactionHistoryState> emit,
  ) {
    if (state is! TransactionHistoryLoaded) return;
    final currentState = state as TransactionHistoryLoaded;

    final newType = event.type ?? currentState.selectedType;
    final newCategory = event.category ?? currentState.selectedCategory;

    final filtered = _applyFilters(
      currentState.allTransactions,
      type: newType,
      category: newCategory,
      query: currentState.searchQuery,
    );

    emit(currentState.copyWith(
      selectedType: newType,
      selectedCategory: newCategory,
      filteredTransactions: filtered,
    ));
  }

  void _onSearchTransactionHistory(
    SearchTransactionHistory event,
    Emitter<TransactionHistoryState> emit,
  ) {
    if (state is! TransactionHistoryLoaded) return;
    final currentState = state as TransactionHistoryLoaded;

    final filtered = _applyFilters(
      currentState.allTransactions,
      type: currentState.selectedType,
      category: currentState.selectedCategory,
      query: event.query,
    );

    emit(currentState.copyWith(
      searchQuery: event.query,
      filteredTransactions: filtered,
    ));
  }

  Future<void> _onRefreshTransactionHistory(
    RefreshTransactionHistory event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    try {
      final transactions = await getTransactionHistoryUseCase();

      final currentType = state is TransactionHistoryLoaded
          ? (state as TransactionHistoryLoaded).selectedType
          : 'All';
      final currentCategory = state is TransactionHistoryLoaded
          ? (state as TransactionHistoryLoaded).selectedCategory
          : 'All';
      final currentQuery = state is TransactionHistoryLoaded
          ? (state as TransactionHistoryLoaded).searchQuery
          : '';

      final filtered = _applyFilters(
        transactions,
        type: currentType,
        category: currentCategory,
        query: currentQuery,
      );

      emit(TransactionHistoryLoaded(
        allTransactions: transactions,
        filteredTransactions: filtered,
        selectedType: currentType,
        selectedCategory: currentCategory,
        searchQuery: currentQuery,
      ));
    } catch (e) {
      emit(TransactionHistoryError(e.toString()));
    }
  }

  List<TransactionEntity> _applyFilters(
    List<TransactionEntity> list, {
    required String type,
    required String category,
    required String query,
  }) {
    var result = List<TransactionEntity>.from(list);

    if (type.isNotEmpty && type.toLowerCase() != 'all') {
      result = result
          .where((t) => t.type.toLowerCase() == type.toLowerCase())
          .toList();
    }

    if (category.isNotEmpty && category.toLowerCase() != 'all') {
      result = result
          .where((t) => t.category.toLowerCase() == category.toLowerCase())
          .toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      result = result.where((t) {
        return t.title.toLowerCase().contains(q) ||
            t.category.toLowerCase().contains(q) ||
            t.account.toLowerCase().contains(q) ||
            (t.notes != null && t.notes!.toLowerCase().contains(q));
      }).toList();
    }

    return result;
  }
}
