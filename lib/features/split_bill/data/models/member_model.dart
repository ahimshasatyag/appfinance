import '../../domain/entities/member_entity.dart';

class MemberModel extends MemberEntity {
  const MemberModel({
    required super.id,
    required super.name,
    super.avatarUrl,
    super.phoneNumber,
    super.isCurrentUser,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      isCurrentUser: json['isCurrentUser'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'phoneNumber': phoneNumber,
      'isCurrentUser': isCurrentUser,
    };
  }

  factory MemberModel.fromEntity(MemberEntity entity) {
    return MemberModel(
      id: entity.id,
      name: entity.name,
      avatarUrl: entity.avatarUrl,
      phoneNumber: entity.phoneNumber,
      isCurrentUser: entity.isCurrentUser,
    );
  }

  MemberEntity toEntity() {
    return MemberEntity(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      phoneNumber: phoneNumber,
      isCurrentUser: isCurrentUser,
    );
  }
}
