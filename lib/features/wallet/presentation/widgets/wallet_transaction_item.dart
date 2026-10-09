import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/wallet_entity.dart';
import 'wallet_transaction_detail_sheet.dart';

class WalletTransactionItem extends StatelessWidget {
  final WalletTransactionEntity transaction;
  final WalletEntity wallet;

  const WalletTransactionItem({super.key, required this.transaction, required this.wallet});

  IconData _getIcon() {
    if (transaction.type == 'Income') return Icons.arrow_downward;
    if (transaction.type == 'Transfer') return Icons.swap_horiz;
    if (transaction.categoryIcon == 'food') return Icons.fastfood;
    if (transaction.categoryIcon == 'coffee') return Icons.local_cafe;
    return Icons.receipt;
  }

  Color _getIconColor() {
    if (transaction.type == 'Income') return Colors.green;
    if (transaction.type == 'Transfer') return Colors.blue;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final timeFormatter = DateFormat('HH:mm');

    final bool isExpense = transaction.type == 'Expense';
    final amountText = '${isExpense ? '- ' : ''}${currencyFormatter.format(transaction.amount)}';

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => WalletTransactionDetailSheet(transaction: transaction, wallet: wallet),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getIconColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(_getIcon(), color: _getIconColor(), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaction.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('${transaction.type} · ${transaction.category}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(amountText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isExpense ? null : Colors.green)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(timeFormatter.format(transaction.date), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
