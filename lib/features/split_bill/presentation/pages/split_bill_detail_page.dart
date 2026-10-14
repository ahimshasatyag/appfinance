import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/config/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../data/datasources/split_bill_local_datasource.dart';
import '../../data/datasources/split_bill_remote_datasource.dart';
import '../../data/repositories/split_bill_repository_impl.dart';
import '../../domain/entities/bill_entity.dart';
import '../../domain/usecases/calculate_split_bill_usecase.dart';
import '../../domain/usecases/create_bill_usecase.dart';
import '../../domain/usecases/fetch_bill_history_usecase.dart';
import '../bloc/split_bill_bloc.dart';
import '../bloc/split_bill_event.dart';
import '../bloc/split_bill_state.dart';
import '../widgets/summary_card_widget.dart';
import '../widgets/split_bill_detail_skeleton.dart';

class SplitBillDetailPage extends StatefulWidget {
  final String billId;

  const SplitBillDetailPage({super.key, required this.billId});

  @override
  State<SplitBillDetailPage> createState() => _SplitBillDetailPageState();
}

class _SplitBillDetailPageState extends State<SplitBillDetailPage> {
  late final SplitBillBloc _bloc;

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
    )..add(LoadBillDetailEvent(widget.billId));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _showQrisModal(BuildContext context, BillEntity bill, MemberShareEntity? share) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final targetAmount = share?.totalAmount ?? bill.grandTotal;
    final targetName = share?.member.name ?? bill.title;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.qrisPayment,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(bottomSheetContext),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              targetName,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              Formatters.formatCurrency(targetAmount),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 20),

            // Simulated QRIS Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Image.network(
                    'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=QRIS_APPFINANCE_${bill.id}_${share?.member.id ?? "TOTAL"}',
                    width: 200,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey.shade100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.qr_code_2_rounded, size: 80, color: Colors.black87),
                          const SizedBox(height: 8),
                          Text(
                            context.l10n.qrisStandard,
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'QRIS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        context.l10n.allDigitalPayments,
                        style: const TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            CustomButton(
              text: context.l10n.close,
              onPressed: () => Navigator.pop(bottomSheetContext),
            ),
          ],
        ),
      ),
    );
  }

  void _copyShareText(BuildContext context, BillEntity bill) {
    final buffer = StringBuffer();
    buffer.writeln('📋 ${context.l10n.splitBillDetails}: ${bill.title}');
    buffer.writeln('📅 ${Formatters.formatDate(bill.date)}');
    buffer.writeln('💰 ${context.l10n.totalBill}: ${Formatters.formatCurrency(bill.grandTotal)}');
    buffer.writeln('------------------------------');

    for (final share in bill.breakdown) {
      final status = share.isPaid ? '✅ (${context.l10n.alreadyPaid})' : '⏳ (${context.l10n.statusPending})';
      buffer.writeln('${share.member.name}: ${Formatters.formatCurrency(share.totalAmount)} $status');
    }

    buffer.writeln('------------------------------');

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.copiedToClipboardSuccess),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<SplitBillBloc, SplitBillState>(
        builder: (context, state) {
          if (state is SplitBillLoading || state is SplitBillInitial) {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                iconTheme: IconThemeData(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
                title: Text(
                  context.l10n.splitBillDetails,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              body: const SplitBillDetailSkeleton(),
            );
          }

          if (state is SplitBillError) {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                iconTheme: IconThemeData(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
                title: Text(
                  context.l10n.splitBillDetails,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _bloc.add(LoadBillDetailEvent(widget.billId));
                      },
                      child: Text(context.l10n.tryAgain),
                    ),
                  ],
                ),
              ),
            );
          }

          final bill = (state as SplitBillDetailLoaded).bill;

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
              title: Text(
                context.l10n.splitBillDetails,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share_rounded),
                  tooltip: context.l10n.splitBillDetails,
                  onPressed: () => _copyShareText(context, bill),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Bill Overview Hero Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D6EFF), Color(0xFF0CBDE8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0D6EFF).withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
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
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: bill.isAllPaid
                                    ? Colors.green.withValues(alpha: 0.9)
                                    : Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                bill.isAllPaid ? context.l10n.statusSettled : context.l10n.statusPending,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          Formatters.formatDate(bill.date, format: 'EEEE, dd MMMM yyyy'),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.l10n.totalBill,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          Formatters.formatCurrency(bill.grandTotal),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.l10n.collectedAmount(bill.paidCount, bill.breakdown.length),
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    Formatters.formatCurrency(bill.totalCollected),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 24,
                              width: 1,
                              color: Colors.white24,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.l10n.remainingToCollect,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    Formatters.formatCurrency(bill.remainingToCollect),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 2. Who Pays What Section Header
                  Text(
                    context.l10n.whoPaysWhat(bill.breakdown.length),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Member Share Cards
                  ...bill.breakdown.map((share) {
                    final isMe = share.member.isCurrentUser;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: share.isPaid
                              ? Colors.green.withValues(alpha: 0.3)
                              : (isDark ? Colors.white12 : Colors.grey.shade200),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: share.isPaid
                                ? Colors.green.withValues(alpha: 0.15)
                                : AppTheme.primaryColor.withValues(alpha: 0.15),
                            child: Icon(
                              share.isPaid
                                  ? Icons.check_circle_rounded
                                  : Icons.person_rounded,
                              color: share.isPaid
                                  ? Colors.green
                                  : AppTheme.primaryColor,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                share.member.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1E293B),
                                ),
                              ),
                              if (isMe) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    context.l10n.me,
                                    style: const TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Text(
                            share.isPaid ? context.l10n.alreadyPaid : context.l10n.statusPending,
                            style: TextStyle(
                              fontSize: 12,
                              color: share.isPaid ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                Formatters.formatCurrency(share.totalAmount),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: share.isPaid
                                      ? Colors.green
                                      : AppTheme.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                context.l10n.details,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(height: 1),
                                  const SizedBox(height: 10),
                                  Text(
                                    context.l10n.enjoyedItems,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  ...share.assignedItems.map((item) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '• ${item.name}',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: isDark
                                                    ? Colors.white70
                                                    : const Color(0xFF1E293B),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            Formatters.formatCurrency(
                                              item.pricePerPerson,
                                            ),
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: isDark
                                                  ? Colors.white70
                                                  : const Color(0xFF1E293B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),

                                  if (share.taxShare > 0 || share.serviceShare > 0) ...[
                                    const SizedBox(height: 6),
                                    const Divider(height: 1),
                                    const SizedBox(height: 6),
                                    if (share.taxShare > 0)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            context.l10n.pb1Tax,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            Formatters.formatCurrency(share.taxShare),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (share.serviceShare > 0)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            context.l10n.serviceFee,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            Formatters.formatCurrency(share.serviceShare),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],

                                  const SizedBox(height: 14),

                                  // Action Bar per Member: Mark as Paid & QRIS
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            _showQrisModal(context, bill, share);
                                          },
                                          icon: const Icon(Icons.qr_code_2_rounded, size: 16),
                                          label: const Text('QRIS'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppTheme.primaryColor,
                                            side: const BorderSide(color: AppTheme.primaryColor),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            _bloc.add(
                                              ToggleMemberPaymentStatusEvent(
                                                billId: bill.id,
                                                memberId: share.member.id,
                                                isPaid: !share.isPaid,
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            share.isPaid
                                                ? Icons.undo_rounded
                                                : Icons.check_rounded,
                                            size: 16,
                                          ),
                                          label: Text(
                                            share.isPaid ? context.l10n.markAsUnpaid : context.l10n.markAsPaid,
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: share.isPaid
                                                ? Colors.grey.shade600
                                                : Colors.green,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            elevation: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  // 3. Bill Summary Card
                  SummaryCardWidget(bill: bill),

                  const SizedBox(height: 28),

                  // 4. Bottom Main Action Button: Show QRIS for entire bill
                  CustomButton(
                    text: context.l10n.showTotalQris,
                    onPressed: () => _showQrisModal(context, bill, null),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
