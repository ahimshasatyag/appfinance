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
}
