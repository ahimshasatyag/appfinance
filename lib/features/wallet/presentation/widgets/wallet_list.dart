import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../../../app/config/l10n.dart';
import 'wallet_card.dart';

class WalletList extends StatelessWidget {
  final List<WalletEntity> wallets;

  const WalletList({super.key, required this.wallets});

  String _getTypeDisplayName(BuildContext context, String type) {
    switch (type) {
      case 'Bank Account':
        return context.l10n.bankAccount;
      case 'E-Wallet':
        return context.l10n.eWallet;
      case 'Cash':
        return context.l10n.cash;
      case 'Credit Card':
        return context.l10n.creditCard;
      case 'Investment':
        return context.l10n.investment;
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedWallets = <String, List<WalletEntity>>{};
    for (var w in wallets) {
      if (!groupedWallets.containsKey(w.type)) {
        groupedWallets[w.type] = [];
      }
      groupedWallets[w.type]!.add(w);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.l10n.myWallets, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {},
              child: Text(context.l10n.seeAll),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...groupedWallets.entries.map((entry) {
          final type = entry.key;
          final typeWallets = entry.value;
          final typeTotal = typeWallets.fold(0.0, (sum, w) => sum + w.balance);
          final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_getTypeDisplayName(context, type), style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey)),
                    Text('${currencyFormatter.format(typeTotal)} • ${typeWallets.length} ${context.l10n.walletsCount}', style: TextStyle(fontSize: 12, color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey)),
                  ],
                ),
              ),
              ...typeWallets.map((wallet) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: WalletCard(wallet: wallet),
              )).toList(),
              const SizedBox(height: 8),
            ],
          );
        }).toList(),
      ],
    );
  }
}
