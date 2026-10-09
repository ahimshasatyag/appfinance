import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../pages/wallet_detail_page.dart';

class WalletDetailSheet extends StatelessWidget {
  final WalletEntity wallet;

  const WalletDetailSheet({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            Text(wallet.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            if (wallet.accountNumber.isNotEmpty)
              Text('${wallet.type} • ${wallet.accountNumber}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 16),
            Text(currencyFormatter.format(wallet.balance), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
            const SizedBox(height: 32),
            _buildActionItem(context, Icons.info_outline, 'View Details', () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => WalletDetailPage(walletId: wallet.id)));
            }),
            _buildActionItem(
              context, 
              Icons.delete_outline, 
              'Delete Wallet', 
              () {
                Navigator.pop(context); // Close the bottom sheet first
                CustomDialog.showWarning(
                  context,
                  title: 'Delete Wallet',
                  message: 'Are you sure you want to delete this wallet? This action cannot be undone.',
                  confirmText: 'Delete',
                  onConfirm: () {
                    // Logic to delete wallet
                    CustomDialog.showSuccess(
                      context,
                      title: 'Deleted',
                      message: 'Wallet has been deleted successfully.',
                    );
                  },
                );
              }, 
              isDestructive: true,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    final defaultColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF1E293B);
    final color = isDestructive ? Colors.red : defaultColor;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}
