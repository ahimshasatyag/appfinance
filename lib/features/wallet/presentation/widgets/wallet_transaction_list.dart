import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/wallet_entity.dart';
import 'wallet_transaction_item.dart';

class WalletTransactionList extends StatelessWidget {
  final List<WalletTransactionEntity> transactions;
  final WalletEntity wallet;

  const WalletTransactionList({super.key, required this.transactions, required this.wallet});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            children: [
              Icon(Icons.receipt_long, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text('No Transactions Yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 8),
              Text('Transactions made with this wallet will appear here.', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      );
    }

    // Grouping by date
    final grouped = <String, List<WalletTransactionEntity>>{};
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);
    final yesterdayStr = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 1)));

    for (var t in transactions) {
      final dateStr = DateFormat('yyyy-MM-dd').format(t.date);
      String key;
      if (dateStr == todayStr) {
        key = 'TODAY';
      } else if (dateStr == yesterdayStr) {
        key = 'YESTERDAY';
      } else {
        key = DateFormat('dd MMM yyyy').format(t.date).toUpperCase();
      }
      if (!grouped.containsKey(key)) grouped[key] = [];
      grouped[key]!.add(t);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey, letterSpacing: 1)),
            ),
            ...entry.value.map((t) => WalletTransactionItem(transaction: t, wallet: wallet)).toList(),
          ],
        );
      }).toList(),
    );
  }
}
