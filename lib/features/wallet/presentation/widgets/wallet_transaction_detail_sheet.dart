import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/wallet_entity.dart';
import '../pages/receipt_viewer_page.dart';

class WalletTransactionDetailSheet extends StatelessWidget {
  final WalletTransactionEntity transaction;
  final WalletEntity wallet;

  const WalletTransactionDetailSheet({super.key, required this.transaction, required this.wallet});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormatter = DateFormat('dd MMMM yyyy');
    final timeFormatter = DateFormat('HH:mm');

    final bool isExpense = transaction.type == 'Expense';
    final amountText = '${isExpense ? '- ' : ''}${currencyFormatter.format(transaction.amount)}';
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 24),
              
              // Header
              Center(
                child: Column(
                  children: [
                    Text(transaction.merchant, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                    const SizedBox(height: 4),
                    Text(transaction.type, style: TextStyle(fontSize: 14, color: isExpense ? Colors.redAccent : Colors.green, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(amountText, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    const SizedBox(height: 8),
                    Text('${dateFormatter.format(transaction.date)}\n${timeFormatter.format(transaction.date)}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              const Text('Transaction Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 16),
              _buildInfoRow('Wallet', '${wallet.name} ${wallet.accountNumber.isNotEmpty ? '•••• ' + wallet.accountNumber.substring(wallet.accountNumber.length > 4 ? wallet.accountNumber.length - 4 : 0) : ''}'),
              _buildInfoRow('Category', transaction.category),
              _buildInfoRow('Merchant', transaction.merchant),
              _buildInfoRow('Payment Method', transaction.paymentMethod),
              _buildInfoRow('Transaction ID', transaction.id),
              _buildInfoRow('Date', dateFormatter.format(transaction.date)),
              _buildInfoRow('Time', timeFormatter.format(transaction.date)),
              if (transaction.notes.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text('Notes', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(transaction.notes, style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B))),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B))),
        ],
      ),
    );
  }
}
