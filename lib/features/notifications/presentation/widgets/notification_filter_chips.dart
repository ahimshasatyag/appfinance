import 'package:flutter/material.dart';
import '../../../../app/config/l10n.dart';
import '../../../../shared/theme/app_colors.dart';
import '../bloc/notification_event.dart';

class NotificationFilterChips extends StatelessWidget {
  final NotificationFilterType selectedFilter;
  final int unreadCount;
  final ValueChanged<NotificationFilterType> onFilterSelected;

  const NotificationFilterChips({
    super.key,
    required this.selectedFilter,
    required this.unreadCount,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filterItems = [
      (type: NotificationFilterType.all, label: context.l10n.filterAll, count: null),
      (type: NotificationFilterType.unread, label: context.l10n.filterUnread, count: unreadCount),
      (type: NotificationFilterType.transaction, label: context.l10n.filterTransactions, count: null),
      (type: NotificationFilterType.bill, label: context.l10n.filterBills, count: null),
      (type: NotificationFilterType.security, label: context.l10n.filterSecurity, count: null),
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: filterItems.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = filterItems[index];
          final isSelected = selectedFilter == item.type;

          return GestureDetector(
            onTap: () => onFilterSelected(item.type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark
                        ? const Color(0xFF1E293B)
                        : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.06)),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                  if (item.count != null && item.count! > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.25)
                            : AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${item.count}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
