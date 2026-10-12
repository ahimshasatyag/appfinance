class ProfileEntity {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String location;
  final bool isEmailVerified;

  ProfileEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.location,
    required this.isEmailVerified,
  });

  ProfileEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? location,
    bool? isEmailVerified,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}
