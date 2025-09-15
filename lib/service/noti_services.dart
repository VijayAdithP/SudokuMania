// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:timezone/timezone.dart' as tz;
// // import 'package:timezone/data/latest_all.dart' as tz;

// // class NotificationHelper {
// //   static final _notification = FlutterLocalNotificationsPlugin();

// //   static init() async {
// //     await _notification.initialize(const InitializationSettings(
// //       android: AndroidInitializationSettings("@mipmap/ic_launcher"),
// //     ));
// //     tz.initializeTimeZones();
// //   }

// //   static scheduleNotification(
// //     String title,
// //     String body,
// //     int userDayInput,
// //   ) async {
// //     var androidDetails = const AndroidNotificationDetails(
// //       "important_notification",
// //       "My Channel",
// //       importance: Importance.max,
// //       priority: Priority.high,
// //     );
// //     var notificationDetails = NotificationDetails(android: androidDetails);
// //     await _notification.zonedSchedule(
// //       0,
// //       title,
// //       body,
// //       tz.TZDateTime.now(tz.local).add(Duration(
// //         seconds: userDayInput,
// //       )),
// //       notificationDetails,
// //       uiLocalNotificationDateInterpretation:
// //           UILocalNotificationDateInterpretation.absoluteTime,
// //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
// //     );
// //   }

// //   cancelAllNotifications() {
// //     _notification.cancelAll();
// //   }
// // }

// import 'dart:developer' show log;

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;

// class NotiServices {
//   final notificationsPlugin = FlutterLocalNotificationsPlugin();
//   bool _isInitialized = false;
//   bool get isInitilized => _isInitialized;
//   Future<void> initNotification() async {
//     if (_isInitialized) return;

//     tz.initializeTimeZones();
//     final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(currentTimeZone));
//     const initSettingsAndroid = AndroidInitializationSettings("@mipmap/sudoku");

//     const initSettingsIOS = DarwinInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//     );

//     const initSettings = InitializationSettings(
//       android: initSettingsAndroid,
//       iOS: initSettingsIOS,
//     );
//     await notificationsPlugin.initialize(initSettings);
//     _isInitialized = true;
//   }

// NotificationDetails notificationDetails() {
//   return const NotificationDetails(
//     android: AndroidNotificationDetails(
//       "channelId",
//       "channelName",
//       channelDescription: "channelDescription",
//       icon: "@mipmap/sudoku",
//       importance: Importance.max,
//       priority: Priority.high,
//     ),
//     iOS: DarwinNotificationDetails(),
//   );
// }

//   Future<void> showNotification({
//     int id = 0,
//     String? title,
//     String? body,
//   }) async {
//     await notificationsPlugin.show(
//       id,
//       title,
//       body,
//       notificationDetails(),
//     );
//   }

// Future<void> scheculeNotification({
//   int id = 1,
//   required String title,
//   required String body,
//   required int hour,
//   required int minute,
// }) async {
//   final now = tz.TZDateTime.now(tz.local);
//   var scheduleDate = tz.TZDateTime(
//     tz.local,
//     now.year,
//     now.month,
//     now.day,
//     hour,
//     minute,
//   );
//   await notificationsPlugin.zonedSchedule(
//     id, title, body, scheduleDate, notificationDetails(),
//     // iOS specific: use exact time specifiec( vs relative time)
//     uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,

//     // android specific: allow the notification to be in low power mode
//     androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
//     matchDateTimeComponents: DateTimeComponents.time,
//   );
//   log("notif scheduled");
// }

