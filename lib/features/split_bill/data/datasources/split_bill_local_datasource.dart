import '../models/bill_model.dart';

abstract class SplitBillLocalDataSource {
  Future<void> saveDraft(BillModel bill);
  Future<BillModel?> getDraft();
  Future<void> clearDraft();
  Future<void> cacheBills(List<BillModel> bills);
  Future<List<BillModel>> getCachedBills();
  Future<void> saveBill(BillModel bill);
}

class SplitBillLocalDataSourceImpl implements SplitBillLocalDataSource {
  static BillModel? _draftBill;
  static final List<BillModel> _localBillsCache = [];

  @override
  Future<void> saveDraft(BillModel bill) async {
    _draftBill = bill;
  }

  @override
  Future<BillModel?> getDraft() async {
    return _draftBill;
  }

  @override
  Future<void> clearDraft() async {
    _draftBill = null;
  }

  @override
  Future<void> cacheBills(List<BillModel> bills) async {
    _localBillsCache.clear();
    _localBillsCache.addAll(bills);
  }

  @override
  Future<List<BillModel>> getCachedBills() async {
    return List.unmodifiable(_localBillsCache);
  }

  @override
  Future<void> saveBill(BillModel bill) async {
    final index = _localBillsCache.indexWhere((b) => b.id == bill.id);
    if (index >= 0) {
      _localBillsCache[index] = bill;
    } else {
      _localBillsCache.insert(0, bill);
    }
  }
}
