import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_wallet_data_usecase.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletDataUseCase getWalletDataUseCase;

  WalletBloc({required this.getWalletDataUseCase}) : super(WalletInitial()) {
    on<LoadWalletData>((event, emit) async {
      emit(WalletLoading());
      try {
        final data = await getWalletDataUseCase();
        emit(WalletLoaded(data));
      } catch (e) {
        emit(WalletError('Failed to load wallet data: ${e.toString()}'));
      }
    });
  }
}
