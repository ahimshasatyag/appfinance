import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/config/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionDetailSheet extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionDetailSheet({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isIncome = transaction.type.toLowerCase() == 'income';
    final isTransfer = transaction.type.toLowerCase() == 'transfer';

    Color amountColor;
    String prefix;
    if (isIncome) {
      amountColor = const Color(0xFF10B981);
      prefix = '+ ';
    } else if (isTransfer) {
      amountColor = const Color(0xFF3B82F6);
      prefix = '';
    } else {
      amountColor = isDark ? Colors.white : AppColors.lightTextPrimary;
      prefix = '- ';
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
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

          // Title / Header
          Text(
            context.l10n.transactionInformation,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 20),

          // Big Amount
          Text(
            '$prefix${Formatters.formatCurrency(transaction.amount)}',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            transaction.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 24),

          // Info Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  context,
                  label: context.l10n.transactionId,
                  value: transaction.id,
                  isDark: isDark,
                  onCopy: () {
                    Clipboard.setData(ClipboardData(text: transaction.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('ID Transaksi disalin ke papan klip'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                _buildDivider(isDark),
                _buildInfoRow(
                  context,
                  label: 'Status',
                  value: transaction.status,
                  isDark: isDark,
                  valueColor: transaction.status.toLowerCase() == 'success'
                      ? const Color(0xFF10B981)
                      : (transaction.status.toLowerCase() == 'pending'
                          ? const Color(0xFFF59E0B)
                          : const Color(0xFFEF4444)),
                ),
                _buildDivider(isDark),
                _buildInfoRow(
                  context,
                  label: context.l10n.category,
                  value: transaction.category,
                  isDark: isDark,
                ),
                _buildDivider(isDark),
                _buildInfoRow(
                  context,
                  label: 'Akun / Dompet',
                  value: transaction.account,
                  isDark: isDark,
                ),
                _buildDivider(isDark),
                _buildInfoRow(
                  context,
                  label: context.l10n.date,
                  value: Formatters.formatDateTime(transaction.date),
                  isDark: isDark,
                ),
                if (transaction.notes != null && transaction.notes!.isNotEmpty) ...[
                  _buildDivider(isDark),
                  _buildInfoRow(
                    context,
                    label: 'Catatan',
                    value: transaction.notes!,
                    isDark: isDark,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Close Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                foregroundColor: isDark ? Colors.white : AppColors.lightTextPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    required bool isDark,
    Color? valueColor,
    VoidCallback? onCopy,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? (isDark ? Colors.white : AppColors.lightTextPrimary),
              ),
            ),
            if (onCopy != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onCopy,
                child: Icon(
                  Icons.copy_rounded,
                  size: 14,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        height: 1,
        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
      ),
    );
  }
}
