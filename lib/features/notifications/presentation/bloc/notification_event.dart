enum NotificationFilterType {
  all,
  unread,
  transaction,
  bill,
  security,
}

abstract class NotificationEvent {
  const NotificationEvent();
}

class LoadNotifications extends NotificationEvent {
  final bool forceRefresh;
  const LoadNotifications({this.forceRefresh = false});
}

class MarkNotificationAsRead extends NotificationEvent {
  final String id;
  const MarkNotificationAsRead(this.id);
}

class MarkAllNotificationsAsRead extends NotificationEvent {
  const MarkAllNotificationsAsRead();
}

class DeleteNotification extends NotificationEvent {
  final String id;
  const DeleteNotification(this.id);
}

class FilterNotifications extends NotificationEvent {
  final NotificationFilterType filter;
  const FilterNotifications(this.filter);
}
