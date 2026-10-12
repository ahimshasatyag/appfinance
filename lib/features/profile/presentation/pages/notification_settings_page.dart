import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/config/l10n.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../notifications/presentation/pages/notification_center_page.dart';
import '../cubit/notification_settings_cubit.dart';
import '../widgets/notification_switch_tile.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if cubit is already provided in tree; if not, provide it
    Widget content = const NotificationSettingsView();
    try {
      context.read<NotificationSettingsCubit>();
      return content;
    } catch (_) {
      return BlocProvider(
        create: (_) => NotificationSettingsCubit(),
        child: content,
      );
    }
  }
}

class NotificationSettingsView extends StatelessWidget {
  const NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.l10n.notificationSettings,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
          ),
        ),
        actions: [
          IconButton(
            tooltip: context.l10n.notificationCenter,
            icon: Icon(
              Icons.notifications_outlined,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationCenterPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationSettingsCubit, NotificationSettingsState>(
        builder: (context, state) {
          final cubit = context.read<NotificationSettingsCubit>();

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              children: [
                // ==================== DO NOT DISTURB SECTION ====================
                _buildSectionHeader(context, context.l10n.quietModeSection),
                _buildDndCard(context, state, cubit, isDark),
                const SizedBox(height: 24),

                // ==================== MASTER NOTIFICATIONS SECTION ====================
                _buildSectionHeader(context, context.l10n.mainNotificationsSection),
                _buildCardContainer(
                  isDark,
                  children: [
                    NotificationSwitchTile(
                      icon: Icons.notifications_active_rounded,
                      iconColor: AppColors.primary,
                      title: context.l10n.allowAllNotifications,
                      subtitle: context.l10n.allowAllNotificationsSubtitle,
                      value: state.enableAllNotifications,
                      onChanged: (val) => cubit.setEnableAllNotifications(val),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ==================== FINANCIAL ALERTS ====================
                _buildSectionHeader(context, context.l10n.alertCategoriesSection),
                _buildCardContainer(
                  isDark,
                  children: [
                    NotificationSwitchTile(
                      icon: Icons.account_balance_wallet_rounded,
                      iconColor: const Color(0xFF10B981),
                      title: context.l10n.transactionsAndTransfers,
                      subtitle: context.l10n.transactionsAndTransfersSubtitle,
                      enabled: state.enableAllNotifications,
                      value: state.transactionAlerts,
                      onChanged: (val) => cubit.setTransactionAlerts(val),
                    ),
                    _buildDivider(context),
                    NotificationSwitchTile(
                      icon: Icons.receipt_long_rounded,
                      iconColor: const Color(0xFFEF4444),
                      title: context.l10n.billReminders,
                      subtitle: context.l10n.billRemindersSubtitle,
                      enabled: state.enableAllNotifications,
                      value: state.billReminders,
                      onChanged: (val) => cubit.setBillReminders(val),
                    ),
                    _buildDivider(context),
                    NotificationSwitchTile(
                      icon: Icons.pie_chart_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      title: context.l10n.budgetAlerts,
                      subtitle: context.l10n.budgetAlertsSubtitle,
                      enabled: state.enableAllNotifications,
                      value: state.budgetWarnings,
                      onChanged: (val) => cubit.setBudgetWarnings(val),
                    ),
                    _buildDivider(context),
                    NotificationSwitchTile(
                      icon: Icons.shield_rounded,
                      iconColor: const Color(0xFF3B82F6),
                      title: context.l10n.securityAndAccount,
                      subtitle: context.l10n.securityAndAccountSubtitle,
                      enabled: state.enableAllNotifications,
                      value: state.securityAlerts,
                      onChanged: (val) => cubit.setSecurityAlerts(val),
                    ),
                    _buildDivider(context),
                    NotificationSwitchTile(
                      icon: Icons.card_giftcard_rounded,
                      iconColor: const Color(0xFF8B5CF6),
                      title: context.l10n.promoAndCashback,
                      subtitle: context.l10n.promoAndCashbackSubtitle,
                      enabled: state.enableAllNotifications,
                      value: state.promoOffers,
                      onChanged: (val) => cubit.setPromoOffers(val),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ==================== SOUND & VIBRATION ====================
                _buildSectionHeader(context, context.l10n.soundAndVibrationSection),
                _buildCardContainer(
                  isDark,
                  children: [
                    NotificationSwitchTile(
                      icon: Icons.volume_up_rounded,
                      iconColor: const Color(0xFF06B6D4),
                      title: context.l10n.notificationSound,
                      subtitle: context.l10n.notificationSoundSubtitle,
                      enabled: state.enableAllNotifications && !state.isDoNotDisturb,
                      value: state.soundEnabled,
                      onChanged: (val) => cubit.setSoundEnabled(val),
                    ),
                    _buildDivider(context),
                    NotificationSwitchTile(
                      icon: Icons.vibration_rounded,
                      iconColor: const Color(0xFF64748B),
                      title: context.l10n.vibration,
                      subtitle: context.l10n.vibrationSubtitle,
                      enabled: state.enableAllNotifications && !state.isDoNotDisturb,
                      value: state.vibrationEnabled,
                      onChanged: (val) => cubit.setVibrationEnabled(val),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildDndCard(
    BuildContext context,
    NotificationSettingsState state,
    NotificationSettingsCubit cubit,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: state.isDoNotDisturb
              ? const Color(0xFF8B5CF6).withValues(alpha: 0.5)
              : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
          width: state.isDoNotDisturb ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: state.isDoNotDisturb
                ? const Color(0xFF8B5CF6).withValues(alpha: isDark ? 0.2 : 0.1)
                : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          NotificationSwitchTile(
            icon: Icons.do_not_disturb_on_rounded,
            iconColor: const Color(0xFF8B5CF6),
            title: context.l10n.doNotDisturb,
            subtitle: context.l10n.doNotDisturbSubtitle,
            value: state.isDoNotDisturb,
            onChanged: (val) {
              cubit.setDoNotDisturb(val);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    val
                        ? context.l10n.dndEnabledSnackbar
                        : context.l10n.dndDisabledSnackbar,
                  ),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          if (state.isDoNotDisturb) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(
                height: 1,
                color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.06),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF28254A)
                      : const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.bedtime_rounded,
                          size: 18,
                          color: Color(0xFF8B5CF6),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          context.l10n.quietScheduleTitle,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF4C1D95),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.quietScheduleSubtitle(
                        _formatTime(state.dndStartTime),
                        _formatTime(state.dndEndTime),
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: isDark ? Colors.white70 : const Color(0xFF6B21A8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _showTimeRangePicker(context, state, cubit),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1B4B) : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              size: 16,
                              color: Color(0xFF8B5CF6),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              context.l10n.changeQuietHours,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : const Color(0xFF6D28D9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCardContainer(bool isDark, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(
        height: 1,
        color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05),
      ),
    );
  }

  static String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static Future<void> _showTimeRangePicker(
    BuildContext context,
    NotificationSettingsState state,
    NotificationSettingsCubit cubit,
  ) async {
    final pickedStart = await showTimePicker(
      context: context,
      initialTime: state.dndStartTime,
      helpText: context.l10n.selectQuietStart,
    );
    if (pickedStart == null || !context.mounted) return;

    final pickedEnd = await showTimePicker(
      context: context,
      initialTime: state.dndEndTime,
      helpText: context.l10n.selectQuietEnd,
    );
    if (pickedEnd == null || !context.mounted) return;

    cubit.setDndSchedule(start: pickedStart, end: pickedEnd);
  }
}
