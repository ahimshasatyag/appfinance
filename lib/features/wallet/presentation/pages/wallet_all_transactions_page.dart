import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        title: const Text('All Transactions', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
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
