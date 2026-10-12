import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(ProfileModel profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileModel _currentProfile = ProfileModel.fromJson({
    "id": "1",
    "fullName": "zubair rs",
    "email": "zubair@gmail.com",
    "phone": "081234567890",
    "location": "Jakarta, Indonesia",
    "isEmailVerified": true,
  });

  @override
  Future<ProfileModel> getProfile() async {
    // Simulasi delay jaringan (loading)
    await Future.delayed(const Duration(milliseconds: 500));
    return _currentProfile;
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    // Simulasi delay jaringan (loading saat simpan)
    await Future.delayed(const Duration(milliseconds: 600));
    _currentProfile = profile;
    return _currentProfile;
  }
}
