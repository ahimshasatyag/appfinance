import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/wallet_entity.dart';

class WalletSummary extends StatelessWidget {
  final WalletSummaryEntity summary;

  const WalletSummary({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Row(
      children: [
        Expanded(
          child: _buildSummaryItem('Total Assets', currencyFormatter.format(summary.totalAssets), Colors.blue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryItem('Total Debt', currencyFormatter.format(summary.totalDebt), Colors.redAccent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryItem('Net Worth', currencyFormatter.format(summary.netWorth), Colors.green),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String title, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(amount, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          ),
        ],
      ),
    );
  }
}