//   Future<void> cancelNotification(int id) async {
//     await notificationsPlugin.cancelAll();
//   }
// }

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:sudokumania/service/hive_service.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotiServices {
//   final notificationsPlugin = FlutterLocalNotificationsPlugin();
//   bool _isInitialized = false;

//   Future<void> initNotification() async {
//     if (_isInitialized) return;

//     tz.initializeTimeZones();
//     final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(currentTimeZone));

//     const initSettingsAndroid = AndroidInitializationSettings("@mipmap/sudoku");
//     const initSettingsIOS = DarwinInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//     );

//     const initSettings = InitializationSettings(
//       android: initSettingsAndroid,
//       iOS: initSettingsIOS,
//     );

//     await notificationsPlugin.initialize(initSettings);
//     _isInitialized = true;
//   }

//   Future<void> enableNotifications() async {
//     await HiveService.saveNotificationPreference(true);
//     await scheduleRepeatingNotification();
//   }

//   Future<void> disableNotifications() async {
//     await HiveService.saveNotificationPreference(false);
//     await cancelAllNotifications();
//   }

//   Future<bool> areNotificationsEnabled() async {
//     return await HiveService.getNotificationPreference();
//   }

//   Future<void> scheduleRepeatingNotification() async {
//     final isEnabled = await areNotificationsEnabled();
//     if (!isEnabled) return;

//     const androidDetails = AndroidNotificationDetails(
//       "channelId",
//       "channelName",
//       channelDescription: "channelDescription",
//       icon: "@mipmap/sudoku",
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const notificationDetails = NotificationDetails(android: androidDetails);

//     await notificationsPlugin.periodicallyShow(
//       androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
//       0,
//       "Repeating Notification",
//       "This notification repeats every 5 seconds",
//       RepeatInterval.everyMinute, // Adjust this to match your interval
//       notificationDetails,
//     );
//   }

//   Future<void> cancelAllNotifications() async {
//     await notificationsPlugin.cancelAll();
//   }
// }
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:sudokumania/service/hive_service.dart';
import 'dart:developer' as dev;

// class NotiServices {
//   final notificationsPlugin = FlutterLocalNotificationsPlugin();
//   bool _isInitialized = false;

//   Future<void> initNotification() async {
//     if (_isInitialized) return;

//     tz.initializeTimeZones();
//     final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(currentTimeZone));

//     const initSettingsAndroid = AndroidInitializationSettings("@mipmap/sudoku");
//     const initSettingsIOS = DarwinInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//     );

//     const initSettings = InitializationSettings(
//       android: initSettingsAndroid,
//       iOS: initSettingsIOS,
//     );

//     await notificationsPlugin.initialize(initSettings);
//     _isInitialized = true;

//     // Schedule the default daily notification at 10:00 AM
//     await scheduleDailyNotification(
//       title: "Daily Reminder",
//       body: "Don't forget to play Sudoku today!",
//       hour: 10,
//       minute: 0,
//     );
//   }

//   Future<void> enableNotifications() async {
//     await HiveService.saveNotificationPreference(true);
//     await scheduleDailyNotification(
//       title: "Daily Reminder",
//       body: "Don't forget to play Sudoku today!",
//       hour: 10,
//       minute: 0,
//     );
//   }

//   Future<void> disableNotifications() async {
//     await HiveService.saveNotificationPreference(false);
//     await cancelAllNotifications();
//   }

//   Future<bool> areNotificationsEnabled() async {
//     return await HiveService.getNotificationPreference();
//   }

//   Future<void> scheduleDailyNotification({
//     required String title,
//     required String body,
//     required int hour,
//     required int minute,
//   }) async {
//     final isEnabled = await areNotificationsEnabled();
//     if (!isEnabled) return;

//     final androidDetails = const AndroidNotificationDetails(
//       "channelId",
//       "channelName",
//       channelDescription: "channelDescription",
//       icon: "@mipmap/sudoku",
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     final notificationDetails = NotificationDetails(android: androidDetails);

//     final now = tz.TZDateTime.now(tz.local);
//     var scheduledDate = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       hour,
//       minute,
//     );

//     // If the scheduled time is in the past, schedule it for the next day
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }

//     await notificationsPlugin.zonedSchedule(
//       0,
//       title,
//       body,
//       scheduledDate,
//       notificationDetails,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
//       matchDateTimeComponents:
//           DateTimeComponents.time, // Repeat daily at the same time
//     );

//     dev.log("Daily notification scheduled at $scheduledDate");
//   }

//   Future<void> cancelAllNotifications() async {
//     await notificationsPlugin.cancelAll();
//     dev.log("All notifications canceled");
//   }
// }
class NotiServices {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings("@mipmap/sudoku");
    const DarwinInitializationSettings initSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    await notificationsPlugin.initialize(initSettings);
    _isInitialized = true;

    log("Notifications initialized successfully");
  }

  Future<void> enableNotifications() async {
    await HiveService.saveNotificationPreference(true);
    await scheduleDailyNotification(
      title: "Daily Reminder",
      body: "Don't forget to play Sudoku today!",
      hour: 18,
      minute: 15,
    );
  }

  Future<void> disableNotifications() async {
    await HiveService.saveNotificationPreference(false);
    await cancelAllNotifications();
  }

  Future<bool> areNotificationsEnabled() async {
    return await HiveService.getNotificationPreference();
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "channelId",
        "channelName",
        channelDescription: "channelDescription",
        icon: "@mipmap/sudoku",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> scheduleDailyNotification({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final isEnabled = await areNotificationsEnabled();
    if (!isEnabled) return;

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the scheduled time is in the past, schedule it for the next day
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    // Log the scheduled time
    log("Scheduled notification for: $scheduledDate");

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents:
          DateTimeComponents.time, // Repeat daily at the same time
    );

    dev.log("Daily notification scheduled at $scheduledDate");
  }

  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
    dev.log("All notifications canceled");
  }
}
