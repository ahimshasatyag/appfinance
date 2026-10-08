import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_datasource.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl(this.remoteDataSource);

  @override
  Future<WalletDataEntity> getWalletData() async {
    return await remoteDataSource.getWalletData();
  }

  @override
  Future<WalletDetailEntity> getWalletDetail(String id) async {
    return await remoteDataSource.getWalletDetail(id);
  }
}
