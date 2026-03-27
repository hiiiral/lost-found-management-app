class AppNotification {
  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationRepository {
  static final NotificationRepository _instance =
      NotificationRepository._internal();

  factory NotificationRepository() => _instance;

  NotificationRepository._internal();

  final List<AppNotification> _notifications = [
    AppNotification(
      id: 'n1',
      title: 'Claim Update',
      message: 'Your backpack claim is now in review.',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    AppNotification(
      id: 'n2',
      title: 'Item Match Found',
      message: 'A matching laptop bag was reported in Library Block B.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  Future<List<AppNotification>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final list = List<AppNotification>.from(_notifications);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<void> add({required String title, required String message}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _notifications.add(
      AppNotification(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        message: message,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> markRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index < 0) {
      return;
    }
    _notifications[index] = _notifications[index].copyWith(isRead: true);
  }

  Future<void> markAllRead() async {
    await Future.delayed(const Duration(milliseconds: 100));
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }

  Future<int> unreadCount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _notifications.where((n) => !n.isRead).length;
  }
}
