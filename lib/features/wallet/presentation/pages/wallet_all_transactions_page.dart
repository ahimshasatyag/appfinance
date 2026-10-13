import 'package:flutter/material.dart';
import '../../../../app/config/l10n.dart';
import '../../domain/entities/wallet_entity.dart';
import '../widgets/wallet_transaction_list.dart';

import '../widgets/wallet_all_transactions_skeleton.dart';

class WalletAllTransactionsPage extends StatefulWidget {
  final List<WalletTransactionEntity> transactions;
  final WalletEntity wallet;

  const WalletAllTransactionsPage({super.key, required this.transactions, required this.wallet});

  @override
  State<WalletAllTransactionsPage> createState() => _WalletAllTransactionsPageState();
}

class _WalletAllTransactionsPageState extends State<WalletAllTransactionsPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading to show skeleton
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : const Color(0xFF1E293B),
        ),
        title: Text(
          context.l10n.allTransactions,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _isLoading
          ? const WalletAllTransactionsSkeleton()
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: WalletTransactionList(transactions: widget.transactions, wallet: widget.wallet),
            ),
    );
  }
}
