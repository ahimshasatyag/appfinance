import 'package:flutter/material.dart';
import '../../domain/entities/filter_entity.dart';
import '../../../../shared/theme/app_theme.dart';

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

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'Filter Analytics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Date Range',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: dateRanges.map((range) {
                final isSelected = selectedDateRange == range;
                return ChoiceChip(
                  label: Text(range),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryColor.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.primaryColor : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => selectedDateRange = range);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Account',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: accounts.map((account) {
                final isSelected = selectedAccount == account;
                return ChoiceChip(
                  label: Text(account),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryColor.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.primaryColor : Colors.black87,
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
                  'Apply Filter',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).cardColor,
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
