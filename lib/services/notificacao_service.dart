import 'dart:convert';
import 'dart:io';
import 'package:pmsbmibile3/naosuportato/firebase_messaging.dart' show FirebaseMessaging;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificacaoService {
  static dynamic _firebaseMessaging = new FirebaseMessaging();
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  static void registerNotification() {
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print(' ----------------- \n onMessage: $message');
      _showNotification(message['notification']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('----------------- \n onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('----------------- \n onLaunch: $message');
      return;
    });
  }

  static void _showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }
}
