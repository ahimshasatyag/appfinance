import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/analytics_bloc.dart';
import '../widgets/analytics_card_summary.dart';
import '../widgets/analytics_chart_section.dart';
import '../widgets/analytics_filter_sheet.dart';
import '../widgets/analytics_skeleton.dart';
import '../widgets/analytics_header.dart';
import '../widgets/analytics_upcoming_bills.dart';
import '../widgets/analytics_recent_transactions.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../domain/entities/filter_entity.dart';
import '../../domain/entities/analytics_entity.dart';
import '../../domain/usecases/get_analytics_data_usecase.dart';
import '../../data/repositories/analytics_repository_impl.dart';
import '../../data/datasources/analytics_remote_datasource.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnalyticsBloc(
        getAnalyticsDataUseCase: GetAnalyticsDataUseCase(
          AnalyticsRepositoryImpl(AnalyticsRemoteDataSourceImpl()),
        ),
      )..add(LoadAnalyticsData(const FilterEntity())),
      child: const AnalyticsView(),
    );
  }
}

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            if (state is AnalyticsLoading || state is AnalyticsInitial) {
              return const AnalyticsSkeleton();
            } else if (state is AnalyticsError) {
              return Center(child: Text(state.message));
            } else if (state is AnalyticsLoaded) {
              return _buildContent(context, state.data, state.currentFilter);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AnalyticsEntity data,
    FilterEntity filter,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AnalyticsBloc>().add(LoadAnalyticsData(filter));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AnalyticsHeader(
            dateRange: filter.dateRange,
            onFilterTap: () => _showFilterSheet(context),
          ),
          const SizedBox(height: 24),
          _buildSummaryCards(data),
          const SizedBox(height: 24),
          AnalyticsChartSection(data: data),
          const SizedBox(height: 24),
          AnalyticsUpcomingBills(bills: data.upcomingBills),
          const SizedBox(height: 24),
          AnalyticsRecentTransactions(transactions: data.recentTransactions),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(AnalyticsEntity data) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.80, // slightly taller to fit texts
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        AnalyticsCardSummary(
          title: 'Total Balance',
          amount: currencyFormatter.format(data.totalBalance),
          percentageChange: data.balanceChangePercentage,
          icon: Icons.account_balance_wallet,
          iconColor: AppTheme.primaryColor,
          iconBackgroundColor: AppTheme.primaryColor.withOpacity(0.1),
        ),
        AnalyticsCardSummary(
          title: 'Total Income',
          amount: currencyFormatter.format(data.totalIncome),
          percentageChange: data.incomeChangePercentage,
          icon: Icons.arrow_downward,
          iconColor: Colors.green,
          iconBackgroundColor: Colors.green.withOpacity(0.1),
        ),
        AnalyticsCardSummary(
          title: 'Total Expense',
          amount: currencyFormatter.format(data.totalExpense),
          percentageChange: data.expenseChangePercentage,
          icon: Icons.arrow_upward,
          iconColor: Colors.redAccent,
          iconBackgroundColor: Colors.redAccent.withOpacity(0.1),
        ),
        AnalyticsCardSummary(
          title: 'Net Cash Flow',
          amount: currencyFormatter.format(data.netCashFlow),
          percentageChange: data.netCashFlowChangePercentage,
          icon: Icons.swap_vert,
          iconColor: Colors.purple,
          iconBackgroundColor: Colors.purple.withOpacity(0.1),
        ),
      ],
    );
  }

  void _showFilterSheet(BuildContext context) async {
    final currentState = context.read<AnalyticsBloc>().state;
    if (currentState is AnalyticsLoaded) {
      final newFilter = await showModalBottomSheet<FilterEntity>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) =>
            AnalyticsFilterSheet(initialFilter: currentState.currentFilter),
      );

      if (newFilter != null && context.mounted) {
        context.read<AnalyticsBloc>().add(LoadAnalyticsData(newFilter));
      }
    }
  }
}
