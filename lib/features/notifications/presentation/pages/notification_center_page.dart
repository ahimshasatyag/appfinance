import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/config/l10n.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../data/datasources/notification_local_datasource.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/delete_notification_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_all_as_read_usecase.dart';
import '../../domain/usecases/mark_as_read_usecase.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../widgets/notification_detail_sheet.dart';
import '../widgets/notification_empty_state.dart';
import '../widgets/notification_filter_chips.dart';
import '../widgets/notification_item_tile.dart';
import '../widgets/notification_skeleton.dart';

class NotificationCenterPage extends StatelessWidget {
  final NotificationBloc? bloc;

  const NotificationCenterPage({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    if (bloc != null) {
      return BlocProvider.value(
        value: bloc!,
        child: const NotificationCenterView(),
      );
    }

    return BlocProvider(
      create: (context) {
        final remoteDataSource = NotificationRemoteDataSourceImpl();
        final localDataSource = NotificationLocalDataSourceImpl();
        final repository = NotificationRepositoryImpl(
          remoteDataSource: remoteDataSource,
          localDataSource: localDataSource,
        );

        return NotificationBloc(
          getNotificationsUseCase: GetNotificationsUseCase(repository),
          markAsReadUseCase: MarkAsReadUseCase(repository),
          markAllAsReadUseCase: MarkAllAsReadUseCase(repository),
          deleteNotificationUseCase: DeleteNotificationUseCase(repository),
        )..add(const LoadNotifications());
      },
      child: const NotificationCenterView(),
    );
  }
}

class NotificationCenterView extends StatelessWidget {
  const NotificationCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<NotificationBloc, NotificationState>(
          listener: (context, state) {},
          builder: (context, state) {
            final unreadCount =
                state is NotificationLoaded ? state.unreadCount : 0;
            final activeFilter = state is NotificationLoaded
                ? state.activeFilter
                : NotificationFilterType.all;

            return Column(
              children: [
                // Top Custom App Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white12
                                  : Colors.black.withValues(alpha: 0.06),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Title & Unread Badge
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              context.l10n.notifications,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            if (unreadCount > 0) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  context.l10n.newNotificationsCount(unreadCount),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Action Button: Mark all as read
                      if (unreadCount > 0)
                        IconButton(
                          tooltip: context.l10n.markAllAsRead,
                          icon: const Icon(
                            Icons.done_all_rounded,
                            color: AppColors.primary,
                            size: 24,
                          ),
                          onPressed: () {
                            context
                                .read<NotificationBloc>()
                                .add(const MarkAllNotificationsAsRead());
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(context.l10n.allNotificationsMarkedAsRead),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),

                    ],
                  ),
                ),

                // Filter Chips
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: NotificationFilterChips(
                    selectedFilter: activeFilter,
                    unreadCount: unreadCount,
                    onFilterSelected: (filter) {
                      context
                          .read<NotificationBloc>()
                          .add(FilterNotifications(filter));
                    },
                  ),
                ),

                // Notification Content
                Expanded(
                  child: _buildBody(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificationState state) {
    if (state is NotificationLoading || state is NotificationInitial) {
      return const NotificationSkeleton();
    } else if (state is NotificationError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  context
                      .read<NotificationBloc>()
                      .add(const LoadNotifications(forceRefresh: true));
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(context.l10n.retry),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (state is NotificationLoaded) {
      final notifications = state.filteredNotifications;

      if (notifications.isEmpty) {
        return NotificationEmptyState(
          title: state.activeFilter == NotificationFilterType.unread
              ? context.l10n.noNewNotifications
              : context.l10n.noNotifications,
          subtitle: state.activeFilter == NotificationFilterType.unread
              ? context.l10n.allNotificationsReadSubtitle
              : context.l10n.noNotificationsCategorySubtitle,
          onRefresh: () {
            context
                .read<NotificationBloc>()
                .add(const LoadNotifications(forceRefresh: true));
          },
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          context
              .read<NotificationBloc>()
              .add(const LoadNotifications(forceRefresh: true));
        },
        color: AppColors.primary,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationItemTile(
              notification: notification,
              onTap: () {
                if (!notification.isRead) {
                  context
                      .read<NotificationBloc>()
                      .add(MarkNotificationAsRead(notification.id));
                }
                NotificationDetailSheet.show(
                  context,
                  notification: notification,
                  onDelete: () {
                    _deleteWithFeedback(context, notification);
                  },
                );
              },
              onMarkAsRead: () {
                context
                    .read<NotificationBloc>()
                    .add(MarkNotificationAsRead(notification.id));
              },
              onDelete: () {
                _deleteWithFeedback(context, notification);
              },
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _deleteWithFeedback(
    BuildContext context,
    NotificationEntity notification,
  ) {
    context.read<NotificationBloc>().add(DeleteNotification(notification.id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.notificationDeleted(notification.title)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
