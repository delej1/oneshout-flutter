part of 'notifications_service.dart';

Future<void> messenger({int id = 0}) async {
  /// First two person objects will use icons that part of the Android app's
  /// drawable resources
  final me = await makePerson(
    name: 'Me',
    key: '1',
    uri: 'tel:1234567890',
    // icon: 'https://via.placeholder.com/48x48',
  );

  final coworker = await makePerson(
    name: 'Coworker',
    key: '2',
    uri: 'tel:9876543210',
    // icon: 'https://via.placeholder.com/48x48',
  );

  // this person object will use an icon that was downloaded
  final lunchBot = await makePerson(
    name: 'Lunch bot',
    key: 'bot',
    bot: true,
    // icon: 'https://via.placeholder.com/48x48',
  );

  final chef = await makePerson(
    name: 'Master Chef',
    key: '3',
    uri: 'tel:111222333444',
    // icon: 'https://placekitten.com/48/48',
  );

  final messages = <Message>[
    Message('Hi', DateTime.now(), me),
    Message(
      "What's up?",
      DateTime.now().add(const Duration(minutes: 5)),
      coworker,
    ),
    Message(
      'Lunch?',
      DateTime.now().add(const Duration(minutes: 10)),
      null,
    ),
    Message(
      'What kind of food would you prefer?',
      DateTime.now().add(const Duration(minutes: 10)),
      lunchBot,
    ),
    Message(
      'You do not have time eat! Keep working!',
      DateTime.now().add(const Duration(minutes: 11)),
      chef,
    ),
  ];

  await AppNotificationService().showMessagingNotification(
    id: id,
    messages: messages,
    me: me,
  );
}

void schedule() {
  final now = tz.TZDateTime.now(tz.local);
  var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 7);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  AppNotificationService().showScheduledNotification(
    data: NotificationData(
      scheduleDate: scheduledDate,
      title: 'Scheduled',
      body: 'Scheduled Body',
    ),
  );
}

void bigPicture() {
  AppNotificationService().showBigPictureNotification(
    NotificationData(
      title: 'Hello',
      body: 'Hello again',
      image: 'https://via.placeholder.com/400x800',
      // channel: NotificationChannel.normal,
    ),
  );
}

Future<void> groupedNotifications() async {
  // await AppNotificationService().showGroupedNotification(NotificationData());
  // return;
  final threadIdentifier =
      IOSNotificationAction().buildNotificationDetailsForThread('threader1');
  final messages = [
    NotificationData(
      id: 1,
      title: 'Hello',
      body: 'Hello again',
      icon: 'https://via.placeholder.com/400x800',
      groupKey: AndroidPlatformNotificationAction.inboxGroupChannelId,
      groupChannelId: AndroidPlatformNotificationAction.inboxChannelId,
      groupChannelName: AndroidPlatformNotificationAction.inboxChannelName,
      groupChannelDescription:
          AndroidPlatformNotificationAction.inboxChannelDescription,
      threadIdentifier: threadIdentifier,
    ),
    NotificationData(
      id: 2,
      title: 'Hello 2',
      body: 'Hello again 2',
      icon: 'https://via.placeholder.com/400x800',
      groupKey: AndroidPlatformNotificationAction.inboxGroupChannelId,
      groupChannelId: AndroidPlatformNotificationAction.inboxChannelId,
      groupChannelName: AndroidPlatformNotificationAction.inboxChannelName,
      groupChannelDescription:
          AndroidPlatformNotificationAction.inboxChannelDescription,
      threadIdentifier: threadIdentifier,
    ),
    NotificationData(
      id: 3,
      title: 'Hello 3',
      body: 'Hello again 3',
      icon: 'https://via.placeholder.com/400x800',
      groupKey: AndroidPlatformNotificationAction.inboxGroupChannelId,
      groupChannelId: AndroidPlatformNotificationAction.inboxChannelId,
      groupChannelName: AndroidPlatformNotificationAction.inboxChannelName,
      groupChannelDescription:
          AndroidPlatformNotificationAction.inboxChannelDescription,
      threadIdentifier: threadIdentifier,
    ),
    NotificationData(
      id: 3,
      title: 'Hello 3',
      body: 'Hello again 3',
      icon: 'https://via.placeholder.com/400x800',
      groupKey: AndroidPlatformNotificationAction.inboxGroupChannelId,
      groupChannelId: AndroidPlatformNotificationAction.inboxChannelId,
      groupChannelName: AndroidPlatformNotificationAction.inboxChannelName,
      groupChannelDescription:
          AndroidPlatformNotificationAction.inboxChannelDescription,
      threadIdentifier: threadIdentifier,
    ),
    NotificationData(
      id: 4,
      title: 'Hello 4',
      body: 'Hello again 4',
      icon: 'https://via.placeholder.com/400x800',
      groupKey: AndroidPlatformNotificationAction.inboxGroupChannelId,
      groupChannelId: AndroidPlatformNotificationAction.inboxChannelId,
      groupChannelName: AndroidPlatformNotificationAction.inboxChannelName,
      groupChannelDescription:
          AndroidPlatformNotificationAction.inboxChannelDescription,
      threadIdentifier: threadIdentifier,
    ),
    NotificationData(
      id: 5,
      title: 'Hello 5',
      body: 'Hello again 5',
      icon: 'https://via.placeholder.com/400x800',
      groupKey: AndroidPlatformNotificationAction.inboxGroupChannelId,
      groupChannelId: AndroidPlatformNotificationAction.inboxChannelId,
      groupChannelName: AndroidPlatformNotificationAction.inboxChannelName,
      groupChannelDescription:
          AndroidPlatformNotificationAction.inboxChannelDescription,
      threadIdentifier: threadIdentifier,
    ),
    NotificationData(
      id: 6,
      title: 'Hello 6',
      body: 'Hello again 6',
      icon: 'https://via.placeholder.com/400x800',
      groupKey: AndroidPlatformNotificationAction.inboxGroupChannelId,
      groupChannelId: AndroidPlatformNotificationAction.inboxChannelId,
      groupChannelName: AndroidPlatformNotificationAction.inboxChannelName,
      groupChannelDescription:
          AndroidPlatformNotificationAction.inboxChannelDescription,
      threadIdentifier: threadIdentifier,
    ),
  ];

  await AppNotificationService()
      .showGroupedNotification(items: messages, groupKey: 'thread id');
}
