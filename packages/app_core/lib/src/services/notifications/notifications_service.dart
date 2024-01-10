// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:app_core/injection.dart';
import 'package:app_core/src/services/notifications/i_notification_platform.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

part 'notification_platform_android.dart';
part 'notification_platform_ios.dart';
part 'notification_tests.dart';
part 'notification_types.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Got background message');
  await Firebase.initializeApp();
  final notifications = getItCore.get<AppNotificationService>();

  await notifications.notify(message);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

// const String portName = 'notification_send_port';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
      'notification action tapped with input: ${notificationResponse.input}',
    );
  }
}

@singleton

/// {@template app_notification_service}
/// Local and FCM Notification Service.
///
/// Types of notifications available:
/// 1. Basic Text Notification.
/// 2. Big Picture Notification [showBigPictureNotification].
/// 3. Messaging Style Notification.
/// 4. Inbox Style Notification.
/// {@endtemplate}
class AppNotificationService with UiLogger {
  AppNotificationService();

  String? _selectedNotificationPayload;

  late AndroidNotificationChannel _channel;

  late AndroidInitializationSettings _initializationSettingsAndroid;
  late DarwinInitializationSettings _initializationSettingsIOS;
  late DarwinInitializationSettings _initializationSettingsMacOS;

  // String? _androidNotificationSound;
  // String? _iOSNotificationSound;
  // String? _macOSNotificationSound;
  String _appIconDrawableName = 'app_icon';

