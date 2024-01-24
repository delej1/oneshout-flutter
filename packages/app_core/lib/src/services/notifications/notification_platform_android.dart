// import 'package:app_core/src/services/notifications/i_notification_platform.dart';

// import 'package:app_core/src/services/notifications/notifications.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
part of 'notifications_service.dart';

class AndroidPlatformNotificationAction extends AppNotificationService
    implements NotificationAction {
  static String inboxGroupChannelId = 'inbox_group_channel_id';
  static String inboxGroupChannelName = 'inbox group channel name';
  static String inboxGroupChannelDescription =
      'inbox group channel description';

  static String inboxChannelId = 'inbox_channel_id';
  static String inboxChannelName = 'inbox channel name';
  static String inboxChannelDescription = 'inbox channel description';

  static String lowImportanceNotificationChannelId =
      'lowImportanceNotification_channel_id';
  static String lowImportanceNotificationChannelName =
      'lowImportanceNotification channel name';
  static String lowImportanceNotificationChannelDescription =
      'lowImportanceNotification channel description';

  static String highImportanceNotificationChannelId =
      'highImportanceNotification_channel_id';
  static String highImportanceNotificationChannelName =
      'highImportanceNotification channel name';
  static String highImportanceNotificationChannelDescription =
      'highImportanceNotification channel description';

  @override
  Future<void> initialize() async {
    //Only proceed if this is Android
    if (!Platform.isAndroid) return;

    await _createChannelGroups();
    await _createChannels();
  }

  Future<void> _createChannelGroups() async {
    await createNotificationChannelGroup(
      channelGroupId: inboxGroupChannelId,
      channelGroupName: inboxGroupChannelName,
      channelGroupDescription: inboxGroupChannelDescription,
    );
  }

  Future<void> _createChannels() async {
    //messaging notification channel
    await createNotificationChannel(
      channelGroupId: inboxGroupChannelId,
      channelId: inboxChannelId,
      channelName: inboxChannelName,
      channelDescription: inboxChannelDescription,
      // importance: Importance.high,
    );

    ///high importance notification channel.
    await createNotificationChannel(
      channelId: highImportanceNotificationChannelId,
      channelName: highImportanceNotificationChannelName,
      channelDescription: highImportanceNotificationChannelDescription,
      importance: Importance.max,
    );

    ///low importance notification channel
    await createNotificationChannel(
      channelId: lowImportanceNotificationChannelId,
      channelName: lowImportanceNotificationChannelName,
      channelDescription: lowImportanceNotificationChannelDescription,
      importance: Importance.low,
    );

    logger.i('Created notification channels...');
  }

  @override
  Future<void> showBigPictureNotification(NotificationData data) async {
    final largeIcon = data.icon == null
        ? null
        : ByteArrayAndroidBitmap(
            await _getByteArrayFromUrl(data.icon!),
          );
    final bigPicture = data.image == null
        ? null
        : ByteArrayAndroidBitmap(
            await _getByteArrayFromUrl(data.image!),
          );

    if (bigPicture == null) return;

    final bigPictureStyleInformation = BigPictureStyleInformation(
      bigPicture,
      largeIcon: largeIcon,
      contentTitle: data.titleOverride ?? data.title,
      htmlFormatContentTitle: true,
      summaryText: data.bodyOverride ?? data.body,
      htmlFormatSummaryText: true,
    );

    //get default channel parameters if channel importance is specified.
    final channel = _getAndroidNotificationChannel(data.channel!);

    //use default, but override if custom channel parameters are specified.
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      data.channelId ?? channel.channelId,
      data.channelName ?? channel.channelName,
      channelDescription: data.channelDescription ?? channel.channelDescription,
      styleInformation: bigPictureStyleInformation,
      importance: Importance.max,
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      data.title,
      data.body,
      platformChannelSpecifics,
      payload: data.toRawJson(),
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
    final platformNotificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        data?.channelId ?? inboxChannelId,
        data?.channelName ?? inboxChannelName,
        channelDescription: data?.channelDescription ?? inboxChannelDescription,
        groupKey: data?.groupKey ?? inboxGroupChannelId,
        category: AndroidNotificationCategory.message,
        styleInformation: MessagingStyleInformation(
          me,
          groupConversation: true,
          conversationTitle: conversationTitle,
          htmlFormatContent: true,
          htmlFormatTitle: true,
          messages: messages,
        ),
      ),
    );

    //Show the notification
    await flutterLocalNotificationsPlugin.show(
      id,
      '',
      '',
      platformNotificationDetails,
      payload: data?.toRawJson(),
    );
  }

  @override
  Future<void> showGroupNotification({
    required List<NotificationData> items,
    required String groupKey,
  }) async {
    for (final data in items) {
      final groupKey = data.groupKey;
      final groupChannelId = data.groupChannelId;
      final groupChannelName = data.groupChannelName;
      final groupChannelDescription = data.groupChannelDescription;
      final largeIcon = data.icon == null
          ? null
          : ByteArrayAndroidBitmap(
              await _getByteArrayFromUrl(data.icon!),
            );

      // example based on https://developer.android.com/training/notify-user/group.html
      final androidSpecifics = AndroidNotificationDetails(
        groupChannelId!,
        groupChannelName!,
        channelDescription: groupChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: groupKey,
        largeIcon: largeIcon,
      );

      final platformSpecifics = NotificationDetails(
        android: androidSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        data.id,
        data.title,
        data.body,
        platformSpecifics,
        payload: data.toRawJson(),
      );

      // Create the summary notification to support older devices that pre-date
      /// Android 7.0 (API level 24).
      ///
      /// Recommended to create this regardless as the behaviour may vary as
      /// mentioned in https://developer.android.com/training/notify-user/group
      // const lines = <String>[
      //   'Alex Faarborg  Check this out',
      //   'Jeff Chang    Launch Party',
      //   'Jeff Chang    Launch Party'
      // ];

      const inboxStyleInformation = InboxStyleInformation(
        [],
        // contentTitle: '2 messages',
        summaryText: '24 messages from 5 chats',
      );

      final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        data.groupChannelId!,
        data.groupChannelName!,
        channelDescription: data.groupChannelDescription,
        styleInformation: inboxStyleInformation,
        groupKey: data.groupKey,
        setAsGroupSummary: true,
      );

      final platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        4,
        'Attention',
        'Two messages',
        platformChannelSpecifics,
      );
    }
  }
}
