import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<List<TransactionEntity>> getTransactionHistory({
    String? category,
    String? type,
    String? status,
    String? searchQuery,
  });
}
