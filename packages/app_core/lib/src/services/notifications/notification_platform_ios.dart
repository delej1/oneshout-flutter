// ignore_for_file: use_late_for_private_fields_and_variables

part of 'notifications_service.dart';

class IOSNotificationAction extends AppNotificationService
    implements NotificationAction {
  static String inboxChannelId = 'inbox_channel_id';

  static String lowImportanceNotificationChannelId =
      'lowImportanceNotification_channel_id';

  static String highImportanceNotificationChannelId =
      'highImportanceNotification_channel_id';

  @override
  Future<void> initialize() async {
    // threadPlatformChannelSpecifics =
    //     buildNotificationDetailsForThread('ios_thread_notifc');
  }

  NotificationDetails buildNotificationDetailsForThread(
    String threadIdentifier,
  ) {
    final iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      threadIdentifier: threadIdentifier,
    );
    final macOSPlatformChannelSpecifics = DarwinNotificationDetails(
      threadIdentifier: threadIdentifier,
    );

    return NotificationDetails(
      iOS: iOSPlatformChannelSpecifics,
      macOS: macOSPlatformChannelSpecifics,
    );
  }

  @override
  Future<void> showBigPictureNotification(NotificationData data) async {
    final bigPicturePath = data.image == null && data.icon == null
        ? null
        : await _downloadAndSaveFile(
            data.icon ?? data.image!,
            'bigPicture.jpg',
          );

    if (bigPicturePath == null) return;

    final iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      attachments: <DarwinNotificationAttachment>[
        DarwinNotificationAttachment(bigPicturePath)
      ],
    );

    final macOSPlatformChannelSpecifics = DarwinNotificationDetails(
      attachments: <DarwinNotificationAttachment>[
        DarwinNotificationAttachment(bigPicturePath)
      ],
    );

    final notificationDetails = NotificationDetails(
      iOS: iOSPlatformChannelSpecifics,
      macOS: macOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      data.title,
      data.body,
      notificationDetails,
    );
  }

  @override
  Future<void> showMessagingNotification({
    required int id,
    required Person me,
    NotificationData? data,
    String? conversationTitle,
    List<Message> messages = const <Message>[],
    NotificationDetails? notificationDetails,
  }) async {
    // throw UnimplementedError();
  }

  @override
  Future<void> showGroupNotification({
    required List<NotificationData> items,
    required String groupKey,
  }) async {
    final threadPlatformChannelSpecific =
        buildNotificationDetailsForThread(groupKey);

    for (final item in items) {
      if (items.indexOf(item) < items.length - 1) {
        await flutterLocalNotificationsPlugin.show(
          item.id,
          item.title,
          item.body,
          threadPlatformChannelSpecific,
          payload: item.toRawJson(),
        );
      }
    }

    final item = items.last;
    await flutterLocalNotificationsPlugin.show(
      0,
      item.title,
      item.body,
      threadPlatformChannelSpecific,
      payload: item.toRawJson(),
    );
  }
}
