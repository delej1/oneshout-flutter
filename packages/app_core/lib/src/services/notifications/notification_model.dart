import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:timezone/timezone.dart' as tz;

enum NotificationType { normal, inbox, scheduled, bigPicture }

enum NotificationChannel { normal, important }

class Notification {
  Notification({
    required this.notificationData,
  });

  factory Notification.fromRawJson(String str) =>
      Notification.fromJson(json.decode(str) as Map<String, dynamic>);

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        notificationData: NotificationData.fromJson(
          json['notification_data'] as Map<String, dynamic>,
        ),
      );
  final NotificationData notificationData;
}

class NotificationData {
  NotificationData({
    // required this.model,
    // required this.notification,
    this.id = 0,
    this.type = NotificationType.normal,
    this.channel = NotificationChannel.normal,
    this.important = true,
    this.channelId,
    this.channelName,
    this.channelDescription,
    this.groupKey,
    this.groupChannelId,
    this.groupChannelName,
    this.groupChannelDescription,
    this.threadIdentifier,
    this.style = 'normal',
    this.payload = const <String, dynamic>{},
    this.title = '',
    this.titleOverride,
    this.body = '',
    this.bodyOverride,
    this.image,
    this.icon,
    this.scheduleDate,
  });

  factory NotificationData.fromRawJson(String str) =>
      NotificationData.fromJson(json.decode(str) as Map<String, dynamic>);

  factory NotificationData.fromJson(
    Map<String, dynamic> json, {
    bool clean = true,
  }) {
    final pyl = json['payload'] == null
        ? '{}'
        : clean
            ? cleanJson(json['payload'] as String)
            : json['payload'] as String;

    return NotificationData(
      type: EnumToString.fromString(
        NotificationType.values,
        json['type'] == null
            ? NotificationType.normal.toString()
            : json['type'] as String,
      ),
      channel: EnumToString.fromString(
        NotificationChannel.values,
        json['channel'] == null
            ? NotificationChannel.normal.toString()
            : json['channel'] as String,
      ),
      id: json['id'] == null ? 0 : int.parse(json['id'].toString()),
      important: json['important'] == null ? true : json['important'] as bool,
      channelId: json['channelId'] == null ? null : json['channelId'] as String,
      channelName:
          json['channelName'] == null ? null : json['channelName'] as String,
      channelDescription: json['channelDescription'] == null
          ? null
          : json['channelDescription'] as String,
      groupKey: json['groupKey'] == null ? null : json['groupKey'] as String,
      groupChannelId: json['groupChannelId'] == null
          ? null
          : json['groupChannelId'] as String,
      groupChannelName: json['groupChannelName'] == null
          ? null
          : json['groupChannelName'] as String,
      groupChannelDescription: json['groupChannelDescription'] == null
          ? null
          : json['groupChannelDescription'] as String,
      threadIdentifier: json['threadIdentifier'] == null
          ? null
          : json['threadIdentifier'] as dynamic,
      style: json['style'] == null ? null : json['style'] as String,
      title: json['title'] as String,
      titleOverride: json['titleOverride'] == null
          ? null
          : json['titleOverride'] as String,
      body: json['body'] as String,
      bodyOverride:
          json['bodyOverride'] == null ? null : json['bodyOverride'] as String,
      image: json['image'] == null ? null : json['image'] as String,
      icon: json['icon'] == null ? null : json['icon'] as String,
      scheduleDate: json['scheduleDate'] == null
          ? null
          : json['scheduleDate'] as tz.TZDateTime,
      payload: jsonDecode(pyl) as Map<String, dynamic>,
    );
  }
  final int id;
  final NotificationType? type;
  final NotificationChannel? channel;
  final bool important;
  final String? channelId;
  final String? channelName;
  final String? channelDescription;
  final String? groupKey;
  final String? groupChannelId;
  final String? groupChannelName;
  final String? groupChannelDescription;
  final dynamic threadIdentifier;
  final String? style;
  final String title;
  final String? titleOverride;
  final String body;
  final String? bodyOverride;
  final String? image;
  final String? icon;
  // final String groupId,
  final Map<String, dynamic>? payload;
  tz.TZDateTime? scheduleDate;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': EnumToString.convertToString(type ?? NotificationType.normal),
        'channel':
            EnumToString.convertToString(channel ?? NotificationChannel.normal),
        'id': id,
        'important': important,
        'channelId': channelId,
        'channelName': channelName,
        'channelDescription': channelDescription,
        'groupKey': groupKey,
        'groupChannelId': groupChannelId,
        'groupChannelName': groupChannelName,
        'groupChannelDescription': groupChannelDescription,
        // 'threadIdentifier': threadIdentifier,
        'style': style,
        'title': title,
        'body': body,
        'image': image,
        'icon': icon,
        'payload': jsonEncode(payload),
        'scheduleDate': scheduleDate,
      };
}

String cleanJson(String data) {
  if (data.isEmpty) return '{}';
  var pyl = data.replaceFirst(RegExp('"'), '');
  pyl = pyl.substring(0, pyl.length - 1);
  // ignore: unnecessary_raw_strings
  pyl = pyl.replaceAll(r'\', r'');
  return pyl;
}
