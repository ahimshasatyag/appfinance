import '../../domain/entities/bill_entity.dart';
import '../../domain/entities/member_entity.dart';
import '../../domain/entities/bill_item_entity.dart';
import 'member_model.dart';
import 'bill_item_model.dart';

class MemberShareModel extends MemberShareEntity {
  const MemberShareModel({
    required super.member,
    super.assignedItems,
    required super.itemSubtotal,
    super.taxShare,
    super.serviceShare,
    super.discountShare,
    super.tipShare,
    required super.totalAmount,
    super.isPaid,
  });

  factory MemberShareModel.fromJson(Map<String, dynamic> json) {
    return MemberShareModel(
      member: MemberModel.fromJson(json['member'] as Map<String, dynamic>),
      assignedItems: (json['assignedItems'] as List<dynamic>?)
              ?.map((e) => BillItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      itemSubtotal: (json['itemSubtotal'] as num).toDouble(),
      taxShare: (json['taxShare'] as num?)?.toDouble() ?? 0.0,
      serviceShare: (json['serviceShare'] as num?)?.toDouble() ?? 0.0,
      discountShare: (json['discountShare'] as num?)?.toDouble() ?? 0.0,
      tipShare: (json['tipShare'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      isPaid: json['isPaid'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'member': MemberModel.fromEntity(member).toJson(),
      'assignedItems': assignedItems
          .map((e) => BillItemModel.fromEntity(e).toJson())
          .toList(),
      'itemSubtotal': itemSubtotal,
      'taxShare': taxShare,
      'serviceShare': serviceShare,
      'discountShare': discountShare,
      'tipShare': tipShare,
      'totalAmount': totalAmount,
      'isPaid': isPaid,
    };
  }

  factory MemberShareModel.fromEntity(MemberShareEntity entity) {
    return MemberShareModel(
      member: entity.member,
      assignedItems: entity.assignedItems,
      itemSubtotal: entity.itemSubtotal,
      taxShare: entity.taxShare,
      serviceShare: entity.serviceShare,
      discountShare: entity.discountShare,
      tipShare: entity.tipShare,
      totalAmount: entity.totalAmount,
      isPaid: entity.isPaid,
    );
  }

  @override
  MemberShareModel copyWith({
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
    return MemberShareModel(
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
}

class BillModel extends BillEntity {
  const BillModel({
    required super.id,
    required super.title,
    required super.date,
    super.members,
    super.items,
    super.subtotal,
    super.taxPercentage,
    super.taxAmount,
    super.servicePercentage,
    super.serviceAmount,
    super.discountAmount,
    super.tipAmount,
    super.grandTotal,
    super.status,
    super.qrisUrl,
    super.breakdown,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => MemberModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => BillItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      taxPercentage: (json['taxPercentage'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0.0,
      servicePercentage: (json['servicePercentage'] as num?)?.toDouble() ?? 0.0,
      serviceAmount: (json['serviceAmount'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      tipAmount: (json['tipAmount'] as num?)?.toDouble() ?? 0.0,
      grandTotal: (json['grandTotal'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'pending',
      qrisUrl: json['qrisUrl'] as String?,
      breakdown: (json['breakdown'] as List<dynamic>?)
              ?.map((e) => MemberShareModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'members': members.map((e) => MemberModel.fromEntity(e).toJson()).toList(),
      'items': items.map((e) => BillItemModel.fromEntity(e).toJson()).toList(),
      'subtotal': subtotal,
      'taxPercentage': taxPercentage,
      'taxAmount': taxAmount,
      'servicePercentage': servicePercentage,
      'serviceAmount': serviceAmount,
      'discountAmount': discountAmount,
      'tipAmount': tipAmount,
      'grandTotal': grandTotal,
      'status': status,
      'qrisUrl': qrisUrl,
      'breakdown': breakdown
          .map((e) => MemberShareModel.fromEntity(e).toJson())
          .toList(),
    };
  }

  factory BillModel.fromEntity(BillEntity entity) {
    return BillModel(
      id: entity.id,
      title: entity.title,
      date: entity.date,
      members: entity.members,
      items: entity.items,
      subtotal: entity.subtotal,
      taxPercentage: entity.taxPercentage,
      taxAmount: entity.taxAmount,
      servicePercentage: entity.servicePercentage,
      serviceAmount: entity.serviceAmount,
      discountAmount: entity.discountAmount,
      tipAmount: entity.tipAmount,
      grandTotal: entity.grandTotal,
      status: entity.status,
      qrisUrl: entity.qrisUrl,
      breakdown: entity.breakdown,
    );
  }

  BillEntity toEntity() {
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

  @override
  BillModel copyWith({
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
    return BillModel(
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
}
