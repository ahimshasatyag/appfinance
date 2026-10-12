import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../../../app/config/l10n.dart';

class WalletTransactionDetailSheet extends StatelessWidget {
  final WalletTransactionEntity transaction;
  final WalletEntity wallet;

  const WalletTransactionDetailSheet({super.key, required this.transaction, required this.wallet});

  String _getTransactionTypeName(BuildContext context, String type) {
    switch (type) {
      case 'Income':
        return context.l10n.income;
      case 'Expense':
        return context.l10n.expenses;
      case 'Transfer':
        return context.l10n.transfer;
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormatter = DateFormat('dd MMMM yyyy');
    final timeFormatter = DateFormat('HH:mm');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bool isExpense = transaction.type == 'Expense';
    final amountText = '${isExpense ? '- ' : ''}${currencyFormatter.format(transaction.amount)}';
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Header
              Center(
                child: Column(
                  children: [
                    Text(
                      transaction.merchant,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getTransactionTypeName(context, transaction.type),
                      style: TextStyle(
                        fontSize: 14,
                        color: isExpense ? Colors.redAccent : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      amountText,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${dateFormatter.format(transaction.date)}\n${timeFormatter.format(transaction.date)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              Text(
                context.l10n.transactionInformation,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(context, context.l10n.navWallet, '${wallet.name} ${wallet.accountNumber.isNotEmpty ? '•••• ${wallet.accountNumber.substring(wallet.accountNumber.length > 4 ? wallet.accountNumber.length - 4 : 0)}' : ''}'),
              _buildInfoRow(context, context.l10n.category, transaction.category),
              _buildInfoRow(context, context.l10n.merchant, transaction.merchant),
              _buildInfoRow(context, context.l10n.paymentMethod, transaction.paymentMethod),
              _buildInfoRow(context, context.l10n.transactionId, transaction.id),
              _buildInfoRow(context, context.l10n.date, dateFormatter.format(transaction.date)),
              _buildInfoRow(context, context.l10n.time, timeFormatter.format(transaction.date)),
              if (transaction.notes.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(context.l10n.notes, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  transaction.notes,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String title, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
