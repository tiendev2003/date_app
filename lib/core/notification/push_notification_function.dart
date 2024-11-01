// ignore_for_file: avoid_print

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../config/config.dart';

Future<void> initPlatformState() async {
  OneSignal.shared.setAppId(Config.oneSignel);
  OneSignal.shared
      .promptUserForPushNotificationPermission()
      .then((accepted) {});
  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    print("Accepted OSPermissionStateChanges : $changes");
  });
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
