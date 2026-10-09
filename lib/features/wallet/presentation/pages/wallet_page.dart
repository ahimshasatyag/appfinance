import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_event.dart';
import '../bloc/wallet_state.dart';
import '../../domain/usecases/get_wallet_data_usecase.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../data/datasources/wallet_remote_datasource.dart';
import '../widgets/wallet_skeleton.dart';
import '../widgets/wallet_header.dart';
import '../widgets/wallet_total_balance.dart';
import '../widgets/wallet_summary.dart';
import '../widgets/wallet_distribution_chart.dart';
import '../widgets/wallet_list.dart';
import '../widgets/wallet_empty_state.dart';
import '../../../../shared/theme/app_theme.dart';
import 'wallet_add_page.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletBloc(
        getWalletDataUseCase: GetWalletDataUseCase(
          WalletRepositoryImpl(WalletRemoteDataSourceImpl()),
        ),
      )..add(LoadWalletData()),
      child: const WalletView(),
    );
  }
}

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletAddPage()));
        },
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Wallet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            if (state is WalletLoading || state is WalletInitial) {
              return const WalletSkeleton();
            } else if (state is WalletError) {
              return Center(child: Text(state.message));
            } else if (state is WalletLoaded) {
              final data = state.data;
              if (data.wallets.isEmpty) {
                return const WalletEmptyState();
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<WalletBloc>().add(LoadWalletData());
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const WalletHeader(),
                    const SizedBox(height: 24),
                    WalletTotalBalance(summary: data.summary),
                    const SizedBox(height: 16),
                    WalletSummary(summary: data.summary),
                    const SizedBox(height: 24),
                    WalletDistributionChart(wallets: data.wallets, totalBalance: data.summary.totalBalance),
                    const SizedBox(height: 24),
                    WalletList(wallets: data.wallets),
                    const SizedBox(height: 80), 
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
