import '../../domain/entities/bill_entity.dart';
import '../../domain/repositories/split_bill_repository.dart';
import '../datasources/split_bill_local_datasource.dart';
import '../datasources/split_bill_remote_datasource.dart';
import '../models/bill_model.dart';

class SplitBillRepositoryImpl implements SplitBillRepository {
  final SplitBillRemoteDataSource remoteDataSource;
  final SplitBillLocalDataSource localDataSource;

  SplitBillRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<BillEntity>> getBillHistory() async {
    try {
      final remoteBills = await remoteDataSource.fetchBills();
      await localDataSource.cacheBills(remoteBills);
      return remoteBills.map((m) => m.toEntity()).toList();
    } catch (_) {
      final cached = await localDataSource.getCachedBills();
      return cached.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<BillEntity> getBillDetail(String id) async {
    final billModel = await remoteDataSource.fetchBillDetail(id);
    return billModel.toEntity();
  }

  @override
  Future<BillEntity> createBill(BillEntity bill) async {
    final model = BillModel.fromEntity(bill);
    final savedModel = await remoteDataSource.postBill(model);
    await localDataSource.saveBill(savedModel);
    await localDataSource.clearDraft();
    return savedModel.toEntity();
  }

  @override
  Future<BillEntity> saveDraftBill(BillEntity bill) async {
    final model = BillModel.fromEntity(bill);
    await localDataSource.saveDraft(model);
    return model.toEntity();
  }

  @override
  Future<BillEntity?> getDraftBill() async {
    final draft = await localDataSource.getDraft();
    return draft?.toEntity();
  }

  @override
  Future<void> deleteDraftBill() async {
    await localDataSource.clearDraft();
  }

  @override
  Future<bool> markMemberPaid(
    String billId,
    String memberId,
    bool isPaid,
  ) async {
    final success = await remoteDataSource.updateMemberPayment(billId, memberId, isPaid);
    return success;
  }
}
