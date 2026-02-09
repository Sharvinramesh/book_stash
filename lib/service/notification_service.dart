// ignore_for_file: avoid_returning_null_for_void, avoid_print

import 'package:book_stash/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationHelper {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      sound: true,
    );

    // get the device token
    final token = await _firebaseMessaging.getToken();
    print("device token: $token");
  }

  static Future localNotificationInitialization() async {
    // android
    const AndroidInitializationSettings initializationSettingsForAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // ios
    final DarwinInitializationSettings initializationSettingsForIos =
    DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );

    final InitializationSettings initializationSettings= InitializationSettings(android:
    initializationSettingsForAndroid,
    iOS: initializationSettingsForIos
    );

    // permisions for android 13 or above
    _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onDidReceiveNotificationResponse:onNotificationTap,
    onDidReceiveBackgroundNotificationResponse:onNotificationTap,
    );
  }

  // on tap local notification

  static void onNotificationTap(NotificationResponse notificationResponse){
  navigatorKey.currentState!.pushNamed("/message",arguments:notificationResponse);
  }

  static Future showLocalNotification({
    required String title,
    required String body,
    required String payload
  })async{
    const androidNotificationDetails=AndroidNotificationDetails(
    'channel id',
    'channel name',
    channelDescription:'channel description',
    importance: Importance.max,
    priority:Priority.high,
    ticker:'ticker'
    );
    const NotificationDetails notificationDetails=NotificationDetails(android:androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails,payload:payload);
  }
}
