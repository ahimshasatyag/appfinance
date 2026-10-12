import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../domain/entities/transaction_entity.dart';
import 'transaction_detail_sheet.dart';

class TransactionCardWidget extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionCardWidget({
    super.key,
    required this.transaction,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food & dining':
      case 'food':
        return Icons.restaurant_rounded;
      case 'salary':
      case 'gaji':
        return Icons.account_balance_wallet_rounded;
      case 'shopping':
      case 'belanja':
        return Icons.shopping_bag_rounded;
      case 'bills & utilities':
      case 'bills':
      case 'tagihan':
        return Icons.receipt_long_rounded;
      case 'transport':
      case 'transportasi':
        return Icons.directions_car_rounded;
      case 'entertainment':
      case 'hiburan':
        return Icons.sports_esports_rounded;
      case 'investment':
      case 'investasi':
        return Icons.trending_up_rounded;
      case 'transfer':
        return Icons.swap_horiz_rounded;
      case 'education':
      case 'pendidikan':
        return Icons.school_rounded;
      default:
        return Icons.payments_rounded;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food & dining':
      case 'food':
        return const Color(0xFFF97316); // Orange
      case 'salary':
      case 'gaji':
        return const Color(0xFF10B981); // Emerald
      case 'shopping':
      case 'belanja':
        return const Color(0xFF8B5CF6); // Purple
      case 'bills & utilities':
      case 'bills':
      case 'tagihan':
        return const Color(0xFFEAB308); // Yellow
      case 'transport':
      case 'transportasi':
        return const Color(0xFF06B6D4); // Cyan
      case 'entertainment':
      case 'hiburan':
        return const Color(0xFFEC4899); // Pink
      case 'investment':
      case 'investasi':
        return const Color(0xFF14B8A6); // Teal
      case 'transfer':
        return const Color(0xFF3B82F6); // Blue
      default:
        return const Color(0xFF64748B); // Slate
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final catColor = _getCategoryColor(transaction.category);
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
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (ctx) => TransactionDetailSheet(transaction: transaction),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                // Category Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: isDark ? 0.2 : 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Icon(
                      _getCategoryIcon(transaction.category),
                      color: catColor,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Title and Meta Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${transaction.category} · ${transaction.account}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          _buildStatusBadge(transaction.status, isDark),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Amount and Time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$prefix${Formatters.formatCurrency(transaction.amount)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: amountColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Formatters.formatDate(transaction.date, format: 'dd MMM, HH:mm'),
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    Color bg;
    Color text;

    switch (status.toLowerCase()) {
      case 'success':
        bg = const Color(0xFF10B981).withValues(alpha: isDark ? 0.25 : 0.12);
        text = const Color(0xFF10B981);
        break;
      case 'pending':
        bg = const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.25 : 0.12);
        text = const Color(0xFFF59E0B);
        break;
      case 'failed':
        bg = const Color(0xFFEF4444).withValues(alpha: isDark ? 0.25 : 0.12);
        text = const Color(0xFFEF4444);
        break;
      default:
        bg = Colors.grey.withValues(alpha: 0.15);
        text = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }
}
