import 'package:flutter/material.dart';
import '../../../../app/config/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../domain/entities/bill_entity.dart';

class SummaryCardWidget extends StatelessWidget {
  final BillEntity bill;
  final VoidCallback? onEditTaxes;
  final bool showEditButton;

  const SummaryCardWidget({
    super.key,
    required this.bill,
    this.onEditTaxes,
    this.showEditButton = false,
  });

  Widget _buildRow({
    required String label,
    required String value,
    bool isBold = false,
    Color? valueColor,
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 15 : 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isBold ? null : Colors.grey.shade600,
            ),
          ),
          Text(
            isDiscount ? '- $value' : value,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor ?? (isBold ? AppTheme.primaryColor : null),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    context.l10n.costSummary,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              if (showEditButton && onEditTaxes != null)
                TextButton.icon(
                  onPressed: onEditTaxes,
                  icon: const Icon(Icons.tune_rounded, size: 16),
                  label: Text(context.l10n.taxesAndTip, style: const TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Subtotal
          _buildRow(
            label: context.l10n.orderSubtotal,
            value: Formatters.formatCurrency(bill.subtotal),
          ),

          // Tax
          if (bill.taxAmount > 0 || bill.taxPercentage > 0)
            _buildRow(
              label: '${context.l10n.pb1Tax} (${bill.taxPercentage.toStringAsFixed(bill.taxPercentage.truncateToDouble() == bill.taxPercentage ? 0 : 1)}%)',
              value: Formatters.formatCurrency(bill.taxAmount),
            ),

          // Service Charge
          if (bill.serviceAmount > 0 || bill.servicePercentage > 0)
            _buildRow(
              label: '${context.l10n.serviceFee} (${bill.servicePercentage.toStringAsFixed(bill.servicePercentage.truncateToDouble() == bill.servicePercentage ? 0 : 1)}%)',
              value: Formatters.formatCurrency(bill.serviceAmount),
            ),

          // Discount
          if (bill.discountAmount > 0)
            _buildRow(
              label: context.l10n.discountPromo,
              value: Formatters.formatCurrency(bill.discountAmount),
              valueColor: Colors.green,
              isDiscount: true,
            ),

          // Tip
          if (bill.tipAmount > 0)
            _buildRow(
              label: context.l10n.voluntaryTip,
              value: Formatters.formatCurrency(bill.tipAmount),
              valueColor: Colors.amber.shade700,
            ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),

          // Grand Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.totalBill,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              Text(
                Formatters.formatCurrency(bill.grandTotal),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
