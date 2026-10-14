import 'package:equatable/equatable.dart';
import 'member_entity.dart';
import 'bill_item_entity.dart';

class MemberShareEntity extends Equatable {
  final MemberEntity member;
  final List<BillItemEntity> assignedItems;
  final double itemSubtotal;
  final double taxShare;
  final double serviceShare;
  final double discountShare;
  final double tipShare;
  final double totalAmount;
  final bool isPaid;

  const MemberShareEntity({
    required this.member,
    this.assignedItems = const [],
    required this.itemSubtotal,
    this.taxShare = 0.0,
    this.serviceShare = 0.0,
    this.discountShare = 0.0,
    this.tipShare = 0.0,
    required this.totalAmount,
    this.isPaid = false,
  });

  MemberShareEntity copyWith({
    MemberEntity? member,
    List<BillItemEntity>? assignedItems,
    double? itemSubtotal,
    double? taxShare,
    double? serviceShare,
    double? discountShare,
    double? tipShare,
    double? totalAmount,
    bool? isPaid,
  }) {
    return MemberShareEntity(
      member: member ?? this.member,
      assignedItems: assignedItems ?? this.assignedItems,
      itemSubtotal: itemSubtotal ?? this.itemSubtotal,
      taxShare: taxShare ?? this.taxShare,
      serviceShare: serviceShare ?? this.serviceShare,
      discountShare: discountShare ?? this.discountShare,
      tipShare: tipShare ?? this.tipShare,
      totalAmount: totalAmount ?? this.totalAmount,
      isPaid: isPaid ?? this.isPaid,
    );
  }

  @override
  List<Object?> get props => [
        member,
        assignedItems,
        itemSubtotal,
        taxShare,
        serviceShare,
        discountShare,
        tipShare,
        totalAmount,
        isPaid,
      ];
}

class BillEntity extends Equatable {
  final String id;
  final String title;
  final DateTime date;
  final List<MemberEntity> members;
  final List<BillItemEntity> items;
  final double subtotal;
  final double taxPercentage;
  final double taxAmount;
  final double servicePercentage;
  final double serviceAmount;
  final double discountAmount;
  final double tipAmount;
  final double grandTotal;
  final String status; // 'draft', 'pending', 'settled'
  final String? qrisUrl;
  final List<MemberShareEntity> breakdown;

  const BillEntity({
    required this.id,
    required this.title,
    required this.date,
    this.members = const [],
    this.items = const [],
    this.subtotal = 0.0,
    this.taxPercentage = 0.0,
    this.taxAmount = 0.0,
    this.servicePercentage = 0.0,
    this.serviceAmount = 0.0,
    this.discountAmount = 0.0,
    this.tipAmount = 0.0,
    this.grandTotal = 0.0,
    this.status = 'pending',
    this.qrisUrl,
    this.breakdown = const [],
  });

  bool get isAllPaid =>
      breakdown.isNotEmpty && breakdown.every((share) => share.isPaid);

  int get paidCount => breakdown.where((share) => share.isPaid).length;

  double get totalCollected => breakdown
      .where((share) => share.isPaid)
      .fold(0.0, (sum, share) => sum + share.totalAmount);

  double get remainingToCollect => grandTotal - totalCollected;

  BillEntity copyWith({
    String? id,
    String? title,
    DateTime? date,
    List<MemberEntity>? members,
    List<BillItemEntity>? items,
    double? subtotal,
    double? taxPercentage,
    double? taxAmount,
    double? servicePercentage,
    double? serviceAmount,
    double? discountAmount,
    double? tipAmount,
    double? grandTotal,
    String? status,
    String? qrisUrl,
    List<MemberShareEntity>? breakdown,
  }) {
    return BillEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      members: members ?? this.members,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      taxAmount: taxAmount ?? this.taxAmount,
      servicePercentage: servicePercentage ?? this.servicePercentage,
      serviceAmount: serviceAmount ?? this.serviceAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      tipAmount: tipAmount ?? this.tipAmount,
      grandTotal: grandTotal ?? this.grandTotal,
      status: status ?? this.status,
      qrisUrl: qrisUrl ?? this.qrisUrl,
      breakdown: breakdown ?? this.breakdown,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        date,
        members,
        items,
        subtotal,
        taxPercentage,
        taxAmount,
        servicePercentage,
        serviceAmount,
        discountAmount,
        tipAmount,
        grandTotal,
        status,
        qrisUrl,
        breakdown,
      ];
}
