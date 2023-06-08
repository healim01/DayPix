import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FlutterLocalNotification {
  FlutterLocalNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static init() async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static requestNotificationPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> showNotification() async {
    print("hey");
    tz.initializeTimeZones();

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            importance: Importance.max,
            priority: Priority.max,
            showWhen: false);

    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: DarwinNotificationDetails(badgeNumber: 1));

    makeDate(hour, min, sec) {
      var now = tz.TZDateTime.now(tz.local);
      var when =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min, sec);
      if (when.isBefore(now)) {
        print("object");
        return when.add(const Duration(days: 1));
      } else {
        return when;
      }
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daypix',
      '오늘 하루는 어떠셨나요? 데이픽스에 적어보세요!',
      // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      makeDate(4, 20, 0),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    // await flutterLocalNotificationsPlugin.showDailyAtTime(
    //   0,
    //   '매일 똑같은 시간의 Notification',
    //   '매일 똑같은 시간의 Notification 내용',
    //   time,
    //   detail,
    //   payload: 'Hello Flutter',
    // );
  }
}
