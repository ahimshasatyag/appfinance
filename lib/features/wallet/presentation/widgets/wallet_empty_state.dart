import 'package:flutter/material.dart';
import '../../../../app/config/l10n.dart';

class WalletEmptyState extends StatelessWidget {
  const WalletEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Icon(Icons.account_balance_wallet_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 24),
          Text(
            context.l10n.emptyWallet,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.emptyWalletSubtitle,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
