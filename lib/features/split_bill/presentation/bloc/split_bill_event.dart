import 'package:equatable/equatable.dart';
import '../../domain/entities/bill_entity.dart';
import '../../domain/entities/bill_item_entity.dart';

abstract class SplitBillEvent extends Equatable {
  const SplitBillEvent();

  @override
  List<Object?> get props => [];
}

class LoadBillHistoryEvent extends SplitBillEvent {
  const LoadBillHistoryEvent();
}

class LoadBillDetailEvent extends SplitBillEvent {
  final String billId;

  const LoadBillDetailEvent(this.billId);

  @override
  List<Object?> get props => [billId];
}

class InitCreateBillEvent extends SplitBillEvent {
  final BillEntity? initialBill;

  const InitCreateBillEvent({this.initialBill});

  @override
  List<Object?> get props => [initialBill];
}

class AddMemberEvent extends SplitBillEvent {
  final String name;
  final String? phoneNumber;

  const AddMemberEvent({required this.name, this.phoneNumber});

  @override
  List<Object?> get props => [name, phoneNumber];
}

class RemoveMemberEvent extends SplitBillEvent {
  final String memberId;

  const RemoveMemberEvent(this.memberId);

  @override
  List<Object?> get props => [memberId];
}

class AddBillItemEvent extends SplitBillEvent {
  final BillItemEntity item;

  const AddBillItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateBillItemEvent extends SplitBillEvent {
  final BillItemEntity item;

  const UpdateBillItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveBillItemEvent extends SplitBillEvent {
  final String itemId;

  const RemoveBillItemEvent(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class ToggleItemMemberAssignmentEvent extends SplitBillEvent {
  final String itemId;
  final String memberId;

  const ToggleItemMemberAssignmentEvent({
    required this.itemId,
    required this.memberId,
  });

  @override
  List<Object?> get props => [itemId, memberId];
}

class AssignAllMembersToItemEvent extends SplitBillEvent {
  final String itemId;

  const AssignAllMembersToItemEvent(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class UpdateBillTaxServiceEvent extends SplitBillEvent {
  final String? title;
  final double? taxPercentage;
  final double? servicePercentage;
  final double? discountAmount;
  final double? tipAmount;

  const UpdateBillTaxServiceEvent({
    this.title,
    this.taxPercentage,
    this.servicePercentage,
    this.discountAmount,
    this.tipAmount,
  });

  @override
  List<Object?> get props => [
        title,
        taxPercentage,
        servicePercentage,
        discountAmount,
        tipAmount,
      ];
}

class SubmitCreateBillEvent extends SplitBillEvent {
  const SubmitCreateBillEvent();
}

class ToggleMemberPaymentStatusEvent extends SplitBillEvent {
  final String billId;
  final String memberId;
  final bool isPaid;

  const ToggleMemberPaymentStatusEvent({
    required this.billId,
    required this.memberId,
    required this.isPaid,
  });

  @override
  List<Object?> get props => [billId, memberId, isPaid];
}
