import '../entities/wallet_entity.dart';

abstract class WalletRepository {
  Future<WalletDataEntity> getWalletData();
  Future<WalletDetailEntity> getWalletDetail(String id);
}
