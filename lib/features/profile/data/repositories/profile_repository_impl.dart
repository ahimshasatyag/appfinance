import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProfileEntity> getProfile() async {
    try {
      return await remoteDataSource.getProfile();
    } catch (e) {
      throw Exception('Failed to fetch profile: ${e.toString()}');
    }
  }

  @override
  Future<ProfileEntity> updateProfile(ProfileEntity profile) async {
    try {
      final model = ProfileModel(
        id: profile.id,
        fullName: profile.fullName,
        email: profile.email,
        phone: profile.phone,
        location: profile.location,
        isEmailVerified: profile.isEmailVerified,
      );
      return await remoteDataSource.updateProfile(model);
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }
}
