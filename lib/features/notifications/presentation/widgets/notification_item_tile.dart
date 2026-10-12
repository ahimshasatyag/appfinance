import 'package:flutter/material.dart';
import '../../../../app/config/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationItemTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;

  const NotificationItemTile({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeConfig = _getTypeConfig(notification.type);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.delete_outline, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              context.l10n.delete,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: notification.isRead
              ? (isDark ? const Color(0xFF1E293B) : Colors.white)
              : (isDark
                  ? const Color(0xFF26334D)
                  : const Color(0xFFF1F5FE)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: !notification.isRead
                ? AppColors.primary.withValues(alpha: 0.3)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.04)),
            width: !notification.isRead ? 1.2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Type Badge
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: typeConfig.color.withValues(alpha: isDark ? 0.2 : 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      typeConfig.icon,
                      color: typeConfig.color,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Content Body
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Title
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: notification.isRead
                                      ? FontWeight.w600
                                      : FontWeight.w700,
                                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Unread indicator dot
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Body description
                        Text(
                          notification.body,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.7)
                                : Colors.black87.withValues(alpha: 0.7),
                            height: 1.35,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        // Timestamp & Action row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatTimeAgo(context, notification.timestamp),
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.45)
                                    : Colors.black.withValues(alpha: 0.4),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_horiz,
                                size: 18,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.5)
                                    : Colors.black.withValues(alpha: 0.4),
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              color: isDark ? const Color(0xFF1E293B) : Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onSelected: (value) {
                                if (value == 'read') {
                                  onMarkAsRead();
                                } else if (value == 'delete') {
                                  onDelete();
                                }
                              },
                              itemBuilder: (context) => [
                                if (!notification.isRead)
                                  PopupMenuItem(
                                    value: 'read',
                                    height: 38,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline,
                                          size: 16,
                                          color: isDark ? Colors.white70 : Colors.black87,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          context.l10n.markAsRead,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: isDark ? Colors.white : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                PopupMenuItem(
                                  value: 'delete',
                                  height: 38,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.delete_outline,
                                        size: 16,
                                        color: Colors.redAccent,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        context.l10n.delete,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _formatTimeAgo(BuildContext context, DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) {
      return context.l10n.justNow;
    } else if (diff.inMinutes < 60) {
      return context.l10n.minutesAgo(diff.inMinutes);
    } else if (diff.inHours < 24) {
      return context.l10n.hoursAgo(diff.inHours);
    } else if (diff.inDays == 1) {
      return '${context.l10n.yesterday}, ${Formatters.formatDateTime(dateTime, format: "HH:mm")}';
    } else if (diff.inDays < 7) {
      return context.l10n.daysAgo(diff.inDays);
    } else {
      return Formatters.formatDateTime(dateTime, format: 'dd MMM, HH:mm');
    }
  }

  static _NotificationTypeConfig _getTypeConfig(NotificationType type) {
    switch (type) {
      case NotificationType.transaction:
        return const _NotificationTypeConfig(
          icon: Icons.account_balance_wallet_rounded,
          color: Color(0xFF10B981),
        );
      case NotificationType.bill:
        return const _NotificationTypeConfig(
          icon: Icons.receipt_long_rounded,
          color: Color(0xFFEF4444),
        );
      case NotificationType.security:
        return const _NotificationTypeConfig(
          icon: Icons.shield_rounded,
          color: Color(0xFFF59E0B),
        );
      case NotificationType.promo:
        return const _NotificationTypeConfig(
          icon: Icons.card_giftcard_rounded,
          color: Color(0xFF8B5CF6),
        );
      case NotificationType.system:
        return const _NotificationTypeConfig(
          icon: Icons.notifications_active_rounded,
          color: AppColors.primary,
        );
    }
  }
}

class _NotificationTypeConfig {
  final IconData icon;
  final Color color;

  const _NotificationTypeConfig({
    required this.icon,
    required this.color,
  });
}
