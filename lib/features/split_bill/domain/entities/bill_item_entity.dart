import 'package:equatable/equatable.dart';

class BillItemEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final List<String> assignedMemberIds;

  const BillItemEntity({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.assignedMemberIds = const [],
  });

  double get totalPrice => price * quantity;

  double get pricePerPerson {
    if (assignedMemberIds.isEmpty) return totalPrice;
    return totalPrice / assignedMemberIds.length;
  }

  BillItemEntity copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    List<String>? assignedMemberIds,
  }) {
    return BillItemEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      assignedMemberIds: assignedMemberIds ?? this.assignedMemberIds,
    );
  }

  @override
  List<Object?> get props => [id, name, price, quantity, assignedMemberIds];
}
