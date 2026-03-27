import 'package:flutter/material.dart';

import '../../../data/repositories/notification_repository.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationRepository _notificationRepository =
      NotificationRepository();

  List<AppNotification> _notifications = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _notificationRepository.getAll();
    if (!mounted) {
      return;
    }
    setState(() {
      _notifications = data;
      _loading = false;
    });
  }

  Future<void> _markAllRead() async {
    await _notificationRepository.markAllRead();
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: _notifications.isEmpty ? null : _markAllRead,
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const Center(child: Text('No notifications yet'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return Card(
                      child: ListTile(
                        onTap: () async {
                          if (!notification.isRead) {
                            await _notificationRepository
                                .markRead(notification.id);
                            if (!mounted) {
                              return;
                            }
                            await _load();
                          }
                        },
                        leading: CircleAvatar(
                          backgroundColor: notification.isRead
                              ? Theme.of(context).colorScheme.surfaceVariant
                              : Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(
                            notification.isRead
                                ? Icons.notifications_none_rounded
                                : Icons.notifications_active_rounded,
                          ),
                        ),
                        title: Text(notification.title),
                        subtitle: Text(notification.message),
                        trailing: notification.isRead
                            ? const Icon(Icons.done_rounded)
                            : Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                      ),
                    );
                  },
                ),
    );
  }
}
