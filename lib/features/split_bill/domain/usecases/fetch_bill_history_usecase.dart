import '../entities/bill_entity.dart';
import '../repositories/split_bill_repository.dart';

class FetchBillHistoryUseCase {
  final SplitBillRepository repository;

  FetchBillHistoryUseCase(this.repository);

  Future<List<BillEntity>> call() async {
    return await repository.getBillHistory();
  }

  Future<BillEntity> getDetail(String id) async {
    return await repository.getBillDetail(id);
  }
}
