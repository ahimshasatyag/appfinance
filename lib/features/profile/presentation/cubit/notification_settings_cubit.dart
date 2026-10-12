import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationSettingsState {
  final bool isDoNotDisturb;
  final TimeOfDay dndStartTime;
  final TimeOfDay dndEndTime;
  final bool enableAllNotifications;
  final bool transactionAlerts;
  final bool billReminders;
  final bool budgetWarnings;
  final bool securityAlerts;
  final bool promoOffers;
  final bool soundEnabled;
  final bool vibrationEnabled;

  const NotificationSettingsState({
    this.isDoNotDisturb = false,
    this.dndStartTime = const TimeOfDay(hour: 22, minute: 0),
    this.dndEndTime = const TimeOfDay(hour: 7, minute: 0),
    this.enableAllNotifications = true,
    this.transactionAlerts = true,
    this.billReminders = true,
    this.budgetWarnings = true,
    this.securityAlerts = true,
    this.promoOffers = false,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });

  NotificationSettingsState copyWith({
    bool? isDoNotDisturb,
    TimeOfDay? dndStartTime,
    TimeOfDay? dndEndTime,
    bool? enableAllNotifications,
    bool? transactionAlerts,
    bool? billReminders,
    bool? budgetWarnings,
    bool? securityAlerts,
    bool? promoOffers,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return NotificationSettingsState(
      isDoNotDisturb: isDoNotDisturb ?? this.isDoNotDisturb,
      dndStartTime: dndStartTime ?? this.dndStartTime,
      dndEndTime: dndEndTime ?? this.dndEndTime,
      enableAllNotifications:
          enableAllNotifications ?? this.enableAllNotifications,
      transactionAlerts: transactionAlerts ?? this.transactionAlerts,
      billReminders: billReminders ?? this.billReminders,
      budgetWarnings: budgetWarnings ?? this.budgetWarnings,
      securityAlerts: securityAlerts ?? this.securityAlerts,
      promoOffers: promoOffers ?? this.promoOffers,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }
}

class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  NotificationSettingsCubit() : super(const NotificationSettingsState());

  void setDoNotDisturb(bool value) {
    emit(state.copyWith(isDoNotDisturb: value));
  }

  void setDndSchedule({
    required TimeOfDay start,
    required TimeOfDay end,
  }) {
    emit(state.copyWith(dndStartTime: start, dndEndTime: end));
  }

  void setEnableAllNotifications(bool value) {
    emit(state.copyWith(
      enableAllNotifications: value,
      transactionAlerts: value ? state.transactionAlerts : false,
      billReminders: value ? state.billReminders : false,
      budgetWarnings: value ? state.budgetWarnings : false,
      securityAlerts: value ? state.securityAlerts : false,
      promoOffers: value ? state.promoOffers : false,
    ));
  }

  void setTransactionAlerts(bool value) {
    emit(state.copyWith(transactionAlerts: value));
  }

  void setBillReminders(bool value) {
    emit(state.copyWith(billReminders: value));
  }

  void setBudgetWarnings(bool value) {
    emit(state.copyWith(budgetWarnings: value));
  }

  void setSecurityAlerts(bool value) {
    emit(state.copyWith(securityAlerts: value));
  }

  void setPromoOffers(bool value) {
    emit(state.copyWith(promoOffers: value));
  }

  void setSoundEnabled(bool value) {
    emit(state.copyWith(soundEnabled: value));
  }

  void setVibrationEnabled(bool value) {
    emit(state.copyWith(vibrationEnabled: value));
  }
}
