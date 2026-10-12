import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_datasource.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TransactionEntity>> getTransactionHistory({
    String? category,
    String? type,
    String? status,
    String? searchQuery,
  }) async {
    try {
      final models = await remoteDataSource.getTransactionHistory(
        category: category,
        type: type,
        status: status,
        searchQuery: searchQuery,
      );
      return models;
    } catch (e) {
      throw Exception('Gagal memuat riwayat transaksi: $e');
    }
  }
}
