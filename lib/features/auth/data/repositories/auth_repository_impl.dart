import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      // Memanggil datasource untuk mendapatkan UserModel
      final userModel = await remoteDataSource.login(email, password);
      // UserModel bisa dikembalikan langsung karena ia mewarisi UserEntity
      return userModel;
    } catch (e) {
      // Tangkap dan lemparkan error ke lapisan presentasi jika request gagal
      rethrow;
    }
  }
}
