import '../entities/bill_entity.dart';
import '../repositories/split_bill_repository.dart';

class CreateBillUseCase {
  final SplitBillRepository repository;

  CreateBillUseCase(this.repository);

  Future<BillEntity> call(BillEntity bill) async {
    return await repository.createBill(bill);
  }
}
