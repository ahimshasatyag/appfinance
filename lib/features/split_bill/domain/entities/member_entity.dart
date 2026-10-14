import 'package:equatable/equatable.dart';

class MemberEntity extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? phoneNumber;
  final bool isCurrentUser;

  const MemberEntity({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.phoneNumber,
    this.isCurrentUser = false,
  });

  MemberEntity copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? phoneNumber,
    bool? isCurrentUser,
  }) {
    return MemberEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }

  @override
  List<Object?> get props => [id, name, avatarUrl, phoneNumber, isCurrentUser];
}
