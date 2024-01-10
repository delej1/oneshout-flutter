import 'package:app_core/src/services/notifications/notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationAction {
  Future<void> initialize();
  Future<void> showBigPictureNotification(NotificationData data);
  Future<void> showMessagingNotification({
    required int id,
    required Person me,
    NotificationData? data,
    String? conversationTitle,
    List<Message> messages = const <Message>[],
    NotificationDetails? notificationDetails,
  });
  Future<void> showGroupNotification({
    required List<NotificationData> items,
    required String groupKey,
  });
}
