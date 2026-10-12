import 'package:flutter/material.dart';
import '../../domain/entities/filter_entity.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../app/config/l10n.dart';

class AnalyticsFilterSheet extends StatefulWidget {
  final FilterEntity initialFilter;

  const AnalyticsFilterSheet({super.key, required this.initialFilter});

  @override
  State<AnalyticsFilterSheet> createState() => _AnalyticsFilterSheetState();
}

class _AnalyticsFilterSheetState extends State<AnalyticsFilterSheet> {
  late String selectedDateRange;
  late String selectedAccount;

  final dateRanges = ['This Week', 'This Month', 'Last 3 Months', 'This Year', 'Custom Range'];
  final accounts = ['All Accounts', 'Cash', 'Bank Account', 'E-Wallet', 'Credit Card'];

  @override
  void initState() {
    super.initState();
    selectedDateRange = widget.initialFilter.dateRange;
    selectedAccount = widget.initialFilter.account;
  }

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

  String _getAccountLabel(BuildContext context, String account) {
    switch (account) {
      case 'All Accounts':
        return context.l10n.allAccounts;
      case 'Cash':
        return context.l10n.cash;
      case 'Bank Account':
        return context.l10n.bankAccount;
      case 'E-Wallet':
        return context.l10n.eWallet;
      case 'Credit Card':
        return context.l10n.creditCard;
      default:
        return account;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
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
            const SizedBox(height: 16),
            Text(
              context.l10n.filterAnalytics,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.dateRange,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: dateRanges.map((range) {
                final isSelected = selectedDateRange == range;
                return ChoiceChip(
                  label: Text(_getDateRangeLabel(context, range)),
                  selected: isSelected,
                  selectedColor: isDark
                      ? AppTheme.primaryColor.withValues(alpha: 0.25)
                      : AppTheme.primaryColor.withValues(alpha: 0.12),
                  backgroundColor: isDark
                      ? const Color(0xFF0F172A)
                      : Colors.grey.shade100,
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  ),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? (isDark ? const Color(0xFF60A5FA) : AppTheme.primaryColor)
                        : (isDark ? Colors.white : Colors.black87),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => selectedDateRange = range);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.account,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: accounts.map((account) {
                final isSelected = selectedAccount == account;
                return ChoiceChip(
                  label: Text(_getAccountLabel(context, account)),
                  selected: isSelected,
                  selectedColor: isDark
                      ? AppTheme.primaryColor.withValues(alpha: 0.25)
                      : AppTheme.primaryColor.withValues(alpha: 0.12),
                  backgroundColor: isDark
                      ? const Color(0xFF0F172A)
                      : Colors.grey.shade100,
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  ),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? (isDark ? const Color(0xFF60A5FA) : AppTheme.primaryColor)
                        : (isDark ? Colors.white : Colors.black87),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => selectedAccount = account);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                    widget.initialFilter.copyWith(
                      dateRange: selectedDateRange,
                      account: selectedAccount,
                    ),
                  );
                },
                child: Text(
                  context.l10n.applyFilter,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
