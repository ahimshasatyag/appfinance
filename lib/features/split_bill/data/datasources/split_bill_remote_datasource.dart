import '../models/bill_model.dart';
import '../models/member_model.dart';
import '../models/bill_item_model.dart';

abstract class SplitBillRemoteDataSource {
  Future<List<BillModel>> fetchBills();
  Future<BillModel> fetchBillDetail(String id);
  Future<BillModel> postBill(BillModel bill);
  Future<bool> updateMemberPayment(String billId, String memberId, bool isPaid);
}

class SplitBillRemoteDataSourceImpl implements SplitBillRemoteDataSource {
  static final List<BillModel> _remoteBills = [];
  static bool _isInitialized = false;

  SplitBillRemoteDataSourceImpl() {
    if (!_isInitialized) {
      _initMockData();
      _isInitialized = true;
    }
  }

  void _initMockData() {
    final me = const MemberModel(
      id: 'm1',
      name: 'Saya',
      phoneNumber: '081234567890',
      isCurrentUser: true,
    );
    final budi = const MemberModel(
      id: 'm2',
      name: 'Budi Santoso',
      phoneNumber: '081298765432',
    );
    final siti = const MemberModel(
      id: 'm3',
      name: 'Siti Rahma',
      phoneNumber: '085712345678',
    );
    final andi = const MemberModel(
      id: 'm4',
      name: 'Andi Pratama',
      phoneNumber: '087812345678',
    );

    // Bill 1: Sushi Tei Hangout
    final items1 = [
      const BillItemModel(
        id: 'i1',
        name: 'Salmon Sashimi Moriawase',
        price: 135000,
        quantity: 1,
        assignedMemberIds: ['m1', 'm2'],
      ),
      const BillItemModel(
        id: 'i2',
        name: 'Crispy Mentai Roll',
        price: 88000,
        quantity: 1,
        assignedMemberIds: ['m1', 'm2', 'm3'],
      ),
      const BillItemModel(
        id: 'i3',
        name: 'Chicken Katsu Don',
        price: 65000,
        quantity: 1,
        assignedMemberIds: ['m3'],
      ),
      const BillItemModel(
        id: 'i4',
        name: 'Ocha Hangat (x3)',
        price: 15000,
        quantity: 3,
        assignedMemberIds: ['m1', 'm2', 'm3'],
      ),
    ];

    // Subtotal: 135k + 88k + 65k + 45k = 333,000
    // Tax 10%: 33,300, Service 5%: 16,650
    // Total: 382,950
    final breakdown1 = [
      MemberShareModel(
        member: me,
        assignedItems: [items1[0], items1[1], items1[3]],
        itemSubtotal: (135000 / 2) + (88000 / 3) + 15000,
        taxShare: 11183,
        serviceShare: 5592,
        totalAmount: 128608,
        isPaid: true,
      ),
      MemberShareModel(
        member: budi,
        assignedItems: [items1[0], items1[1], items1[3]],
        itemSubtotal: (135000 / 2) + (88000 / 3) + 15000,
        taxShare: 11183,
        serviceShare: 5592,
        totalAmount: 128608,
        isPaid: true,
      ),
      MemberShareModel(
        member: siti,
        assignedItems: [items1[1], items1[2], items1[3]],
        itemSubtotal: (88000 / 3) + 65000 + 15000,
        taxShare: 10933,
        serviceShare: 5467,
        totalAmount: 125734,
        isPaid: false,
      ),
    ];

    final bill1 = BillModel(
      id: 'bill-001',
      title: 'Makan Malam Sushi Tei',
      date: DateTime.now().subtract(const Duration(days: 2)),
      members: [me, budi, siti],
      items: items1,
      subtotal: 333000,
      taxPercentage: 10,
      taxAmount: 33300,
      servicePercentage: 5,
      serviceAmount: 16650,
      discountAmount: 0,
      tipAmount: 0,
      grandTotal: 382950,
      status: 'pending',
      qrisUrl: '00020101021226600016ID.CO.QRIS.WWW01189360099900000000005204581253033605802ID5913SushiTeiResto6007Jakarta6304ABCD',
      breakdown: breakdown1,
    );

    // Bill 2: Kopi Bersama Tim (Settled)
    final items2 = [
      const BillItemModel(
        id: 'i5',
        name: 'Kopi Kenangan Mantan (x4)',
        price: 24000,
        quantity: 4,
        assignedMemberIds: ['m1', 'm2', 'm3', 'm4'],
      ),
      const BillItemModel(
        id: 'i6',
        name: 'Roti Coklat Klasik (x2)',
        price: 14000,
        quantity: 2,
        assignedMemberIds: ['m1', 'm4'],
      ),
    ];

    final breakdown2 = [
      MemberShareModel(
        member: me,
        assignedItems: [items2[0], items2[1]],
        itemSubtotal: 24000 + 14000,
        totalAmount: 38000,
        isPaid: true,
      ),
      MemberShareModel(
        member: budi,
        assignedItems: [items2[0]],
        itemSubtotal: 24000,
        totalAmount: 24000,
        isPaid: true,
      ),
      MemberShareModel(
        member: siti,
        assignedItems: [items2[0]],
        itemSubtotal: 24000,
        totalAmount: 24000,
        isPaid: true,
      ),
      MemberShareModel(
        member: andi,
        assignedItems: [items2[0], items2[1]],
        itemSubtotal: 24000 + 14000,
        totalAmount: 38000,
        isPaid: true,
      ),
    ];

    final bill2 = BillModel(
      id: 'bill-002',
      title: 'Kopi & Roti Bersama Tim',
      date: DateTime.now().subtract(const Duration(days: 5)),
      members: [me, budi, siti, andi],
      items: items2,
      subtotal: 124000,
      taxPercentage: 0,
      taxAmount: 0,
      servicePercentage: 0,
      serviceAmount: 0,
      discountAmount: 0,
      tipAmount: 0,
      grandTotal: 124000,
      status: 'settled',
      breakdown: breakdown2,
    );

    _remoteBills.addAll([bill1, bill2]);
  }

  @override
  Future<List<BillModel>> fetchBills() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.unmodifiable(_remoteBills);
  }

  @override
  Future<BillModel> fetchBillDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final bill = _remoteBills.firstWhere(
      (b) => b.id == id,
      orElse: () => throw Exception('Bill with id $id not found'),
    );
    return bill;
  }

  @override
  Future<BillModel> postBill(BillModel bill) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final newBill = BillModel.fromEntity(
      bill.copyWith(
        qrisUrl: bill.qrisUrl ??
            '00020101021226600016ID.CO.QRIS.WWW01189360099900000000005204581253033605802ID5910SplitBillApp6007Jakarta6304${bill.id.hashCode.abs().toString().padLeft(4, '0')}',
      ),
    );

    _remoteBills.insert(0, newBill);
    return newBill;
  }

  @override
  Future<bool> updateMemberPayment(
    String billId,
    String memberId,
    bool isPaid,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _remoteBills.indexWhere((b) => b.id == billId);
    if (index >= 0) {
      final current = _remoteBills[index];
      final updatedBreakdown = current.breakdown.map((share) {
        if (share.member.id == memberId) {
          return MemberShareModel.fromEntity(share.copyWith(isPaid: isPaid));
        }
        return MemberShareModel.fromEntity(share);
      }).toList();

      final allPaid = updatedBreakdown.every((s) => s.isPaid);
      _remoteBills[index] = BillModel.fromEntity(
        current.copyWith(
          breakdown: updatedBreakdown,
          status: allPaid ? 'settled' : 'pending',
        ),
      );
      return true;
    }
    return false;
  }
}
