import '../../domain/entities/notification_entity.dart';
import 'notification_event.dart';

abstract class NotificationState {
  const NotificationState();
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> allNotifications;
  final NotificationFilterType activeFilter;

  const NotificationLoaded({
    required this.allNotifications,
    this.activeFilter = NotificationFilterType.all,
  });

  int get unreadCount => allNotifications.where((n) => !n.isRead).length;

  List<NotificationEntity> get filteredNotifications {
    switch (activeFilter) {
      case NotificationFilterType.unread:
        return allNotifications.where((n) => !n.isRead).toList();
      case NotificationFilterType.transaction:
        return allNotifications
            .where((n) => n.type == NotificationType.transaction)
            .toList();
      case NotificationFilterType.bill:
        return allNotifications
            .where((n) => n.type == NotificationType.bill)
            .toList();
      case NotificationFilterType.security:
        return allNotifications
            .where((n) => n.type == NotificationType.security)
            .toList();
      case NotificationFilterType.all:
        return allNotifications;
    }
  }

  NotificationLoaded copyWith({
    List<NotificationEntity>? allNotifications,
    NotificationFilterType? activeFilter,
  }) {
    return NotificationLoaded(
      allNotifications: allNotifications ?? this.allNotifications,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);
}
