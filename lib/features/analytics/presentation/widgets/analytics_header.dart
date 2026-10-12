import 'package:flutter/material.dart';
import '../../../../app/config/l10n.dart';

class AnalyticsHeader extends StatelessWidget {
  final String dateRange;
  final VoidCallback onFilterTap;

  const AnalyticsHeader({
    super.key,
    required this.dateRange,
    required this.onFilterTap,
  });

  String _getDateRangeLabel(BuildContext context, String range) {
    switch (range) {
      case 'This Week':
        return context.l10n.thisWeek;
      case 'This Month':
        return context.l10n.thisMonth;
      case 'Last 3 Months':
        return context.l10n.last3Months;
      case 'This Year':
        return context.l10n.thisYear;
      case 'Custom Range':
        return context.l10n.customRange;
      default:
        return range;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.navAnalytics,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900
              ),
            ),
            InkWell(
              onTap: onFilterTap,
              borderRadius: BorderRadius.circular(12),
              child: Builder(
                builder: (context) {
                  final isDark = Theme.of(context).brightness == Brightness.dark;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_list,
                          size: 16,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getDateRangeLabel(context, dateRange),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          context.l10n.analyticsSubtitle,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
