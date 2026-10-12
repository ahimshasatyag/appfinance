import '../../domain/entities/profile_entity.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final ProfileEntity profile;
  UpdateProfile(this.profile);
}
