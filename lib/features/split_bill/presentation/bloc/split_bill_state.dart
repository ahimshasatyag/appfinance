import 'package:equatable/equatable.dart';
import '../../domain/entities/bill_entity.dart';
import '../../domain/entities/bill_item_entity.dart';
import '../../domain/entities/member_entity.dart';

abstract class SplitBillState extends Equatable {
  const SplitBillState();

  @override
  List<Object?> get props => [];
}

class SplitBillInitial extends SplitBillState {
  const SplitBillInitial();
}

class SplitBillLoading extends SplitBillState {
  const SplitBillLoading();
}

class SplitBillHistoryLoaded extends SplitBillState {
  final List<BillEntity> bills;

  const SplitBillHistoryLoaded(this.bills);

  @override
  List<Object?> get props => [bills];
}

class SplitBillDetailLoaded extends SplitBillState {
  final BillEntity bill;

  const SplitBillDetailLoaded(this.bill);

  @override
  List<Object?> get props => [bill];
}

class SplitBillFormState extends SplitBillState {
  final String title;
  final List<MemberEntity> members;
  final List<BillItemEntity> items;
  final double taxPercentage;
  final double servicePercentage;
  final double discountAmount;
  final double tipAmount;
  final BillEntity calculatedBill;
  final bool isSubmitting;

  const SplitBillFormState({
    required this.title,
    required this.members,
    required this.items,
    this.taxPercentage = 0.0,
    this.servicePercentage = 0.0,
    this.discountAmount = 0.0,
    this.tipAmount = 0.0,
    required this.calculatedBill,
    this.isSubmitting = false,
  });

  SplitBillFormState copyWith({
    String? title,
    List<MemberEntity>? members,
    List<BillItemEntity>? items,
    double? taxPercentage,
    double? servicePercentage,
    double? discountAmount,
    double? tipAmount,
    BillEntity? calculatedBill,
    bool? isSubmitting,
  }) {
    return SplitBillFormState(
      title: title ?? this.title,
      members: members ?? this.members,
      items: items ?? this.items,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      servicePercentage: servicePercentage ?? this.servicePercentage,
      discountAmount: discountAmount ?? this.discountAmount,
      tipAmount: tipAmount ?? this.tipAmount,
      calculatedBill: calculatedBill ?? this.calculatedBill,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
        title,
        members,
        items,
        taxPercentage,
        servicePercentage,
        discountAmount,
        tipAmount,
        calculatedBill,
        isSubmitting,
      ];
}

class SplitBillSuccess extends SplitBillState {
  final BillEntity bill;
  final String message;

  const SplitBillSuccess(this.bill, {required this.message});

  @override
  List<Object?> get props => [bill, message];
}

class SplitBillError extends SplitBillState {
  final String message;

  const SplitBillError(this.message);

  @override
  List<Object?> get props => [message];
}
