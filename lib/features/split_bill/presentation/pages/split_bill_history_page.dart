import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../app/config/l10n.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../data/datasources/split_bill_local_datasource.dart';
import '../../data/datasources/split_bill_remote_datasource.dart';
import '../../data/repositories/split_bill_repository_impl.dart';
import '../../domain/usecases/calculate_split_bill_usecase.dart';
import '../../domain/usecases/create_bill_usecase.dart';
import '../../domain/usecases/fetch_bill_history_usecase.dart';
import '../bloc/split_bill_bloc.dart';
import '../bloc/split_bill_event.dart';
import '../bloc/split_bill_state.dart';
import '../widgets/split_bill_history_skeleton.dart';
import 'create_split_bill_page.dart';
import 'split_bill_detail_page.dart';

class SplitBillHistoryPage extends StatefulWidget {
  const SplitBillHistoryPage({super.key});

  @override
  State<SplitBillHistoryPage> createState() => _SplitBillHistoryPageState();
}

class _SplitBillHistoryPageState extends State<SplitBillHistoryPage> {
  late final SplitBillBloc _bloc;
  String _selectedFilter = 'all'; // 'all', 'pending', 'settled'

  @override
  void initState() {
    super.initState();
    final localDs = SplitBillLocalDataSourceImpl();
    final remoteDs = SplitBillRemoteDataSourceImpl();
    final repo = SplitBillRepositoryImpl(
      remoteDataSource: remoteDs,
      localDataSource: localDs,
    );

    _bloc = SplitBillBloc(
      calculateUseCase: CalculateSplitBillUseCase(),
      createBillUseCase: CreateBillUseCase(repo),
      fetchBillHistoryUseCase: FetchBillHistoryUseCase(repo),
      repository: repo,
    )..add(const LoadBillHistoryEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
          title: Text(
            context.l10n.splitBill,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1E293B),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateSplitBillPage()),
            );
            _bloc.add(const LoadBillHistoryEvent());
          },
          backgroundColor: AppTheme.primaryColor,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: Text(
            context.l10n.createSplitBill,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<SplitBillBloc, SplitBillState>(
          builder: (context, state) {
            if (state is SplitBillLoading || state is SplitBillInitial) {
              return const SplitBillHistorySkeleton();
            }

            if (state is SplitBillError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _bloc.add(const LoadBillHistoryEvent()),
                      child: Text(context.l10n.tryAgain),
                    ),
                  ],
                ),
              );
            }

            final allBills = (state is SplitBillHistoryLoaded) ? state.bills : [];
            final filteredBills = allBills.where((b) {
              if (_selectedFilter == 'pending') return !b.isAllPaid;
              if (_selectedFilter == 'settled') return b.isAllPaid;
              return true;
            }).toList();

            return RefreshIndicator(
              onRefresh: () async {
                _bloc.add(const LoadBillHistoryEvent());
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: [
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('all', context.l10n.filterAll, allBills.length, isDark),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'pending',
                          context.l10n.filterPending,
                          allBills.where((b) => !b.isAllPaid).length,
                          isDark,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'settled',
                          context.l10n.filterSettled,
                          allBills.where((b) => b.isAllPaid).length,
                          isDark,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (filteredBills.isEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 60),
                      padding: const EdgeInsets.all(32),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.l10n.noBillsYet,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.l10n.noBillsDescription,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            text: context.l10n.createFirstSplitBill,
                            width: 220,
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CreateSplitBillPage(),
                                ),
                              );
                              _bloc.add(const LoadBillHistoryEvent());
                            },
                          ),
                        ],
                      ),
                    )
                  else
                    ...filteredBills.map((bill) {
                      return InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SplitBillDetailPage(billId: bill.id),
                            ),
                          );
                          _bloc.add(const LoadBillHistoryEvent());
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? Colors.white12 : Colors.grey.shade200,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: isDark ? 0.2 : 0.03,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      bill.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF1E293B),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: bill.isAllPaid
                                          ? Colors.green.withValues(alpha: 0.12)
                                          : Colors.orange.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      bill.isAllPaid ? context.l10n.statusSettled : context.l10n.statusPending,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: bill.isAllPaid
                                            ? Colors.green
                                            : Colors.orange.shade800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${Formatters.formatDate(bill.date)} • ${bill.members.length} Orang • ${bill.items.length} Item',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Divider(height: 1),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline_rounded,
                                        size: 16,
                                        color: bill.isAllPaid
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        context.l10n.peoplePaidCount(bill.paidCount, bill.breakdown.length),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: isDark
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    Formatters.formatCurrency(bill.grandTotal),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String filterValue,
    String label,
    int count,
    bool isDark,
  ) {
    final isSelected = _selectedFilter == filterValue;
    return ChoiceChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      selectedColor: AppTheme.primaryColor,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected
            ? Colors.white
            : (isDark ? Colors.white70 : const Color(0xFF1E293B)),
      ),
      side: BorderSide(
        color: isSelected
            ? AppTheme.primaryColor
            : (isDark ? Colors.white12 : Colors.grey.shade300),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = filterValue;
          });
        }
      },
    );
  }
}
