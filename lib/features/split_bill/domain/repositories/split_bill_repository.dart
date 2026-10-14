import '../entities/bill_entity.dart';

abstract class SplitBillRepository {
  Future<List<BillEntity>> getBillHistory();
  Future<BillEntity> getBillDetail(String id);
  Future<BillEntity> createBill(BillEntity bill);
  Future<BillEntity> saveDraftBill(BillEntity bill);
  Future<BillEntity?> getDraftBill();
  Future<void> deleteDraftBill();
  Future<bool> markMemberPaid(String billId, String memberId, bool isPaid);
}
