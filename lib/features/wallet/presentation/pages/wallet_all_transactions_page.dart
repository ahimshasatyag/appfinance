import 'package:flutter/material.dart';
import '../../domain/entities/wallet_entity.dart';
import '../widgets/wallet_transaction_list.dart';

class WalletAllTransactionsPage extends StatelessWidget {
  final List<WalletTransactionEntity> transactions;
  final WalletEntity wallet;

  const WalletAllTransactionsPage({super.key, required this.transactions, required this.wallet});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: WalletTransactionList(transactions: transactions, wallet: wallet),
      ),
    );
  }
}
