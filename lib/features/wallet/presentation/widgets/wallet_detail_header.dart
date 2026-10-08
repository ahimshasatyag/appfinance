import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../../../shared/theme/app_theme.dart';

class WalletDetailHeader extends StatelessWidget {
  final WalletEntity wallet;
  
  const WalletDetailHeader({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            wallet.status,
            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        const SizedBox(height: 16),
        Text(wallet.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
        if (wallet.accountNumber.isNotEmpty)
          Text('${wallet.type} • ${wallet.accountNumber}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 12),
        Text(currencyFormatter.format(wallet.balance), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
        const SizedBox(height: 8),
        const Text('Last updated: Today, 14:32', style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
