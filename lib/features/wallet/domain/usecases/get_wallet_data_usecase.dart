import '../entities/wallet_entity.dart';
import '../repositories/wallet_repository.dart';

class GetWalletDataUseCase {
  final WalletRepository repository;

  GetWalletDataUseCase(this.repository);

  Future<WalletDataEntity> call() async {
    return await repository.getWalletData();
  }
}

class GetWalletDetailUseCase {
  final WalletRepository repository;

  GetWalletDetailUseCase(this.repository);

  Future<WalletDetailEntity> call(String id) async {
    return await repository.getWalletDetail(id);
  }
}
