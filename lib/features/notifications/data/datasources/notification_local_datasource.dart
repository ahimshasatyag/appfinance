import '../models/notification_model.dart';

abstract class NotificationLocalDataSource {
  Future<List<NotificationModel>> getCachedNotifications();
  Future<void> cacheNotifications(List<NotificationModel> notifications);
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String id);
  Future<void> clearAll();
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  // In-memory local cache persisting during the app session
  final List<NotificationModel> _cache = [];
  bool _hasCached = false;

  @override
  Future<List<NotificationModel>> getCachedNotifications() async {
    if (!_hasCached) {
      return [];
    }
    return List.unmodifiable(_cache);
  }

  @override
  Future<void> cacheNotifications(List<NotificationModel> notifications) async {
    _cache.clear();
    _cache.addAll(notifications);
    _hasCached = true;
  }

  @override
  Future<void> markAsRead(String id) async {
    final index = _cache.indexWhere((n) => n.id == id);
    if (index != -1) {
      final updated = NotificationModel(
        id: _cache[index].id,
        title: _cache[index].title,
        body: _cache[index].body,
        type: _cache[index].type,
        timestamp: _cache[index].timestamp,
        isRead: true,
        payload: _cache[index].payload,
      );
      _cache[index] = updated;
    }
  }

  @override
  Future<void> markAllAsRead() async {
    for (int i = 0; i < _cache.length; i++) {
      if (!_cache[i].isRead) {
        _cache[i] = NotificationModel(
          id: _cache[i].id,
          title: _cache[i].title,
          body: _cache[i].body,
          type: _cache[i].type,
          timestamp: _cache[i].timestamp,
          isRead: true,
          payload: _cache[i].payload,
        );
      }
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    _cache.removeWhere((n) => n.id == id);
  }

  @override
  Future<void> clearAll() async {
    _cache.clear();
    _hasCached = true;
  }
}
