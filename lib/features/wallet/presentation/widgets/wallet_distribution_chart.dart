import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../../../shared/theme/app_theme.dart';

class WalletDistributionChart extends StatelessWidget {
  final List<WalletEntity> wallets;
  final double totalBalance;

  const WalletDistributionChart({
    super.key,
    required this.wallets,
    required this.totalBalance,
  });

  Color _getColorForIndex(int index) {
    final colors = [
      AppTheme.primaryColor,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.redAccent,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final validWallets = wallets.where((w) => w.balance > 0).toList();
    validWallets.sort((a, b) => b.balance.compareTo(a.balance));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Balance Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          if (validWallets.isEmpty)
             const SizedBox(height: 150, child: Center(child: Text('No data'))),
          if (validWallets.isNotEmpty)
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 60,
                      sections: validWallets.asMap().entries.map((entry) {
                        final index = entry.key;
                        final wallet = entry.value;
                        final percentage = (wallet.balance / totalBalance) * 100;
                        return PieChartSectionData(
                          color: _getColorForIndex(index),
                          value: wallet.balance,
                          title: '${percentage.toInt()}%',
                          radius: 20,
                          titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                        );
                      }).toList(),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(currencyFormatter.format(totalBalance), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const Text('Total Balance', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          if (validWallets.isNotEmpty)
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: validWallets.asMap().entries.map((entry) {
                final index = entry.key;
                final wallet = entry.value;
                final percentage = (wallet.balance / totalBalance) * 100;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: _getColorForIndex(index))),
                    const SizedBox(width: 6),
                    Text('${wallet.name} — ${percentage.toInt()}%', style: const TextStyle(fontSize: 12)),
                  ],
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
