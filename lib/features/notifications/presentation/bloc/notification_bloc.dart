import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/delete_notification_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_all_as_read_usecase.dart';
import '../../domain/usecases/mark_as_read_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkAsReadUseCase markAsReadUseCase;
  final MarkAllAsReadUseCase markAllAsReadUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;

  NotificationBloc({
    required this.getNotificationsUseCase,
    required this.markAsReadUseCase,
    required this.markAllAsReadUseCase,
    required this.deleteNotificationUseCase,
  }) : super(const NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<MarkAllNotificationsAsRead>(_onMarkAllNotificationsAsRead);
    on<DeleteNotification>(_onDeleteNotification);
    on<FilterNotifications>(_onFilterNotifications);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    final currentFilter = state is NotificationLoaded
        ? (state as NotificationLoaded).activeFilter
        : NotificationFilterType.all;

    emit(const NotificationLoading());
    try {
      final notifications = await getNotificationsUseCase();
      emit(NotificationLoaded(
        allNotifications: notifications,
        activeFilter: currentFilter,
      ));
    } catch (e) {
      emit(NotificationError('Gagal memuat notifikasi: ${e.toString()}'));
    }
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      try {
        await markAsReadUseCase(event.id);
        final updatedList = currentState.allNotifications.map((n) {
          if (n.id == event.id) {
            return n.copyWith(isRead: true);
          }
          return n;
        }).toList();

        emit(currentState.copyWith(allNotifications: updatedList));
      } catch (_) {
        // If repository update fails, keep current state
      }
    }
  }

  Future<void> _onMarkAllNotificationsAsRead(
    MarkAllNotificationsAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      try {
        await markAllAsReadUseCase();
        final updatedList = currentState.allNotifications.map((n) {
          return n.copyWith(isRead: true);
        }).toList();

        emit(currentState.copyWith(allNotifications: updatedList));
      } catch (_) {
        // Handle error silently or notify
      }
    }
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      try {
        await deleteNotificationUseCase(event.id);
        final updatedList = currentState.allNotifications
            .where((n) => n.id != event.id)
            .toList();

        emit(currentState.copyWith(allNotifications: updatedList));
      } catch (_) {
        // Handle error
      }
    }
  }

  void _onFilterNotifications(
    FilterNotifications event,
    Emitter<NotificationState> emit,
  ) {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      emit(currentState.copyWith(activeFilter: event.filter));
    }
  }
}
