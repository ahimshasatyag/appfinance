import '../entities/bill_entity.dart';
import '../entities/bill_item_entity.dart';
import '../entities/member_entity.dart';

class CalculateSplitBillUseCase {
  BillEntity execute({
    required String id,
    required String title,
    required DateTime date,
    required List<MemberEntity> members,
    required List<BillItemEntity> items,
    double taxPercentage = 0.0,
    double servicePercentage = 0.0,
    double discountAmount = 0.0,
    double tipAmount = 0.0,
    String status = 'pending',
    String? qrisUrl,
    Map<String, bool>? existingPaidStatus,
  }) {
    if (members.isEmpty) {
      return BillEntity(
        id: id,
        title: title,
        date: date,
        members: members,
        items: items,
        subtotal: 0.0,
        taxPercentage: taxPercentage,
        taxAmount: 0.0,
        servicePercentage: servicePercentage,
        serviceAmount: 0.0,
        discountAmount: discountAmount,
        tipAmount: tipAmount,
        grandTotal: 0.0,
        status: status,
        qrisUrl: qrisUrl,
        breakdown: const [],
      );
    }

    // 1. Calculate overall subtotal from all items
    double subtotal = 0.0;
    for (final item in items) {
      subtotal += item.totalPrice;
    }

    // 2. Calculate tax and service fee amounts
    final taxAmount = (subtotal * taxPercentage) / 100.0;
    final serviceAmount = (subtotal * servicePercentage) / 100.0;

    // 3. Calculate grand total
    double grandTotal = subtotal + taxAmount + serviceAmount - discountAmount + tipAmount;
    if (grandTotal < 0) grandTotal = 0.0;

    // 4. Map each member to their assigned items and base subtotal
    final Map<String, List<BillItemEntity>> memberItemsMap = {
      for (final m in members) m.id: [],
    };
    final Map<String, double> memberSubtotals = {
      for (final m in members) m.id: 0.0,
    };

    for (final item in items) {
      // If no members assigned, treat as assigned to all members
      final effectiveAssignees = item.assignedMemberIds.isEmpty
          ? members.map((m) => m.id).toList()
          : item.assignedMemberIds;

      final shareCount = effectiveAssignees.length;
      if (shareCount == 0) continue;

      final costPerPerson = item.totalPrice / shareCount;

      for (final memberId in effectiveAssignees) {
        if (memberSubtotals.containsKey(memberId)) {
          memberSubtotals[memberId] = (memberSubtotals[memberId] ?? 0.0) + costPerPerson;
          memberItemsMap[memberId]?.add(item);
        }
      }
    }

    // 5. Generate breakdown for each member
    final List<MemberShareEntity> breakdown = [];

    for (final member in members) {
      final mSubtotal = memberSubtotals[member.id] ?? 0.0;

      double mTaxShare = 0.0;
      double mServiceShare = 0.0;
      double mDiscountShare = 0.0;
      double mTipShare = 0.0;
      double mTotal = 0.0;

      if (subtotal > 0) {
        final ratio = mSubtotal / subtotal;
        mTaxShare = taxAmount * ratio;
        mServiceShare = serviceAmount * ratio;
        mDiscountShare = discountAmount * ratio;
        mTipShare = tipAmount * ratio;
        mTotal = mSubtotal + mTaxShare + mServiceShare - mDiscountShare + mTipShare;
      } else {
        // If subtotal is 0 but there is grand total (e.g. lump sum)
        final memberCount = members.length;
        mTaxShare = taxAmount / memberCount;
        mServiceShare = serviceAmount / memberCount;
        mDiscountShare = discountAmount / memberCount;
        mTipShare = tipAmount / memberCount;
        mTotal = grandTotal / memberCount;
      }

      if (mTotal < 0) mTotal = 0.0;

      final isPaid = existingPaidStatus?[member.id] ?? false;

      breakdown.add(
        MemberShareEntity(
          member: member,
          assignedItems: memberItemsMap[member.id] ?? [],
          itemSubtotal: mSubtotal,
          taxShare: mTaxShare,
          serviceShare: mServiceShare,
          discountShare: mDiscountShare,
          tipShare: mTipShare,
          totalAmount: mTotal,
          isPaid: isPaid,
        ),
      );
    }

    return BillEntity(
      id: id,
      title: title,
      date: date,
      members: members,
      items: items,
      subtotal: subtotal,
      taxPercentage: taxPercentage,
      taxAmount: taxAmount,
      servicePercentage: servicePercentage,
      serviceAmount: serviceAmount,
      discountAmount: discountAmount,
      tipAmount: tipAmount,
      grandTotal: grandTotal,
      status: status,
      qrisUrl: qrisUrl,
      breakdown: breakdown,
    );
  }
}
