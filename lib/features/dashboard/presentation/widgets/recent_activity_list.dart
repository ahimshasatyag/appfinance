import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/transaction_entity.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../../../../core/utils/formatters.dart';

class RecentActivityList extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const RecentActivityList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transactions History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'See all',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(LoadDashboardData());
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80.0), // Ruang ekstra di bawah untuk Bottom Navigation
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  return _buildTransactionItem(tx);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTransactionItem(TransactionEntity tx) {
    IconData getIcon(String label) {
      final text = label.toLowerCase();
      if (text.contains('education')) return Icons.school;
      if (text.contains('shop')) return Icons.shopping_bag;
      if (text.contains('food')) return Icons.restaurant;
      if (text.contains('movie')) return Icons.movie;
      if (text.contains('coffee')) return Icons.local_cafe;
      return Icons.attach_money;
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(getIcon(tx.iconUrl), color: Colors.orange, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  tx.date,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            '${tx.isExpense ? '' : '+'}${Formatters.formatCurrency(tx.amount)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: tx.isExpense ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
