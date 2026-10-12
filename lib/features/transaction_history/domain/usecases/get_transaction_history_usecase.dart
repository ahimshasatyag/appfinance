import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionHistoryUseCase {
  final TransactionRepository repository;

  GetTransactionHistoryUseCase(this.repository);

  Future<List<TransactionEntity>> call({
    String? category,
    String? type,
    String? status,
    String? searchQuery,
  }) async {
    return await repository.getTransactionHistory(
      category: category,
      type: type,
      status: status,
      searchQuery: searchQuery,
    );
  }
}
