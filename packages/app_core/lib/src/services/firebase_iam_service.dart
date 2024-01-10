import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:injectable/injectable.dart';

@singleton
class InAppMessagingService {
  static FirebaseInAppMessaging fiam = FirebaseInAppMessaging.instance;

  Future<void> triggerEvent(String eventName) async {
    await fiam.triggerEvent(eventName);
  }
}
