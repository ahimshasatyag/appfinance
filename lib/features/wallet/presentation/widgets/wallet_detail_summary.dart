import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/wallet_entity.dart';
import '../pages/wallet_all_transactions_page.dart';

class WalletDetailSummary extends StatelessWidget {
  final WalletDetailEntity detail;

  const WalletDetailSummary({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildSummaryItem('Income', currencyFormatter.format(detail.totalIncome), Colors.green)),
              Container(width: 1, height: 40, color: Colors.grey.shade200),
              Expanded(child: _buildSummaryItem('Expense', currencyFormatter.format(detail.totalExpense), Colors.redAccent)),
              Container(width: 1, height: 40, color: Colors.grey.shade200),
              Expanded(child: _buildSummaryItem('Transfer', currencyFormatter.format(detail.totalTransfer), Colors.blue)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WalletAllTransactionsPage(
                    transactions: detail.transactions,
                    wallet: detail.wallet,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Transactions', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  Row(
                    children: [
                      Text('${detail.totalTransactions} Transactions', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String amount, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
        ),
      ],
    );
  }
}
