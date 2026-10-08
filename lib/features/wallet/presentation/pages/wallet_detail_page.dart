import 'package:flutter/material.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/usecases/get_wallet_data_usecase.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../data/datasources/wallet_remote_datasource.dart';
import '../widgets/wallet_skeleton.dart';
import '../widgets/wallet_detail_header.dart';
import '../widgets/wallet_detail_summary.dart';
import '../widgets/wallet_detail_history_chart.dart';
import '../widgets/wallet_transaction_summary.dart';
import '../widgets/wallet_transaction_list.dart';

class WalletDetailPage extends StatefulWidget {
  final String walletId;

  const WalletDetailPage({super.key, required this.walletId});

  @override
  State<WalletDetailPage> createState() => _WalletDetailPageState();
}

class _WalletDetailPageState extends State<WalletDetailPage> {
  late Future<WalletDetailEntity> _futureDetail;

  @override
  void initState() {
    super.initState();
    _futureDetail = GetWalletDetailUseCase(
      WalletRepositoryImpl(WalletRemoteDataSourceImpl())
    ).call(widget.walletId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: FutureBuilder<WalletDetailEntity>(
        future: _futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const WalletSkeleton();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return _buildContent(context, snapshot.data!);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, WalletDetailEntity detail) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        WalletDetailHeader(wallet: detail.wallet),
        const SizedBox(height: 24),
        WalletDetailSummary(detail: detail),
        const SizedBox(height: 24),
        WalletDetailHistoryChart(detail: detail),
        const SizedBox(height: 32),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Transaction History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            Row(
              children: [
                IconButton(icon: const Icon(Icons.search, color: Colors.grey), onPressed: () {}),
                IconButton(icon: const Icon(Icons.filter_list, color: Colors.grey), onPressed: () {}),
              ],
            )
          ],
        ),
        const SizedBox(height: 16),
        WalletTransactionSummary(detail: detail),
        const SizedBox(height: 16),
        WalletTransactionList(transactions: detail.transactions, wallet: detail.wallet),
        const SizedBox(height: 40),
      ],
    );
  }
}
