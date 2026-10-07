import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/custom_loading.dart';
import '../../domain/usecases/get_dashboard_data_usecase.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/stats_card.dart';
import '../widgets/stacked_card_slider.dart';
import '../widgets/recent_activity_list.dart';
import '../widgets/dashboard_skeleton.dart';
import '../../../../core/utils/formatters.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(
        getDashboardDataUseCase: GetDashboardDataUseCase(
          DashboardRepositoryImpl(
            remoteDataSource: DashboardRemoteDataSourceImpl(),
          ),
        ),
      )..add(LoadDashboardData()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading || state is DashboardInitial) {
            return const DashboardSkeleton();
          } else if (state is DashboardError) {
            return Center(child: Text(state.message));
          } else if (state is DashboardLoaded) {
            final data = state.data;
            return Stack(
              children: [
                // Top Teal Background
                Container(
                  height: 280,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        children: [
                          DashboardHeader(userName: data.userName),
                          const SizedBox(height: 10),
                              StackedCardSlider(
                                cards: [
                                  StatsCard(
                                    totalBalance: data.totalBalance,
                                    color: const Color(0xFF1544D3), // Blue
                                  ),
                                  const StatsCard(
                                    totalBalance: 8450.0,
                                    cardNumber: '9876 5432 ....',
                                    color: Color(0xFFF37A38), // Orange
                                  ),
                                  const StatsCard(
                                    totalBalance: 1200.0,
                                    cardNumber: '4567 8901 ....',
                                    color: Color(0xFFE85D75), // Pink
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              
                              // Kotak Income & Expenses
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5)),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                                              child: const Icon(Icons.arrow_downward, color: Colors.green, size: 20),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text('Income', style: TextStyle(color: Colors.grey, fontSize: 13)),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    Formatters.formatCurrency(data.income),
                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2B3A4A)),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5)),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                                              child: const Icon(Icons.arrow_upward, color: Colors.red, size: 20),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text('Expenses', style: TextStyle(color: Colors.grey, fontSize: 13)),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    Formatters.formatCurrency(data.expenses),
                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2B3A4A)),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 30),
                              Expanded(
                                child: RecentActivityList(transactions: data.recentTransactions),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
