import '../../domain/entities/wallet_entity.dart';

abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final WalletDataEntity data;
  WalletLoaded(this.data);
}

class WalletError extends WalletState {
  final String message;
  WalletError(this.message);
}
