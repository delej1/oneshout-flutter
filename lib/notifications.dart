part of 'bootstrap.dart';

//

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

const MethodChannel platform = MethodChannel('com.ebs.shout/notification');

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

String? selectedNotificationPayload;
NotificationAppLaunchDetails? notificationAppLaunchDetails;

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
// 09019017410
}

Future<void> onDidReceiveNotificationResponse(
  NotificationResponse notificationResponse,
) async {
  final payload = notificationResponse.payload;
  // getIt.get<NotificationBloc>().add(NotificationInitial());
  debugPrint('onDidReceiveNotificationResponse: $payload');

  if (notificationResponse.payload != null &&
      notificationResponse.payload!.isNotEmpty) {
    final data =
        NotificationData.fromJson(jsonDecode(payload!) as Map<String, dynamic>);
    processRemoteMessage(data);
  }
}

void processRemoteMessage(NotificationData notificationData) {
  getIt.get<NotificationBloc>().add(NotificationInitial());

  switch (notificationData.payload?['type']) {
    case 'shout-help':
      getIt
          .get<NotificationBloc>()
          .add(ShoutHelpNotification(data: notificationData));
      break;
    case 'request-location':
      getIt
          .get<NotificationBloc>()
          .add(RequestLocationNotification(data: notificationData));

      break;
    default:
  }
}

Future<void> showNotification(RemoteMessage message) async {
  // final notification = message.notification;
  final android = message.notification?.android;

  final data = message.data;
  final notificationData = NotificationData.fromJson(message.data);
  const channelId = 'com.ebs.shout.default';
  const channelName = 'shout';
  const icon = '@drawable/ic_notification_icon';

  var actions = <AndroidNotificationAction>[];
  var styleInformation = const DefaultStyleInformation(false, false);

  var androidNotificationDetails = AndroidNotificationDetails(
    channelId,
    channelName,
    actions: actions,
    styleInformation: styleInformation,
    icon: android?.smallIcon ?? icon,
  );

  if (data['type'] == 'shout-help') {
    styleInformation = BigTextStyleInformation(
      notificationData.body,
      htmlFormatBigText: true,
      contentTitle: notificationData.title,
      htmlFormatContentTitle: true,
      summaryText: 'Help needed!',
      htmlFormatSummaryText: true,
    );
    androidNotificationDetails = AndroidNotificationDetails(
      android?.channelId ?? channelId,
      channelName,
      fullScreenIntent: true,
      actions: actions,
      styleInformation: styleInformation,
      icon: icon,
    );

    if (Platform.isAndroid) {
      Future.delayed(const Duration(milliseconds: 4300), () async {
        final player = AudioPlayer();
        await player.play(AssetSource('sounds/alarm.mp3'));
      });
    }
  }

  if (data['type'] == 'cancel-shout') {
    styleInformation = BigTextStyleInformation(
      notificationData.body,
      htmlFormatBigText: true,
      contentTitle: notificationData.title,
      htmlFormatContentTitle: true,
      // summaryText: 'Help needed!',
      htmlFormatSummaryText: true,
    );
    androidNotificationDetails = AndroidNotificationDetails(
      android?.channelId ?? channelId,
      channelName,
      fullScreenIntent: true,
      actions: actions,
      styleInformation: styleInformation,
      icon: icon,
    );

    if (Platform.isAndroid) {
      Future.delayed(const Duration(milliseconds: 4300), () async {
        final player = AudioPlayer();
        await player.play(AssetSource('sounds/alarm.mp3'));
      });
    }
  }

  if (data['type'] == 'request-location') {
    // actions = [
    //   const AndroidNotificationAction(
    //     'btn-accept',
    //     'Accept',
    //   ),
    //   const AndroidNotificationAction('btn-cancel', 'Reject')
    // ];
    styleInformation = BigTextStyleInformation(
      notificationData.body,
      contentTitle: notificationData.title,
    );

    androidNotificationDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      actions: actions,
      styleInformation: styleInformation,
      icon: icon,
    );
  }

  // If `onMessage` is triggered with a notification, construct our own
  // local notification to show to users using the created channel.
  // if (notification != null && android != null) {
  await flutterLocalNotificationsPlugin.show(
    notificationData.id,
    notificationData.title,
    notificationData.body,
    NotificationDetails(
      android: androidNotificationDetails,
    ),
    payload: jsonEncode(message.data),
  );
  // }
}

Future<void> initNotifications() async {
  notificationAppLaunchDetails = !kIsWeb && Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload =
        notificationAppLaunchDetails!.notificationResponse?.payload;
  }

  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final initializationSettingsDarwin = DarwinInitializationSettings(
    // requestAlertPermission: true,
    // requestBadgePermission: false,
    // requestSoundPermission: false,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationStream.add(
        ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      );
    },
    // notificationCategories: darwinNotificationCategories,
  );

  final initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(
        const AndroidNotificationChannel(
          'com.ebs.shout.channel',
          'Emergency Notifications',
          importance: Importance.max,
          sound: RawResourceAndroidNotificationSound('alarm'),
        ),
      );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(
        const AndroidNotificationChannel(
          'com.ebs.shout.default.channel',
          'General Notifications',
          importance: Importance.max,
        ),
      );

  // await FirebaseMessaging.instance.getInitialMessage().then((message) {
  //   print('getInitialMessage');
  //   if (message != null) {
  //     print('getInitialMessage: Received ${message.data}');
  //     final notificationData = NotificationData.fromJson(message.data);
  //     final payload = notificationData.payload;

  //     if (payload != null && payload.isNotEmpty) {
  //       processRemoteMessage(notificationData);
  //     }
  //   }
  // });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print('onMessageOpenedApp');
    final notificationData = NotificationData.fromJson(message.data);
    final payload = notificationData.payload;

    if (payload != null && payload.isNotEmpty) {
      processRemoteMessage(notificationData);
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('onMessage');
    if (Platform.isAndroid) {
      showNotification(message);
    }
  });
}
