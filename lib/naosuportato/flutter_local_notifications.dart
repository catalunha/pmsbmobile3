import 'package:pmsbmibile3/naosuportato/empty.dart';

class FlutterLocalNotificationsPlugin extends Empty {
    Future<void> show(int id, String title, String body,
        dynamic notificationDetails,
        {String payload}) async{}
}

class AndroidNotificationDetails extends Empty {
  AndroidNotificationDetails(
      dynamic channelId, dynamic channelName, dynamic channelDescription,
      {dynamic icon,
      dynamic importance,
      dynamic priority,
      dynamic style,
      dynamic styleInformation,
      dynamic playSound = true,
      dynamic sound,
      dynamic enableVibration = true,
      dynamic vibrationPattern,
      dynamic groupKey,
      dynamic setAsGroupSummary,
      dynamic groupAlertBehavior,
      dynamic autoCancel = true,
      dynamic ongoing,
      dynamic color,
      dynamic largeIcon,
      dynamic largeIconBitmapSource,
      dynamic onlyAlertOnce,
      dynamic channelShowBadge = true,
      dynamic showProgress = false,
      dynamic maxProgress = 0,
      dynamic progress = 0,
      dynamic indeterminate = false,
      dynamic channelAction,
      dynamic enableLights = false,
      dynamic ledColor,
      dynamic ledOnMs,
      dynamic ledOffMs,
      dynamic ticker});
}

class Importance extends Empty {
  static dynamic Max;
}

class Priority extends Empty {
    static dynamic High;
}

class NotificationDetails {
    /// Notification details for Android
    final AndroidNotificationDetails android;

    /// Notification details for iOS
    final IOSNotificationDetails iOS;

    const NotificationDetails(this.android, this.iOS);
}

class IOSNotificationDetails {
    // Display an alert when the notification is triggered while app is in the foreground. iOS 10+ only
    final bool presentAlert;

    /// Play a sound when the notification is triggered while app is in the foreground. iOS 10+ only
    final bool presentSound;

    /// Apply the badge value when the notification is triggered while app is in the foreground. iOS 10+ only
    final bool presentBadge;

    /// Specifies the name of the file to play for the notification. Requires setting [presentSound] to true. If [presentSound] is set to true but [sound] isn't specified then it will use the default notification sound.
    final String sound;

    IOSNotificationDetails(
        {this.presentAlert, this.presentBadge, this.presentSound, this.sound});

    Map<String, dynamic> toMap() {
        return <String, dynamic>{
            'presentAlert': presentAlert,
            'presentSound': presentSound,
            'presentBadge': presentBadge,
            'sound': sound
        };
    }
}
