import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../models/notification.dart';
import '../providers/notification_provider.dart';
import '../providers/project_provider.dart';
import '../widgets/notification_item.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, provider, _) {
              if (provider.unreadCount == 0) return const SizedBox();
              return TextButton(
                onPressed: () => provider.markAllAsRead(),
                child: const Text('Mark all read'),
              );
            },
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = provider.notifications;

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: AppTheme.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Notifications',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You\'re all caught up!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          final groupedNotifications = _groupNotificationsByDate(notifications);

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: groupedNotifications.length,
            itemBuilder: (context, index) {
              final group = groupedNotifications[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      group.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  ...group.notifications.map((notification) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NotificationItem(
                        notification: notification,
                        onTap: () => _handleNotificationTap(context, notification, provider),
                      ),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<_NotificationGroup> _groupNotificationsByDate(List<AppNotification> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayNotifications = <AppNotification>[];
    final yesterdayNotifications = <AppNotification>[];
    final olderNotifications = <AppNotification>[];

    for (final notification in notifications) {
      final notificationDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );

      if (notificationDate == today) {
        todayNotifications.add(notification);
      } else if (notificationDate == yesterday) {
        yesterdayNotifications.add(notification);
      } else {
        olderNotifications.add(notification);
      }
    }

    final groups = <_NotificationGroup>[];
    if (todayNotifications.isNotEmpty) {
      groups.add(_NotificationGroup('Today', todayNotifications));
    }
    if (yesterdayNotifications.isNotEmpty) {
      groups.add(_NotificationGroup('Yesterday', yesterdayNotifications));
    }
    if (olderNotifications.isNotEmpty) {
      groups.add(_NotificationGroup('Earlier', olderNotifications));
    }

    return groups;
  }

  void _handleNotificationTap(
    BuildContext context,
    AppNotification notification,
    NotificationProvider provider,
  ) {
    provider.markAsRead(notification.id);

    if (notification.projectId != null) {
      final projectProvider = context.read<ProjectProvider>();
      final project = projectProvider.getProjectById(notification.projectId!);
      if (project != null) {
        Navigator.pushNamed(
          context,
          AppRoutes.projectDetail,
          arguments: project,
        );
      }
    }
  }
}

class _NotificationGroup {
  final String title;
  final List<AppNotification> notifications;

  _NotificationGroup(this.title, this.notifications);
}