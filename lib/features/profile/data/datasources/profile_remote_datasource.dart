import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<ProfileModel> getProfile() async {
    // Simulasi delay jaringan (loading)
    await Future.delayed(const Duration(seconds: 1));
    
    // Data mock berdasarkan desain
    return ProfileModel.fromJson({
      "id": "1",
      "fullName": "zubair rs",
      "email": "zubair@gmail.com",
      "phone": "Not set",
      "location": "Not set",
      "isEmailVerified": true,
    });
  }
}
