import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  if (notificationResponse != null) {
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.id}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      print('notification action tapped with input: ${notificationResponse
          .input}');
    }
  }
}

class LocalNotificationService {
  //helping material
  /// https://www.youtube.com/watch?v=Ap00Wn_v4NY
  String channelId = 'abc_sound1';
  String channelName = 'xyz1';
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidInitializationSettings =
  AndroidInitializationSettings('ic_notification');

  final StreamController<String?> selectNotificationStream =
  StreamController<String?>.broadcast();


  void initializNotifications() async {
    InitializationSettings initializationSettings =
    InitializationSettings(android: _androidInitializationSettings);
    tz.initializeTimeZones();
    tz.setLocalLocation(
      tz.getLocation(
        await FlutterNativeTimezone.getLocalTimezone(),
      ),
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();
  }

  void sendNotification(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      //playSound: true,
      //sound: RawResourceAndroidNotificationSound("check_sound"),//working fine but was noise
    );

    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    print('shoing notification....send 1');
    await _flutterLocalNotificationsPlugin.show(
        5, title, body, notificationDetails);

    print('shoing notification....send 2');
  }

  void scheduleNotification(String title, String body, DateTime time_of_alarm,
      int noti_id) async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound("check_sound"),
    );

    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    print('shoing notification....schedule 1   ${noti_id}');
    //await _flutterLocalNotificationsPlugin.periodicallyShow(1, title, body, RepeatInterval.values.first, notificationDetails);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        noti_id,
        title,
        body,
        tz.TZDateTime.from(time_of_alarm, tz.local),
        //.now(tz.local).add(Duration(minutes: delay_min)),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
    print('scheduled notification with id ${noti_id} at ${time_of_alarm}');
  }

  void periodicallyNotification(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      //playSound: true,
      sound: RawResourceAndroidNotificationSound("check_sound"),
    );

    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    print('shoing notification....periodic 4');
    await _flutterLocalNotificationsPlugin.periodicallyShow(
        19, title, body, RepeatInterval.everyMinute, notificationDetails);
    print('shoing notification.... periodic 5');
  }

  void stopAllNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
