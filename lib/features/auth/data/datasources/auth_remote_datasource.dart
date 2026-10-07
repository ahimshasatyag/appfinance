import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // Misalnya Anda menggunakan Dio atau http client lainnya:
  // final Dio dio;
  // AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login(String email, String password) async {
    // Simulasi network request delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulasi response sukses asalkan tidak kosong
    if (email.isNotEmpty && password.isNotEmpty) {
      return UserModel(
        id: 'user-123',
        email: email,
        name: 'Enjelin Morgeana', // Sesuai desain dashboard
      );
    } else {
      throw Exception('Login gagal: Email atau password tidak boleh kosong!');
    }
  }
}
