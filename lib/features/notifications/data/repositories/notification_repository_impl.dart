import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_datasource.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  final NotificationLocalDataSource localDataSource;

  NotificationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final cached = await localDataSource.getCachedNotifications();
    if (cached.isNotEmpty) {
      return cached.map((m) => m.toEntity()).toList();
    }

    // If cache is empty, fetch from remote
    final remoteNotifications = await remoteDataSource.fetchNotifications();
    await localDataSource.cacheNotifications(remoteNotifications);
    return remoteNotifications.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> markAsRead(String id) async {
    await localDataSource.markAsRead(id);
  }

  @override
  Future<void> markAllAsRead() async {
    await localDataSource.markAllAsRead();
  }

  @override
  Future<void> deleteNotification(String id) async {
    await localDataSource.deleteNotification(id);
  }

  @override
  Future<void> clearAllNotifications() async {
    await localDataSource.clearAll();
  }
}
