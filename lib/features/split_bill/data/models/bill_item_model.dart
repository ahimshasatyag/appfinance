import '../../domain/entities/bill_item_entity.dart';

class BillItemModel extends BillItemEntity {
  const BillItemModel({
    required super.id,
    required super.name,
    required super.price,
    super.quantity,
    super.assignedMemberIds,
  });

  factory BillItemModel.fromJson(Map<String, dynamic> json) {
    return BillItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      assignedMemberIds: (json['assignedMemberIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'assignedMemberIds': assignedMemberIds,
    };
  }

  factory BillItemModel.fromEntity(BillItemEntity entity) {
    return BillItemModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      quantity: entity.quantity,
      assignedMemberIds: entity.assignedMemberIds,
    );
  }

  BillItemEntity toEntity() {
    return BillItemEntity(
      id: id,
      name: name,
      price: price,
      quantity: quantity,
      assignedMemberIds: assignedMemberIds,
    );
  }
}