  ///Initializes the Notification Service
  ///for Local notifications and Firebase Messaging.
  Future<void> init({
    String? androidNotificationSound,
    String? macOSNotificationSound,
    String? iOSNotificationSound,
    String? appIconDrawableName,
  }) async {
    // _androidNotificationSound = androidNotificationSound ?? 'slow_spring_board';
    // _iOSNotificationSound = iOSNotificationSound ?? 'slow_spring_board.aiff';
    // _macOSNotificationSound =
    //     macOSNotificationSound ?? 'slow_spring_board.aiff';
    _appIconDrawableName = appIconDrawableName ?? 'app_icon';
    // await FirebaseMessaging.instance.subscribeToTopic('Bridals');
    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _configureLocalTimeZone();
    await _initSettings();
    _messageInits();
    _requestPermissions();
    _configureSelectNotificationSubject();

    //Only proceed if this is Android
    if (Platform.isAndroid) {
      await AndroidPlatformNotificationAction().initialize();
    }
    //Only proceed if this is IOS or MacOS
    if (Platform.isIOS || Platform.isMacOS) {
      await IOSNotificationAction().initialize();
    }

    final notificationAppLaunchDetails = !kIsWeb && Platform.isLinux
        ? null
        : await flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      _selectedNotificationPayload =
          notificationAppLaunchDetails!.notificationResponse?.payload;
    }
  }

  Future<void> _initSettings() async {
    // initialise the plugin. app_icon needs to be a added
    //as a drawable resource to the Android head project
    _initializationSettingsAndroid =
        AndroidInitializationSettings(_appIconDrawableName);

    _initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    _initializationSettingsMacOS = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    //settings
    final initializationSettings = InitializationSettings(
      android: _initializationSettingsAndroid,
      iOS: _initializationSettingsIOS,
      macOS: _initializationSettingsMacOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: (String? payload) async {
      //   if (payload != null) {
      //     logger.d('notification payload: $payload');
      //   }
      //   _selectedNotificationPayload = payload;
      //   selectNotificationSubject.add(payload);
      // },
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            if (notificationResponse.payload != null) {
              logger.d('notification payload: ${notificationResponse.payload}');
            }
            _selectedNotificationPayload = notificationResponse.payload;

            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    if (!kIsWeb && Platform.isAndroid) {
      _channel = AndroidNotificationChannel(
        AndroidPlatformNotificationAction.highImportanceNotificationChannelId,
        AndroidPlatformNotificationAction.highImportanceNotificationChannelName,
        description: AndroidPlatformNotificationAction
            .highImportanceNotificationChannelDescription,
      );

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);
    }

    if (!kIsWeb && Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    if (!kIsWeb && Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
    final timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String? payload) async {
      logger.d('Notification Payload Recieved');

      if (payload != null) {
        final notificationData = NotificationData.fromJson(
          jsonDecode(payload) as Map<String, dynamic>,
          clean: false,
        );

        // payload is in notificationData.payload[].
        switch (notificationData.type) {
          case NotificationType.inbox:
            // TODO(tochiedev): Handle this case.
            break;
          case NotificationType.normal:
            // TODO(tochiedev): Handle this case.
            break;
          case null:
          case NotificationType.scheduled:
            // await showScheduledNotification()
            break;
          case NotificationType.bigPicture:
            await showBigPictureNotification(notificationData);
            break;
        }
      }
    });
  }

  ///FCM: initializes the message listeners.
  void _messageInits() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      logger.d('getInitialMessage');
      if (message != null) {}
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      logger.d('message recieved');
      await notify(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.d('A new onMessageOpenedApp event was published!');
    });
  }

  void _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    didReceiveLocalNotificationSubject.add(
      ReceivedNotification(
        id: id,
        title: title,
        body: body,
        payload: payload,
      ),
    );
  }

  void selectNotification(String? payload) {
    if (payload != null) {
      logger.d('selectNotification: Notification Payload Recieved');
    }
    _selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);

    //Navigate to screen if needed.
  }

  /// Show big picture notification.
  Future<void> showBigPictureNotification(NotificationData data) async {
    final android = AndroidPlatformNotificationAction();
    final ios = IOSNotificationAction();

    if (Platform.isAndroid) {
      await android.showBigPictureNotification(data);
    } else if (Platform.isIOS || Platform.isMacOS) {
      await ios.showBigPictureNotification(data);
    }
  }

  ///Show notifications for inbox messages
  ///
  Future<void> showMessagingNotification({
    required int id,
    required Person me,
    NotificationData? data,
    String? conversationTitle,
    List<Message> messages = const <Message>[],
    NotificationDetails? notificationDetails,
  }) async {
    final android = AndroidPlatformNotificationAction();
    final ios = IOSNotificationAction();

    if (Platform.isAndroid) {
      await android.showMessagingNotification(
        data: data,
        id: id,
        me: me,
        messages: messages,
        conversationTitle: conversationTitle,
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      await ios.showMessagingNotification(
        data: data,
        id: id,
        me: me,
      );
    }
  }

  /// Show grouped notification.
  Future<void> showGroupedNotification({
    required List<NotificationData> items,
    required String groupKey,
  }) async {
    final android = AndroidPlatformNotificationAction();
    final ios = IOSNotificationAction();

    if (Platform.isAndroid) {
      await android.showGroupNotification(
        items: items,
        groupKey: groupKey,
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      await ios.showGroupNotification(
        items: items,
        groupKey: groupKey,
      );
    }
  }

  ///Show Scheduled Notification.
  Future<void> showScheduledNotification({
    required NotificationData data,
  }) async {
    //date is required.
    if (data.scheduleDate == null) return;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      data.id,
      data.title,
      data.body,
      data.scheduleDate!,
      NotificationDetails(
        android: AndroidNotificationDetails(
          (data.important)
              ? AndroidPlatformNotificationAction
                  .highImportanceNotificationChannelId
              : AndroidPlatformNotificationAction
                  .lowImportanceNotificationChannelId,
          '',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  ///FCM: Shows a notification of the message
  Future<void> notify(RemoteMessage message) async {
    final data = NotificationData.fromJson(message.data);

    await show(
      data: NotificationData(),
      title: data.title,
      body: data.body,

      // importance: Importance.defaultImportance,
      largeIcon: DrawableResourceAndroidBitmap(_appIconDrawableName),
      payload: data.toRawJson(),
    );
  }

  ///Show a local notification message
  Future<void> show({
    NotificationData? data,
    int? id,
    String? title,
    String? body,
    String? payload,
    bool important = true,
    DrawableResourceAndroidBitmap? largeIcon,
    List<AndroidNotificationAction>? actions,
  }) async {
    final androidSpecifics = AndroidNotificationDetails(
      'one shout channel',
      '',
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'ticker',
      styleInformation: BigTextStyleInformation(data?.body ?? body ?? ''),
      icon: '@mipmap/ic_launcher',
      // largeIcon: largeIcon ?? const DrawableResourceAndroidBitmap('app_icon'),
      // sound: RawResourceAndroidNotificationSound('alarm'),
      // actions: actions,
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidSpecifics,
    );

    final ids = await flutterLocalNotificationsPlugin
        .pendingNotificationRequests()
        .then((value) => value.length);

    await flutterLocalNotificationsPlugin.show(
      id ?? ids + 1,
      data?.title ?? title,
      data?.body ?? body,
      platformChannelSpecifics,
      payload: data?.toRawJson() ?? payload,
    );
  }

  ///Cancel a notification
  Future<void> cancel({int id = 0, String? tag}) async {
    await flutterLocalNotificationsPlugin.cancel(id, tag: tag);
  }

  // Future<StyleInformation> _getNotificationStyle(NotificationData data) async {
  //   switch (data.style) {
  //     case 'BIG_PICTURE':
  //       final bigPicturePath = ByteArrayAndroidBitmap(
  //         await _getByteArrayFromUrl(
  //           data.image ?? '',
  //         ),
  //       );
  //       return BigPictureStyleInformation(
  //         bigPicturePath,
  //         // largeIcon: largeIcon,
  //         contentTitle: 'overridden <b>big</b> content title',
  //         htmlFormatContentTitle: true,
  //         summaryText: 'summary <i>text</i>',
  //         htmlFormatSummaryText: true,
  //       );

  //     default:
  //       return BigTextStyleInformation(
  //         data.body,
  //       );
  //   }
  // }

  ///Create a new Notification Channel Group
  Future<void> createNotificationChannelGroup({
    required String channelGroupId,
    String channelGroupName = '',
    String channelGroupDescription = '',
  }) async {
    // create the group first
    final androidNotificationChannelGroup = AndroidNotificationChannelGroup(
      channelGroupId,
      channelGroupName,
      description: channelGroupDescription,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannelGroup(androidNotificationChannelGroup);
  }

  ///Create a Notification Channel
  Future<void> createNotificationChannel({
    String? channelGroupId,
    required String channelId,
    required String channelName,
    String channelDescription = '',
    Importance importance = Importance.high,
  }) async {
    // create channels associated with the group
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(
          AndroidNotificationChannel(
            channelId,
            channelName,
            description: channelDescription,
            groupId: channelGroupId,
            importance: importance,
          ),
        );
  }

  ///Deletes a Notification Channel Group
  Future<void> deleteNotificationChannelGroup(String channelGroupId) async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannelGroup(channelGroupId);
  }

  ///Deletes a Notification Channel.
  Future<void> deleteNotificationChannel(String channelId) async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannel(channelId);
  }
}
