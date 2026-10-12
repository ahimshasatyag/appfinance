import 'package:flutter/material.dart';
import '../../../../app/config/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationDetailSheet extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onDelete;

  const NotificationDetailSheet({
    super.key,
    required this.notification,
    required this.onDelete,
  });

  static Future<void> show(
    BuildContext context, {
    required NotificationEntity notification,
    required VoidCallback onDelete,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NotificationDetailSheet(
        notification: notification,
        onDelete: onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeConfig = _getTypeConfig(context, notification.type);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header: Icon + Type + Time
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: typeConfig.color.withValues(alpha: isDark ? 0.2 : 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  typeConfig.icon,
                  color: typeConfig.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: typeConfig.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        typeConfig.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: typeConfig.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Formatters.formatDateTime(notification.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                color: isDark ? Colors.white70 : Colors.black54,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            notification.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Body
          Text(
            notification.body,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.white.withValues(alpha: 0.85) : Colors.black87,
            ),
          ),

          // Payload Info (if available)
          if (notification.payload != null && notification.payload!.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0F172A)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.additionalInformation,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...notification.payload!.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatKey(context, entry.key),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
                          Text(
                            _formatValue(entry.value),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: Text(context.l10n.delete),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    context.l10n.close,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatKey(BuildContext context, String key) {
    switch (key) {
      case 'amount':
        return context.l10n.amountLabel;
      case 'account':
        return context.l10n.accountLabel;
      case 'category':
        return context.l10n.categoryLabel;
      case 'transactionId':
        return context.l10n.transactionId;
      case 'dueDate':
        return context.l10n.dueDateLabel;
      case 'device':
        return context.l10n.deviceLabel;
      case 'location':
        return context.l10n.locationLabel;
      case 'promoCode':
        return context.l10n.promoCodeLabel;
      case 'wallet':
        return context.l10n.walletLabel;
      default:
        return key;
    }
  }

  static String _formatValue(dynamic value) {
    if (value is num) {
      return Formatters.formatCurrency(value.toDouble());
    }
    return value.toString();
  }

  static ({IconData icon, Color color, String label}) _getTypeConfig(
      BuildContext context, NotificationType type) {
    switch (type) {
      case NotificationType.transaction:
        return (
          icon: Icons.account_balance_wallet_rounded,
          color: const Color(0xFF10B981),
          label: context.l10n.typeTransaction,
        );
      case NotificationType.bill:
        return (
          icon: Icons.receipt_long_rounded,
          color: const Color(0xFFEF4444),
          label: context.l10n.typeBill,
        );
      case NotificationType.security:
        return (
          icon: Icons.shield_rounded,
          color: const Color(0xFFF59E0B),
          label: context.l10n.typeSecurity,
        );
      case NotificationType.promo:
        return (
          icon: Icons.card_giftcard_rounded,
          color: const Color(0xFF8B5CF6),
          label: context.l10n.typePromo,
        );
      case NotificationType.system:
        return (
          icon: Icons.notifications_active_rounded,
          color: AppColors.primary,
          label: context.l10n.typeSystem,
        );
    }
  }
}
