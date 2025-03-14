// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sudokumania/service/noti_services.dart';

// final notificationProvider = NotifierProvider<NotificationNotifier, bool>(
//   NotificationNotifier.new,
// );

// class NotificationNotifier extends Notifier<bool> {
//   final NotiServices _notiServices = NotiServices();

//   @override
//   bool build() {
//     // Initialize with a default value (e.g., false)
//     _loadNotificationPreference();
//     return false;
//   }

//   Future<void> _loadNotificationPreference() async {
//     // Fetch the actual value from Hive
//     final isEnabled = await _notiServices.areNotificationsEnabled();
//     // Update the state
//     state = isEnabled;
//   }

//   Future<void> toggleNotifications(bool isEnabled) async {
//     if (isEnabled) {
//       await _notiServices.enableNotifications();
//     } else {
//       await _notiServices.disableNotifications();
//     }
//     state = isEnabled;
//   }
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudokumania/service/noti_services.dart';

final notificationProvider = NotifierProvider<NotificationNotifier, bool>(
  NotificationNotifier.new,
);

class NotificationNotifier extends Notifier<bool> {
  final NotiServices _notiServices = NotiServices();

  @override
  bool build() {
    // Initialize with a default value (e.g., false)
    _loadNotificationPreference();
    return true;
  }

  Future<void> _loadNotificationPreference() async {
    // Fetch the actual value from Hive
    final isEnabled = await _notiServices.areNotificationsEnabled();
    // Update the state
    state = isEnabled;
  }

  Future<void> toggleNotifications(bool isEnabled) async {
    if (isEnabled) {
      await _notiServices.enableNotifications();
    } else {
      await _notiServices.disableNotifications();
    }
    state = isEnabled;
  }

  // Add this method
  Future<bool> areNotificationsEnabled() async {
    return await _notiServices.areNotificationsEnabled();
  }
}
